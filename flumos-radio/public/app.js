const $ = selector => document.querySelector(selector);
const audio = $('#audio');
const state = { catalog: null, live: { on: false }, channel: null, queue: [], queueIndex: 0, current: null, toastTimer: null };
let visitorId;
try { visitorId = localStorage.getItem('flumosVisitorId') || crypto.randomUUID(); localStorage.setItem('flumosVisitorId', visitorId); }
catch { visitorId = crypto.randomUUID(); }
audio.volume = 0.75;
$('#year').textContent = new Date().getFullYear();
$('#chat-nickname').value = localStorage.getItem('flumosNickname') || '';

function toast(message) {
  const el = $('#toast');
  el.textContent = message;
  el.classList.add('show');
  clearTimeout(state.toastTimer);
  state.toastTimer = setTimeout(() => el.classList.remove('show'), 3200);
}

function fmt(seconds) {
  if (!Number.isFinite(seconds)) return '0:00';
  return `${Math.floor(seconds / 60)}:${String(Math.floor(seconds % 60)).padStart(2, '0')}`;
}

function shuffle(items) {
  const result = [...items];
  for (let i = result.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [result[i], result[j]] = [result[j], result[i]];
  }
  return result;
}

function recordListening(event) {
  if (!state.channel || audio.paused) return;
  fetch('/api/listen', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ visitorId, channel: state.channel, event }), keepalive: true }).catch(() => {});
}

function channelArtwork(channel) {
  return `<div class="channel-art ${channel.id}"><span class="channel-number">FLUMOS / ${channel.number}</span><span class="art-word">${channel.artworkName || channel.name}</span></div>`;
}

function renderChannels() {
  const grid = $('#channel-grid');
  grid.replaceChildren();
  for (const channel of state.catalog.channels) {
    const count = state.catalog.tracks.filter(track => track.channel === channel.id).length;
    const card = document.createElement('article');
    card.className = `channel-card${count ? ' ready' : ''}`;
    card.dataset.channel = channel.id;
    card.dataset.count = String(count);
    card.innerHTML = `${channelArtwork(channel)}<div class="channel-body"><span class="channel-tagline">${channel.tagline}</span><h3>${channel.name}</h3><p>${channel.description}</p><div class="channel-action"><span class="channel-count">${count ? `${count} ${count === 1 ? 'трек' : count < 5 ? 'трека' : 'треков'}` : 'Готовится к эфиру'}</span><button type="button" aria-label="Слушать ${channel.name}" ${count ? '' : 'disabled'}>▶</button></div></div>`;
    card.querySelector('button').addEventListener('click', event => { event.stopPropagation(); toggleChannel(channel.id); });
    if (count) card.addEventListener('click', () => toggleChannel(channel.id));
    grid.append(card);
  }
  syncChannelControls();
}

function syncChannelControls() {
  if (!state.catalog) return;
  for (const card of document.querySelectorAll('.channel-card')) {
    const count = Number(card.dataset.count);
    const channel = state.catalog.channels.find(item => item.id === card.dataset.channel);
    const active = state.channel === channel.id;
    const playing = active && !audio.paused;
    card.classList.toggle('active', active);
    card.querySelector('.channel-count').textContent = playing ? 'Сейчас играет' : active ? 'На паузе' : count ? `${count} ${count === 1 ? 'трек' : count < 5 ? 'трека' : 'треков'}` : 'Готовится к эфиру';
    const button = card.querySelector('button');
    button.textContent = playing ? '❚❚' : '▶';
    button.setAttribute('aria-label', `${playing ? 'Пауза' : 'Слушать'} ${channel.name}`);
    button.setAttribute('aria-pressed', String(playing));
  }
}

function updatePlayer() {
  const channel = state.catalog?.channels.find(item => item.id === state.channel);
  const current = state.current;
  $('#player-title').textContent = current?.title || (state.channel === 'live' ? state.live.title : 'Выберите канал');
  $('#player-subtitle').textContent = current?.artist ? `${current.artist} · ${channel?.name || 'Live'}` : state.channel === 'live' ? 'Flumos · прямой эфир' : 'Ваше радио начнётся здесь';
  $('#player-play').disabled = !audio.src;
  $('#player-next').disabled = !current || state.channel === 'live';
  $('#player-play').textContent = audio.paused ? '▶' : '❚❚';
  $('#player-play').setAttribute('aria-label', audio.paused ? 'Воспроизвести' : 'Пауза');
  const cover = $('#player-cover');
  cover.replaceChildren();
  if (current?.coverUrl) {
    const image = document.createElement('img');
    image.src = current.coverUrl;
    image.alt = '';
    cover.append(image);
  } else {
    const mark = document.createElement('span'); mark.textContent = 'F.'; cover.append(mark);
  }
  $('#player-duration').textContent = state.channel === 'live' ? 'LIVE' : fmt(audio.duration || current?.duration);
  syncChannelControls();
}

async function tryPlay() {
  try { await audio.play(); }
  catch (error) { toast(error.name === 'NotAllowedError' ? 'Браузер заблокировал звук. Нажмите ▶ ещё раз.' : 'Не удалось воспроизвести MP3. Проверьте звук браузера.'); }
}

async function startTrack(track) {
  state.current = track;
  audio.src = track.audioUrl;
  audio.load();
  updatePlayer();
  await tryPlay();
}

async function selectChannel(id) {
  const items = state.catalog.tracks.filter(track => track.channel === id);
  if (!items.length) return toast('Для этого канала пока нет треков');
  state.channel = id;
  state.queue = shuffle(items);
  state.queueIndex = 0;
  await startTrack(state.queue[0]);
}

async function toggleChannel(id) {
  if (state.channel === id && state.current) {
    if (audio.paused) await tryPlay();
    else audio.pause();
  } else await selectChannel(id);
}

async function nextTrack() {
  if (state.channel === 'live' || !state.queue.length) return;
  const previousId = state.queue[state.queueIndex]?.id;
  state.queueIndex++;
  if (state.queueIndex >= state.queue.length) {
    state.queue = shuffle(state.catalog.tracks.filter(track => track.channel === state.channel));
    if (state.queue.length > 1 && state.queue[0].id === previousId) [state.queue[0], state.queue[1]] = [state.queue[1], state.queue[0]];
    state.queueIndex = 0;
  }
  await startTrack(state.queue[state.queueIndex]);
}

async function startLive() {
  if (!state.live.on || !state.live.streamUrl) return toast('Эфир ещё не начался');
  state.channel = 'live';
  state.current = null;
  audio.src = state.live.streamUrl;
  audio.load();
  updatePlayer();
  await tryPlay();
}

async function refreshStatus() {
  try {
    const response = await fetch('/api/status', { cache: 'no-store' });
    if (!response.ok) return;
    const previous = state.live.on;
    state.live = await response.json();
    $('#nav-live-dot').classList.toggle('active', state.live.on);
    $('#live-badge').classList.toggle('on', state.live.on);
    $('#live-badge').textContent = state.live.on ? '● В ПРЯМОМ ЭФИРЕ' : 'НЕ В ЭФИРЕ';
    $('#chat-count').classList.toggle('on', state.live.on);
    $('#chat-count').textContent = state.live.on ? 'LIVE' : 'OFFLINE';
    $('#live-play').disabled = !state.live.on;
    $('#live-message').textContent = state.live.on ? state.live.title : 'Следите за анонсами. Музыкальные каналы доступны всегда.';
    $('#chat-form').hidden = !state.live.on;
    if (previous && !state.live.on && state.channel === 'live') {
      audio.pause(); audio.removeAttribute('src'); audio.load(); state.channel = null; state.current = null; updatePlayer();
    }
    if (state.live.on) refreshChat();
    else $('#chat-messages').innerHTML = '<div class="empty-chat">Чат откроется во время прямого эфира.</div>';
  } catch { /* Polling resumes on the next interval. */ }
}

async function refreshChat() {
  if (!state.live.on) return;
  try {
    const response = await fetch('/api/chat', { cache: 'no-store' });
    const data = await response.json();
    const box = $('#chat-messages');
    box.replaceChildren();
    if (!data.messages.length) {
      const empty = document.createElement('div'); empty.className = 'empty-chat'; empty.textContent = 'Пока тихо. Начните разговор.'; box.append(empty); return;
    }
    for (const message of data.messages) {
      const line = document.createElement('div'); line.className = 'chat-line';
      const nick = document.createElement('span'); nick.className = 'nick'; nick.textContent = `${message.nickname}:`;
      const time = document.createElement('time'); time.textContent = new Date(message.at).toLocaleTimeString('ru', { hour: '2-digit', minute: '2-digit' });
      const content = document.createElement('span'); content.textContent = ` ${message.message}`;
      line.append(nick, time, content); box.append(line);
    }
    box.scrollTop = box.scrollHeight;
  } catch { /* Chat reconnects with polling. */ }
}

async function refreshArchive() {
  try {
    const response = await fetch('/api/recordings');
    if (!response.ok) return;
    const { recordings } = await response.json();
    if (!recordings.length) return;
    const list = $('#archive-list'); list.replaceChildren();
    for (const recording of recordings) {
      const row = document.createElement('div'); row.className = 'archive-item';
      const info = document.createElement('div');
      const title = document.createElement('strong'); title.textContent = recording.title;
      const detail = document.createElement('span'); detail.textContent = `${new Date(recording.date).toLocaleDateString('ru')} · ${fmt(recording.duration)}`;
      info.append(title, detail);
      const button = document.createElement('button'); button.type = 'button'; button.textContent = 'Слушать ↗';
      button.addEventListener('click', async () => {
        state.channel = 'recording'; state.current = { ...recording, artist: 'Запись Live' };
        audio.src = recording.audioUrl; audio.load(); updatePlayer();
        try { await audio.play(); } catch { toast('Нажмите воспроизведение в плеере'); }
      });
      row.append(info, button); list.append(row);
    }
  } catch { /* Archive can be retried after refresh. */ }
}

$('#player-play').addEventListener('click', async () => {
  if (!audio.src) return;
  if (audio.paused) await tryPlay();
  else audio.pause();
});
$('#player-next').addEventListener('click', nextTrack);
$('#live-play').addEventListener('click', startLive);
$('#volume').addEventListener('input', event => { audio.volume = Number(event.target.value) / 100; });
$('#progress-track').addEventListener('click', event => {
  if (!audio.duration || state.channel === 'live') return;
  const ratio = (event.clientX - event.currentTarget.getBoundingClientRect().left) / event.currentTarget.clientWidth;
  audio.currentTime = Math.max(0, Math.min(audio.duration, ratio * audio.duration));
});
audio.addEventListener('ended', () => { if (state.channel !== 'recording') nextTrack(); });
audio.addEventListener('play', () => { updatePlayer(); recordListening('start'); });
audio.addEventListener('pause', updatePlayer);
audio.addEventListener('loadedmetadata', updatePlayer);
audio.addEventListener('timeupdate', () => { $('#player-elapsed').textContent = fmt(audio.currentTime); $('#progress-fill').style.width = audio.duration ? `${audio.currentTime / audio.duration * 100}%` : '0'; });
audio.addEventListener('error', () => { if (audio.src) toast('Аудио недоступно. Попробуйте другой канал.'); });
setInterval(() => recordListening('minute'), 60_000);
$('#chat-form').addEventListener('submit', async event => {
  event.preventDefault();
  const nickname = $('#chat-nickname').value.trim();
  const message = $('#chat-text').value.trim();
  localStorage.setItem('flumosNickname', nickname);
  const response = await fetch('/api/chat', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ nickname, message }) });
  const data = await response.json();
  if (!response.ok) { $('#chat-error').textContent = data.error; return; }
  $('#chat-error').textContent = '';
  $('#chat-text').value = '';
  refreshChat();
});

async function boot() {
  try {
    const response = await fetch('/api/catalog');
    if (!response.ok) throw new Error('Каталог недоступен');
    state.catalog = await response.json();
    renderChannels();
    await refreshStatus();
    await refreshArchive();
    setInterval(refreshStatus, 10000);
    setInterval(refreshChat, 3000);
  } catch { toast('Не удалось загрузить радио. Обновите страницу.'); }
}
boot();
