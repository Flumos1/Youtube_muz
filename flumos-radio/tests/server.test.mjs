import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const project = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');

test('catalog, admin upload, playback range, live chat and archive', async () => {
  const sandbox = await fs.mkdtemp(path.join(os.tmpdir(), 'flumos-radio-test-'));
  await fs.copyFile(path.join(project, 'server.mjs'), path.join(sandbox, 'server.mjs'));
  await fs.writeFile(path.join(sandbox, 'tracks.json'), '[]\n');
  await fs.writeFile(path.join(sandbox, 'recordings.json'), '[]\n');
  await fs.mkdir(path.join(sandbox, 'public'));
  await fs.copyFile(path.join(project, 'public', 'index.html'), path.join(sandbox, 'public', 'index.html'));
  const previousEnv = { password: process.env.RADIO_ADMIN_PASSWORD, mode: process.env.NODE_ENV };
  process.env.RADIO_ADMIN_PASSWORD = 'local-test-password-123456';
  process.env.NODE_ENV = 'test';
  const { server } = await import(pathToFileURL(path.join(sandbox, 'server.mjs')).href);
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  const base = `http://127.0.0.1:${server.address().port}`;
  const request = (route, options) => fetch(`${base}${route}`, options);
  let cookie;
  try {
    let response = await request('/api/catalog');
    assert.equal(response.status, 200);
    assert.equal((await response.json()).channels.length, 3);

    response = await request('/api/admin/tracks', { method: 'POST' });
    assert.equal(response.status, 401);

    response = await request('/api/admin/login', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ password: 'local-test-password-123456' }) });
    assert.equal(response.status, 200);
    cookie = response.headers.get('set-cookie').split(';')[0];
    const headers = { Cookie: cookie, 'Content-Type': 'application/json' };

    const sampleMp3 = Buffer.concat([Buffer.from('ID3'), Buffer.alloc(500, 0x41)]);
    response = await request('/api/admin/upload?kind=audio', { method: 'POST', headers: { Cookie: cookie, 'Content-Type': 'audio/mpeg' }, body: sampleMp3 });
    assert.equal(response.status, 201);
    const uploaded = await response.json();
    response = await request('/api/admin/tracks', { method: 'POST', headers, body: JSON.stringify({ title: 'Тестовая композиция', artist: 'Flumos', channel: 'ambient', audioId: uploaded.id, duration: 12 }) });
    assert.equal(response.status, 201);
    const track = await response.json();
    response = await request('/api/catalog');
    assert.equal((await response.json()).tracks.length, 1);
    response = await request(track.audioUrl, { headers: { Range: 'bytes=0-2' } });
    assert.equal(response.status, 206);
    assert.equal(await response.text(), 'ID3');

    response = await request('/api/admin/live', { method: 'POST', headers, body: JSON.stringify({ on: true, title: 'Тест Live', streamUrl: 'http://127.0.0.1:8000/live.mp3' }) });
    assert.equal(response.status, 200);
    response = await request('/api/chat', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ nickname: 'Слушатель', message: 'Привет!' }) });
    assert.equal(response.status, 201);
    response = await request('/api/chat');
    assert.equal((await response.json()).messages[0].message, 'Привет!');
    response = await request('/api/admin/chat/block', { method: 'POST', headers, body: JSON.stringify({ id: 1 }) });
    assert.equal(response.status, 200);
    response = await request('/api/chat');
    assert.equal((await response.json()).messages.length, 0);

    response = await request('/api/admin/upload?kind=recording', { method: 'POST', headers: { Cookie: cookie, 'Content-Type': 'audio/mpeg' }, body: sampleMp3 });
    assert.equal(response.status, 201);
    const recordingUpload = await response.json();
    response = await request('/api/admin/recordings', { method: 'POST', headers, body: JSON.stringify({ title: 'Первый эфир', date: '2026-10-20', audioId: recordingUpload.id, duration: 120 }) });
    assert.equal(response.status, 201);
    response = await request('/api/recordings');
    assert.equal((await response.json()).recordings.length, 1);
  } finally {
    await new Promise(resolve => server.close(resolve));
    await fs.rm(sandbox, { recursive: true, force: true });
    if (previousEnv.password === undefined) delete process.env.RADIO_ADMIN_PASSWORD; else process.env.RADIO_ADMIN_PASSWORD = previousEnv.password;
    if (previousEnv.mode === undefined) delete process.env.NODE_ENV; else process.env.NODE_ENV = previousEnv.mode;
  }
});
