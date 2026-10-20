import http from 'node:http';
import fs from 'node:fs';
import fsp from 'node:fs/promises';
import path from 'node:path';
import crypto from 'node:crypto';
import { Transform } from 'node:stream';
import { pipeline } from 'node:stream/promises';
import { fileURLToPath } from 'node:url';

const root = path.dirname(fileURLToPath(import.meta.url));
const publicDir = path.join(root, 'public');
const mediaDir = path.join(root, 'media');
const runtimeDir = path.join(root, 'runtime');
const tracksFile = path.join(root, 'tracks.json');
const recordingsFile = path.join(root, 'recordings.json');
const liveFile = path.join(runtimeDir, 'live.json');
const metricsFile = path.join(runtimeDir, 'metrics.json');

function readEnv() {
  const envFile = path.join(root, '.env');
  if (!fs.existsSync(envFile)) return;
  for (const line of fs.readFileSync(envFile, 'utf8').split(/\r?\n/)) {
    const match = line.match(/^\s*([A-Z_][A-Z_0-9]*)=(.*)\s*$/);
    if (!match || process.env[match[1]] !== undefined) continue;
    let value = match[2].trim();
    if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) value = value.slice(1, -1);
    process.env[match[1]] = value;
  }
}
readEnv();

const host = process.env.HOST || '127.0.0.1';
const port = Number(process.env.PORT || 4178);
const adminPassword = process.env.RADIO_ADMIN_PASSWORD || '';
const configuredLiveUrl = process.env.RADIO_LIVE_URL || '';
const channels = [
  { id: 'ambient', name: 'Ambient', tagline: 'Пространство для мыслей', description: 'Спокойный атмосферный фон для работы и отдыха.', color: '#9e9cf5', number: '01' },
  { id: 'chill', name: 'Chill', tagline: 'Тёплый ритм дня', description: 'Мягкий downtempo и lounge без спешки.', color: '#f2ad88', number: '02' },
  { id: 'jazz', name: 'Jazz Ballads', tagline: 'Вечер в медленном темпе', description: 'Лирические джазовые баллады и тихие мелодии.', color: '#e9bd79', number: '03' },
  { id: 'cosmic', name: 'Cosmic', tagline: 'За пределами привычного', description: 'Психоделический рок, мистическая электроника и атмосферные путешествия.', color: '#a7b4ef', number: '04' },
  { id: 'spectrum', name: 'Flumos Spectrum', artworkName: 'Spectrum', tagline: 'Авторское без границ жанра', description: 'Песни и инструментальная музыка Flumos: написанные самостоятельно или с помощью Suno.', color: '#f1a6c8', number: '05' }
];

await fsp.mkdir(mediaDir, { recursive: true });
await fsp.mkdir(runtimeDir, { recursive: true });
if (!fs.existsSync(tracksFile)) await fsp.writeFile(tracksFile, '[]\n');
if (!fs.existsSync(recordingsFile)) await fsp.writeFile(recordingsFile, '[]\n');
let tracks = JSON.parse(await fsp.readFile(tracksFile, 'utf8'));
if (!Array.isArray(tracks)) throw new Error('tracks.json must be an array');
let recordings = JSON.parse(await fsp.readFile(recordingsFile, 'utf8'));
if (!Array.isArray(recordings)) throw new Error('recordings.json must be an array');
let metrics = { visitors: {} };
try { metrics = JSON.parse(await fsp.readFile(metricsFile, 'utf8')); } catch { /* Fresh installation. */ }
if (!metrics.visitors || typeof metrics.visitors !== 'object') metrics = { visitors: {} };
let live = { on: false, title: 'Прямой эфир', streamUrl: configuredLiveUrl };
try {
  const saved = JSON.parse(await fsp.readFile(liveFile, 'utf8'));
  live.title = typeof saved.title === 'string' ? saved.title : live.title;
} catch { /* Runtime state is optional. Never resume an old live flag after restart. */ }

const sessions = new Map();
const loginAttempts = new Map();
const chat = [];
const blockedIps = new Set();
const chatRate = new Map();
let messageCounter = 0;

function sendJson(res, status, data, extra = {}) {
  const body = JSON.stringify(data);
  res.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8', 'Content-Length': Buffer.byteLength(body), 'Cache-Control': 'no-store', ...extra });
  res.end(body);
}

function sendError(res, status, message) { sendJson(res, status, { error: message }); }
function getIp(req) { return req.socket.remoteAddress || 'unknown'; }
function safeText(value, max) { return typeof value === 'string' ? value.trim().slice(0, max) : ''; }
function validId(value) { return typeof value === 'string' && /^[0-9a-f-]{36}$/.test(value); }
function publicTrack(track) {
  return { id: track.id, title: track.title, artist: track.artist, channel: track.channel, duration: track.duration, audioUrl: `/media/${track.audioId}.mp3`, coverUrl: track.coverId ? `/media/${track.coverId}${track.coverExt}` : null };
}
function publicRecording(recording) {
  return { id: recording.id, title: recording.title, date: recording.date, duration: recording.duration, audioUrl: `/media/${recording.audioId}.mp3` };
}

async function readBody(req, limit) {
  const parts = [];
  let size = 0;
  for await (const chunk of req) {
    size += chunk.length;
    if (size > limit) { const error = new Error('Слишком большой файл или запрос'); error.status = 413; throw error; }
    parts.push(chunk);
  }
  return Buffer.concat(parts);
}

async function readJson(req, limit = 64 * 1024) {
  const buffer = await readBody(req, limit);
  try { return JSON.parse(buffer.toString('utf8')); }
  catch { const error = new Error('Некорректный JSON'); error.status = 400; throw error; }
}

async function saveJson(file, value) {
  const tmp = `${file}.${process.pid}.tmp`;
  await fsp.writeFile(tmp, `${JSON.stringify(value, null, 2)}\n`);
  await fsp.rename(tmp, file);
}

function sessionFrom(req) {
  const cookie = (req.headers.cookie || '').split(';').map(part => part.trim()).find(part => part.startsWith('flumos_session='));
  if (!cookie) return null;
  const token = cookie.slice('flumos_session='.length);
  const session = sessions.get(token);
  if (!session || session.expires < Date.now()) { sessions.delete(token); return null; }
  return { token, session };
}

function requireAdmin(req, res) {
  if (!sessionFrom(req)) { sendError(res, 401, 'Требуется вход администратора'); return false; }
  return true;
}

function samePassword(candidate) {
  const a = crypto.createHash('sha256').update(candidate).digest();
  const b = crypto.createHash('sha256').update(adminPassword).digest();
  return crypto.timingSafeEqual(a, b);
}

function isValidLiveUrl(url) {
  try {
    const parsed = new URL(url);
    return parsed.protocol === 'https:' || (parsed.protocol === 'http:' && ['localhost', '127.0.0.1'].includes(parsed.hostname));
  } catch { return false; }
}

function mediaType(buffer, kind) {
  if (['audio', 'recording'].includes(kind) && (buffer.subarray(0, 3).toString() === 'ID3' || (buffer[0] === 0xff && (buffer[1] & 0xe0) === 0xe0))) return { ext: '.mp3', mime: 'audio/mpeg' };
  if (kind === 'cover' && buffer.subarray(0, 8).equals(Buffer.from([137,80,78,71,13,10,26,10]))) return { ext: '.png', mime: 'image/png' };
  if (kind === 'cover' && buffer[0] === 0xff && buffer[1] === 0xd8) return { ext: '.jpg', mime: 'image/jpeg' };
  if (kind === 'cover' && buffer.subarray(0, 4).toString() === 'RIFF' && buffer.subarray(8, 12).toString() === 'WEBP') return { ext: '.webp', mime: 'image/webp' };
  return null;
}

async function serveFile(req, res, file, mime, rangeEnabled = false) {
  let stat;
  try { stat = await fsp.stat(file); } catch { return sendError(res, 404, 'Файл не найден'); }
  if (!stat.isFile()) return sendError(res, 404, 'Файл не найден');
  const headers = { 'Content-Type': mime, 'Accept-Ranges': rangeEnabled ? 'bytes' : 'none', 'X-Content-Type-Options': 'nosniff' };
  if (rangeEnabled && req.headers.range) {
    const match = /^bytes=(\d*)-(\d*)$/.exec(req.headers.range);
    if (!match) { res.writeHead(416, { 'Content-Range': `bytes */${stat.size}` }); return res.end(); }
    const suffix = match[1] === '';
    const start = suffix ? Math.max(0, stat.size - Number(match[2])) : Number(match[1]);
    const end = suffix ? stat.size - 1 : match[2] ? Math.min(stat.size - 1, Number(match[2])) : stat.size - 1;
    if (!Number.isInteger(start) || !Number.isInteger(end) || start > end || start >= stat.size) { res.writeHead(416, { 'Content-Range': `bytes */${stat.size}` }); return res.end(); }
    res.writeHead(206, { ...headers, 'Content-Range': `bytes ${start}-${end}/${stat.size}`, 'Content-Length': end - start + 1 });
    return fs.createReadStream(file, { start, end }).pipe(res);
  }
  res.writeHead(200, { ...headers, 'Content-Length': stat.size, 'Cache-Control': rangeEnabled ? 'public, max-age=3600' : 'no-cache' });
  fs.createReadStream(file).pipe(res);
}

const mimeTypes = { '.html': 'text/html; charset=utf-8', '.css': 'text/css; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.svg': 'image/svg+xml', '.ico': 'image/x-icon' };

let metricsDirty = false;
const metricsInterval = setInterval(async () => {
  if (!metricsDirty) return;
  metricsDirty = false;
  try { await saveJson(metricsFile, metrics); } catch (error) { metricsDirty = true; console.error('Metrics save failed:', error); }
}, 60_000);
if (process.env.NODE_ENV === 'test') metricsInterval.unref();

const server = http.createServer(async (req, res) => {
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
  res.setHeader('X-Content-Type-Options', 'nosniff');
  const url = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
  const pathname = url.pathname;
  try {
    if (pathname === '/api/catalog' && req.method === 'GET') return sendJson(res, 200, { channels, tracks: tracks.map(publicTrack) });
    if (pathname === '/api/status' && req.method === 'GET') return sendJson(res, 200, live);
    if (pathname === '/api/recordings' && req.method === 'GET') return sendJson(res, 200, { recordings: recordings.map(publicRecording).sort((a, b) => b.date.localeCompare(a.date)) });
    if (pathname === '/api/listen' && req.method === 'POST') {
      const body = await readJson(req, 2048);
      if (!validId(body.visitorId) || ![...channels.map(channel => channel.id), 'live', 'recording'].includes(body.channel) || !['start', 'minute'].includes(body.event)) return sendError(res, 400, 'Некорректное событие');
      const id = crypto.createHash('sha256').update(body.visitorId).digest('hex');
      const today = new Date().toISOString().slice(0, 10);
      const visitor = metrics.visitors[id] || { days: [], minutes: 0, starts: 0 };
      if (!visitor.days.includes(today)) visitor.days.push(today);
      if (body.event === 'start') visitor.starts += 1;
      else visitor.minutes += 1;
      metrics.visitors[id] = visitor;
      metricsDirty = true;
      return sendJson(res, 200, { ok: true });
    }

    if (pathname === '/api/admin/login' && req.method === 'POST') {
      if (!adminPassword || adminPassword === 'replace-with-a-long-private-password') return sendError(res, 503, 'Сначала задайте RADIO_ADMIN_PASSWORD в .env');
      const ip = getIp(req);
      const attempt = loginAttempts.get(ip) || { count: 0, until: 0 };
      if (attempt.until > Date.now()) return sendError(res, 429, 'Подождите перед следующей попыткой');
      const body = await readJson(req);
      if (typeof body.password !== 'string' || !samePassword(body.password)) {
        attempt.count += 1;
        attempt.until = attempt.count >= 5 ? Date.now() + 15 * 60_000 : 0;
        loginAttempts.set(ip, attempt);
        return sendError(res, 401, 'Неверный пароль');
      }
      loginAttempts.delete(ip);
      const token = crypto.randomBytes(32).toString('hex');
      sessions.set(token, { expires: Date.now() + 7 * 24 * 3600_000 });
      const secure = req.socket.encrypted || req.headers['x-forwarded-proto'] === 'https';
      return sendJson(res, 200, { ok: true }, { 'Set-Cookie': `flumos_session=${token}; HttpOnly; SameSite=Strict; Path=/; Max-Age=604800${secure ? '; Secure' : ''}` });
    }
    if (pathname === '/api/admin/logout' && req.method === 'POST') {
      const current = sessionFrom(req); if (current) sessions.delete(current.token);
      return sendJson(res, 200, { ok: true }, { 'Set-Cookie': 'flumos_session=; HttpOnly; SameSite=Strict; Path=/; Max-Age=0' });
    }
    if (pathname === '/api/admin/session' && req.method === 'GET') return sendJson(res, 200, { authenticated: Boolean(sessionFrom(req)) });
    if (pathname === '/api/admin/metrics' && req.method === 'GET') {
      if (!requireAdmin(req, res)) return;
      const cutoff = new Date(Date.now() - 6 * 24 * 3600_000).toISOString().slice(0, 10);
      const visitors = Object.values(metrics.visitors);
      return sendJson(res, 200, {
        listeners7d: visitors.filter(visitor => visitor.days.some(day => day >= cutoff)).length,
        returningListeners: visitors.filter(visitor => visitor.days.length >= 2).length,
        listeningHours: Math.round(visitors.reduce((total, visitor) => total + visitor.minutes, 0) / 60 * 10) / 10
      });
    }

    if (pathname === '/api/admin/upload' && req.method === 'POST') {
      if (!requireAdmin(req, res)) return;
      const kind = url.searchParams.get('kind');
      if (!['audio', 'recording', 'cover'].includes(kind)) return sendError(res, 400, 'Неизвестный тип файла');
      const limit = kind === 'cover' ? 5 * 1024 * 1024 : kind === 'recording' ? 500 * 1024 * 1024 : 50 * 1024 * 1024;
      const id = crypto.randomUUID();
      const tmp = path.join(mediaDir, `.upload-${id}`);
      let size = 0;
      const limiter = new Transform({ transform(chunk, encoding, callback) {
        size += chunk.length;
        if (size > limit) { const error = new Error('Слишком большой файл'); error.status = 413; callback(error); }
        else callback(null, chunk);
      } });
      try {
        await pipeline(req, limiter, fs.createWriteStream(tmp, { flags: 'wx' }));
        const handle = await fsp.open(tmp, 'r');
        const prefix = Buffer.alloc(12);
        const { bytesRead } = await handle.read(prefix, 0, 12, 0);
        await handle.close();
        const format = mediaType(prefix.subarray(0, bytesRead), kind);
        if (!format) { const error = new Error(kind === 'cover' ? 'Нужна обложка PNG, JPG или WebP' : 'Нужен MP3-файл'); error.status = 400; throw error; }
        await fsp.rename(tmp, path.join(mediaDir, `${id}${format.ext}`));
        return sendJson(res, 201, { id, ext: format.ext });
      } catch (error) {
        await fsp.rm(tmp, { force: true }).catch(() => {});
        throw error;
      }
    }
    if (pathname === '/api/admin/tracks' && req.method === 'POST') {
      if (!requireAdmin(req, res)) return;
      const body = await readJson(req);
      const title = safeText(body.title, 100);
      const artist = safeText(body.artist, 80) || 'Flumos';
      const channel = safeText(body.channel, 20);
      if (!title || !channels.some(item => item.id === channel) || !validId(body.audioId)) return sendError(res, 400, 'Проверьте название, канал и MP3');
      if (!fs.existsSync(path.join(mediaDir, `${body.audioId}.mp3`))) return sendError(res, 400, 'MP3 не найден');
      const coverId = validId(body.coverId) ? body.coverId : null;
      const coverExt = ['.png', '.jpg', '.webp'].includes(body.coverExt) ? body.coverExt : null;
      if (coverId && (!coverExt || !fs.existsSync(path.join(mediaDir, `${coverId}${coverExt}`)))) return sendError(res, 400, 'Обложка не найдена');
      const track = { id: crypto.randomUUID(), title, artist, channel, audioId: body.audioId, coverId, coverExt, duration: Number.isFinite(body.duration) && body.duration > 0 ? Math.round(body.duration) : null, addedAt: new Date().toISOString() };
      tracks.push(track);
      await saveJson(tracksFile, tracks);
      return sendJson(res, 201, publicTrack(track));
    }
    if (pathname === '/api/admin/recordings' && req.method === 'POST') {
      if (!requireAdmin(req, res)) return;
      const body = await readJson(req);
      const title = safeText(body.title, 100);
      const date = safeText(body.date, 10);
      if (!title || !/^\d{4}-\d{2}-\d{2}$/.test(date) || !validId(body.audioId) || !fs.existsSync(path.join(mediaDir, `${body.audioId}.mp3`))) return sendError(res, 400, 'Проверьте название, дату и MP3');
      const recording = { id: crypto.randomUUID(), title, date, audioId: body.audioId, duration: Number.isFinite(body.duration) && body.duration > 0 ? Math.round(body.duration) : null };
      recordings.push(recording);
      await saveJson(recordingsFile, recordings);
      return sendJson(res, 201, publicRecording(recording));
    }
    const trackDelete = /^\/api\/admin\/tracks\/([0-9a-f-]{36})$/.exec(pathname);
    if (trackDelete && req.method === 'DELETE') {
      if (!requireAdmin(req, res)) return;
      const before = tracks.length;
      tracks = tracks.filter(track => track.id !== trackDelete[1]);
      if (tracks.length === before) return sendError(res, 404, 'Трек не найден');
      await saveJson(tracksFile, tracks);
      return sendJson(res, 200, { ok: true });
    }
    if (pathname === '/api/admin/live' && req.method === 'POST') {
      if (!requireAdmin(req, res)) return;
      const body = await readJson(req);
      const streamUrl = safeText(body.streamUrl, 500) || configuredLiveUrl;
      if (body.on && !isValidLiveUrl(streamUrl)) return sendError(res, 400, 'Укажите HTTPS-ссылку на живой аудиопоток');
      live = { on: Boolean(body.on), title: safeText(body.title, 100) || 'Прямой эфир', streamUrl };
      if (!live.on) { chat.length = 0; blockedIps.clear(); chatRate.clear(); }
      await saveJson(liveFile, { title: live.title, streamUrl: live.streamUrl });
      return sendJson(res, 200, live);
    }
    if (pathname === '/api/chat' && req.method === 'GET') return sendJson(res, 200, { active: live.on, messages: live.on ? chat.map(({ ip, ...message }) => message) : [] });
    if (pathname === '/api/chat' && req.method === 'POST') {
      if (!live.on) return sendError(res, 409, 'Чат открыт только во время эфира');
      const ip = getIp(req);
      if (blockedIps.has(ip)) return sendError(res, 403, 'Доступ к чату закрыт');
      if ((chatRate.get(ip) || 0) > Date.now()) return sendError(res, 429, 'Подождите перед следующим сообщением');
      const body = await readJson(req, 4096);
      const nickname = safeText(body.nickname, 24);
      const message = safeText(body.message, 300);
      if (nickname.length < 2 || !message) return sendError(res, 400, 'Введите имя и сообщение');
      chatRate.set(ip, Date.now() + 3000);
      chat.push({ id: ++messageCounter, nickname, message, at: new Date().toISOString(), ip });
      if (chat.length > 200) chat.shift();
      return sendJson(res, 201, { ok: true });
    }
    if (pathname === '/api/admin/chat' && req.method === 'GET') { if (!requireAdmin(req, res)) return; return sendJson(res, 200, { messages: chat }); }
    const chatDelete = /^\/api\/admin\/chat\/(\d+)$/.exec(pathname);
    if (chatDelete && req.method === 'DELETE') {
      if (!requireAdmin(req, res)) return;
      const index = chat.findIndex(item => item.id === Number(chatDelete[1]));
      if (index < 0) return sendError(res, 404, 'Сообщение не найдено');
      chat.splice(index, 1);
      return sendJson(res, 200, { ok: true });
    }
    if (pathname === '/api/admin/chat/block' && req.method === 'POST') {
      if (!requireAdmin(req, res)) return;
      const body = await readJson(req);
      const selected = chat.find(item => item.id === Number(body.id));
      if (!selected) return sendError(res, 404, 'Сообщение не найдено');
      blockedIps.add(selected.ip);
      for (let index = chat.length - 1; index >= 0; index--) if (chat[index].ip === selected.ip) chat.splice(index, 1);
      return sendJson(res, 200, { ok: true });
    }

    const mediaMatch = /^\/media\/([0-9a-f-]{36})(\.mp3|\.png|\.jpg|\.webp)$/.exec(pathname);
    if (mediaMatch && req.method === 'GET') {
      const ext = mediaMatch[2];
      return serveFile(req, res, path.join(mediaDir, `${mediaMatch[1]}${ext}`), ({ '.mp3': 'audio/mpeg', '.png': 'image/png', '.jpg': 'image/jpeg', '.webp': 'image/webp' })[ext], ext === '.mp3');
    }

    if (req.method !== 'GET') return sendError(res, 404, 'Адрес не найден');
    const route = pathname === '/' ? '/index.html' : pathname === '/admin' ? '/admin.html' : pathname;
    const file = path.resolve(publicDir, `.${route}`);
    if (!file.startsWith(`${publicDir}${path.sep}`)) return sendError(res, 403, 'Доступ запрещён');
    return serveFile(req, res, file, mimeTypes[path.extname(file)] || 'application/octet-stream');
  } catch (error) {
    console.error(error);
    if (!res.headersSent) sendError(res, error.status || 500, error.status ? error.message : 'Ошибка сервера');
    else res.destroy();
  }
});

if (process.env.NODE_ENV !== 'test') server.listen(port, host, () => console.log(`Flumos Radio: http://${host}:${port}`));
export { server, channels, mediaType, isValidLiveUrl };
