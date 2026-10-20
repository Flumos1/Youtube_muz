const $ = selector => document.querySelector(selector);
const api = async (url, options = {}) => {
  const response = await fetch(url, options);
  let data;
  try { data = await response.json(); } catch { data = { error: 'Сервер не ответил' }; }
  if (!response.ok) throw new Error(data.error || 'Ошибка запроса');
  return data;
};
const jsonPost = (url, body) => api(url, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) });

function showDashboard(on) { $('#dashboard').classList.toggle('admin-hidden', !on); $('#login-panel').classList.toggle('admin-hidden', on); if (on) refreshAll(); }
function setMessage(selector, message) { $(selector).textContent = message; }
async function upload(file, kind) { return api(`/api/admin/upload?kind=${kind}`, { method: 'POST', headers: { 'Content-Type': file.type || 'application/octet-stream' }, body: file }); }
function durationOf(file) {
  return new Promise(resolve => {
    const url = URL.createObjectURL(file);
    const element = document.createElement('audio'); element.preload = 'metadata'; element.src = url;
    const finish = value => { URL.revokeObjectURL(url); resolve(Number.isFinite(value) ? value : null); };
    element.onloadedmetadata = () => finish(element.duration);
    element.onerror = () => finish(null);
  });
}

async function refreshTracks() {
  const { tracks } = await api('/api/catalog');
  const list = $('#track-list'); list.replaceChildren();
  if (!tracks.length) { const p = document.createElement('p'); p.textContent = 'Каталог пока пуст. Добавьте первую композицию.'; list.append(p); return; }
  for (const track of tracks) {
    const row = document.createElement('div'); row.className = 'admin-list-item';
    const info = document.createElement('div');
    const title = document.createElement('strong'); title.textContent = track.title;
    const detail = document.createElement('span'); detail.textContent = ` · ${track.artist} · ${track.channel}`;
    info.append(title, detail);
    const remove = document.createElement('button'); remove.type = 'button'; remove.textContent = 'Убрать';
    remove.addEventListener('click', async () => {
      if (!confirm(`Убрать «${track.title}» из каталога?`)) return;
      try { await api(`/api/admin/tracks/${track.id}`, { method: 'DELETE' }); await refreshTracks(); }
      catch (error) { alert(error.message); }
    });
    row.append(info, remove); list.append(row);
  }
}

async function refreshLive() {
  const live = await api('/api/status');
  $('#live-form').elements.title.value = live.title || 'Прямой эфир';
  $('#live-form').elements.streamUrl.value = live.streamUrl || '';
  setMessage('#live-message-admin', live.on ? '● Сейчас в эфире' : 'Сейчас эфир выключен');
}

async function refreshMetrics() {
  const data = await api('/api/admin/metrics');
  $('#metrics-summary').textContent = `За 7 дней: ${data.listeners7d} слушателей · возвращались: ${data.returningListeners} · прослушано: ${data.listeningHours} ч`;
}

async function refreshChat() {
  const { messages } = await api('/api/admin/chat');
  const list = $('#admin-chat'); list.replaceChildren();
  if (!messages.length) { const p = document.createElement('p'); p.textContent = 'Сообщений пока нет.'; list.append(p); return; }
  for (const message of messages) {
    const row = document.createElement('div'); row.className = 'admin-list-item';
    const info = document.createElement('div');
    const nick = document.createElement('strong'); nick.textContent = `${message.nickname}: `;
    const text = document.createTextNode(message.message);
    info.append(nick, text);
    const actions = document.createElement('div'); actions.className = 'admin-row';
    for (const [label, target] of [['Удалить', `/api/admin/chat/${message.id}`], ['Блокировать', '/api/admin/chat/block']]) {
      const button = document.createElement('button'); button.type = 'button'; button.textContent = label;
      button.addEventListener('click', async () => {
        try { await api(target, label === 'Удалить' ? { method: 'DELETE' } : { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ id: message.id }) }); await refreshChat(); }
        catch (error) { alert(error.message); }
      });
      actions.append(button);
    }
    row.append(info, actions); list.append(row);
  }
}

async function refreshAll() { try { await Promise.all([refreshTracks(), refreshLive(), refreshChat(), refreshMetrics()]); } catch (error) { setMessage('#track-message', error.message); } }
$('#login-form').addEventListener('submit', async event => {
  event.preventDefault();
  try { await jsonPost('/api/admin/login', { password: $('#password').value }); $('#password').value = ''; showDashboard(true); }
  catch (error) { setMessage('#login-message', error.message); }
});
$('#track-form').addEventListener('submit', async event => {
  event.preventDefault();
  const form = event.currentTarget; const submit = form.querySelector('button[type=submit]');
  submit.disabled = true; setMessage('#track-message', 'Загружаю композицию…');
  try {
    const audio = form.elements.audio.files[0];
    const cover = form.elements.cover.files[0];
    const duration = await durationOf(audio);
    const audioFile = await upload(audio, 'audio');
    const coverFile = cover ? await upload(cover, 'cover') : null;
    await jsonPost('/api/admin/tracks', { title: form.elements.title.value, artist: form.elements.artist.value, channel: form.elements.channel.value, audioId: audioFile.id, coverId: coverFile?.id, coverExt: coverFile?.ext, duration });
    form.reset(); form.elements.artist.value = 'Flumos'; setMessage('#track-message', 'Композиция добавлена.'); await refreshTracks();
  } catch (error) { setMessage('#track-message', error.message); }
  finally { submit.disabled = false; }
});

for (const [button, on] of [['#live-on', true], ['#live-off', false]]) {
  $(button).addEventListener('click', async () => {
    const form = $('#live-form');
    try { await jsonPost('/api/admin/live', { on, title: form.elements.title.value, streamUrl: form.elements.streamUrl.value }); await refreshLive(); }
    catch (error) { setMessage('#live-message-admin', error.message); }
  });
}
$('#recording-form').elements.date.value = new Date().toISOString().slice(0, 10);
$('#recording-form').addEventListener('submit', async event => {
  event.preventDefault(); const form = event.currentTarget; const button = form.querySelector('button[type=submit]');
  button.disabled = true; setMessage('#recording-message', 'Загружаю запись…');
  try {
    const file = form.elements.audio.files[0]; const duration = await durationOf(file);
    const uploaded = await upload(file, 'recording');
    await jsonPost('/api/admin/recordings', { title: form.elements.title.value, date: form.elements.date.value, audioId: uploaded.id, duration });
    form.reset(); form.elements.date.value = new Date().toISOString().slice(0, 10);
    setMessage('#recording-message', 'Запись опубликована.');
  } catch (error) { setMessage('#recording-message', error.message); }
  finally { button.disabled = false; }
});
$('#logout').addEventListener('click', async () => { await api('/api/admin/logout', { method: 'POST' }); showDashboard(false); });
api('/api/admin/session').then(data => showDashboard(data.authenticated)).catch(() => showDashboard(false));
setInterval(() => { if (!$('#dashboard').classList.contains('admin-hidden')) refreshChat().catch(() => {}); }, 5000);
