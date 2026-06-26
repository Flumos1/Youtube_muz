# Claude Code — Project Context

## Project
Faceless YouTube documentary channel about music history, artists, and cultural moments.  
**Pilot episode**: Fleetwood Mac *Rumours* (1977) — "They Recorded Their Divorce and the World Bought It 40 Million Times."

## Copyright Rule (Non-Negotiable)
- **Allowed**: Mention song/album titles, discuss facts and history, AI visuals of the era
- **Blocked**: Original recordings, real artist photos, song lyrics, AI voice clones of artists
- **Music**: Generate in Suno as *style of era* — never name a real artist in the prompt
- **Visuals**: AI-generated scenes of studios/crowds/instruments, NOT real archival footage

## Folder Structure (per-episode, organized 2026-06-23)
Each episode's assets live in its own top-level folder `Эпизод N/`:
- `Эпизод N/docs/` — scripts, prompts, maps, publish pack
- `Эпизод N/images/higgsfield_images/MMSS.png` — filename = timecode (gitignored)
- `Эпизод N/audio/` — Suno tracks · `Эпизод N/videos/` — Kling clips · `Эпизод N/out/` — finals + shorts · `Эпизод N/thumbnail/` · `Эпизод N/build/` (all gitignored)

**Channel-level (stays in ROOT, shared across all episodes):**
- `branding/` — channel avatar, banner, logo, watermark (gitignored)
- `scripts/` — assembly engine (assemble_*.ps1, generate_suno.ps1); paths reference Ep1 root layout — parametrize per episode when reusing
- `docs/project-strategy.md`, `docs/channel-branding.md` — channel-wide
- `CLAUDE.md`, `README.md`

**Episode 1** = Fleetwood Mac (`Эпизод 1/`) · **Episode 2** = Pink Floyd The Wall (`Эпизод 2/`)
- Image convention: MMSS.png = timecode; each image = 5s slot

## Channel Status (2026-06-24)
**Ep1 — Fleetwood Mac Rumours** (reupload 2026-06-24, `TCrq1Xa3_Pg`)
- Shorts: `DEMp1Rw5I5A` · `QBdQUtxlGI8` (~1.6K views best) · `FOq1P5qFWCY`
- All "Видео по теме" → `TCrq1Xa3_Pg` ✅

**Ep2 — Pink Floyd The Wall** (2026-06-24, `rmIUQdDgztY`, 11:58)
- Shorts: `vfZpweKMsAg` · `v8tkO607Cqs` · `P9OjAIyAxE8`
- All "Видео по теме" → `rmIUQdDgztY` ✅
- Phone verified ✅ · All channel features unlocked ✅

## ▶ NEXT SESSION — START HERE (updated 2026-06-26)
**Ep4 Napster — ALL ASSETS DONE. Next move: ASSEMBLE + PUBLISH.**
- ✅ Script `Эпизод 4/docs/Ep4_script_EN.md` (subscribe-ask at climax) · ✅ VO `audio/Ep4_VO_full.mp3` (10:45,
  Adam Deep English Story Voice) · ✅ 5 Suno tracks `audio/Ep4_T1..T5.mp3` · ✅ 71 images
  `images/higgsfield_images/MMSS.png` · ✅ 16 Kling clips `videos/MMSS.mp4` (1080p).
- ▶ RUN: `pwsh scripts/assemble_ep4.ps1` → `build/ep4_video.mp4` → audio mux → `out/ep4_final.mp4`
  (see `Эпизод 4/docs/Ep4_kling_animation_plan.md` for the assembly checklist + cue sheet).
- Then publish (workflow below) + `scripts/create_shorts.ps1 -Episode 4` (cuts already defined).
- Ep4 Higgsfield credits left ≈ 206 (starter). Title/tags candidates in the Ep4 research block below.

## ⚙ Self-Generation Pipeline (MCP) — proven on Ep4, USE THIS
I do the whole pipeline myself; don't hand steps back to the user unless genuinely unsure (then ask one
question first). Token economy matters — avoid redundant polls and huge tool dumps.
- **Music:** `scripts/generate_suno.ps1` (Suno/TTAPI, key in `.env`). Gen 2 variants, pick best, rename `EpN_T1..T5.mp3`.
- **Images:** Higgsfield MCP `f0718410…` → `generate_image` model **`soul_location`**, 16:9, count 4 (~0.12 cr/4).
  Prompt recipe: "Cinematic film still, [year]. [scene]. [lens/grade], 35mm grain, [mood]. No text, no logos, photorealistic."
- **Animation:** same MCP `generate_video` model **`kling3_0_turbo`**, 1080p, 5s; pass the image's **job_id** as
  `medias[].value role start_image` (~10 cr/clip). Decline preset "IN THE DARK" (`24bae836…`) via `declined_preset_id`
  for literal camera motion. **Kling adds native audio → mute clips in assembly.**
- **Limit:** 4 concurrent jobs (starter) for BOTH images & videos → fire one `count:4` wave, wait. ~40s/image-wave, ~2min/clip.
- **Download:** `show_generations` rawUrl; name by createdAt order or job_id → MMSS; big lists dump to file → parse with `ConvertFrom-Json`.
- **Density rule:** ~1 image / 8s (Ep1-3 = 68-93 imgs). First ~5 hook frames animated; animation must land in all 3 Shorts.
- **Assembly:** `scripts/assemble_epN.ps1` (Ken Burns zoompan + clip overlay → silent video) + audio mux (music bed per
  cue sheet, `sidechaincompress` duck under VO, `loudnorm I=-14`) → `out/`. ffmpeg = `node_modules/ffmpeg-static/ffmpeg.exe`.

## 🔄 Self-Improvement Loop (standing instruction)
After we change / redo / improve / optimize anything, record the lesson the SAME session so next time is
faster, cheaper, better: durable technical workflow → this CLAUDE.md; working-style → auto-memory. Treat my
own efficiency (fewer tokens, fewer round-trips) as an explicit goal the user asked for.

### Ep4 Napster — vidIQ research (2026-06-25), script + assets now DONE
- Keyword "napster": score 63 (High), volume 18 459, competition **37.7 (LOW)** ← good
- Trend ↓↓ Falling (historical topic) — offset with Metallica angle (evergreen conflict)
- Top competitor: "Napster vs. Metallica: The $20 BILLION War That Changed..." — The Big Flop
  (22K subs, 28K views, 7.2x outlier) — the only real documentary rival
- **Shorts gap: ZERO Shorts about Napster history** — first mover opportunity
- **Locked angle**: financial stakes + Metallica conflict = proven frame
- **Title candidates:**
  - "Metallica Sued Napster for $20 Billion — and Accidentally Killed the Music Industry"
  - "Two College Kids Built Napster in 60 Days — Then Metallica Destroyed Them"
- **Tags to include**: napster, napster metallica, music piracy history, file sharing revolution, lars ulrich napster, music industry history

### Growth subplan status (2026-06-25)
Already done: CTA overlay `create_shorts.ps1` ✅ · channel keywords 8→13 ✅ · Ep3 Shorts "Видео по теме" all set ✅
Still pending: Studio quick wins (watermark, subscribe link) — needs Chrome extension.

- 🔄 Synced to GitHub: **`https://github.com/Flumos1/Youtube_muz`** (origin/master). On another machine: `git clone` / `git pull`.

**Episode backlog (Ep4+)**: Ep4 = Napster (chosen). Then choose from Next Episode Ideas below.

## YouTube Studio Browser Automation (Chrome MCP)
- Allowed domain: `studio.youtube.com` ONLY — `www.youtube.com` is BLOCKED by extension
- **Always first call**: `tabs_context_mcp{createIfEmpty:true}` — tab IDs expire between sessions
- **After any click**: screenshot in a SEPARATE call (CDP timeout if batched with click)
- **Date picker**: defaults to TOMORROW — must explicitly click today's date
- **Shorts tab URL**: `/videos/short` (not `/shorts`)
- **Comments**: CANNOT post from Studio — clicking the field navigates to youtube.com → tab freezes. User must post manually on youtube.com
- **CORS**: fetch() from studio.youtube.com → youtube.com times out/blocked — don't attempt
- **Nexlev MCP**: requires paid plan — unusable on free tier
- **ToolSearch**: load multiple schemas in one call: `select:tool1,tool2,tool3`

### Proven JS snippets (Studio)
```js
// Scroll the Studio main panel (NOT window.scrollY — that doesn't work)
document.querySelector('main.style-scope').scrollTop += 600

// Select PUBLIC radio button
[...document.querySelectorAll('tp-yt-paper-radio-button')]
  .find(r => r.getAttribute('name') === 'PUBLIC').click()

// Fill contenteditable fields (title, description)
box.focus()
document.execCommand('selectAll', false, null)
document.execCommand('insertText', false, 'text here')

// Dismiss autocomplete dropdown (#Shorts suggestion, etc.)
document.dispatchEvent(new KeyboardEvent('keydown', {key:'Escape', bubbles:true}))

// Click Далее button
[...document.querySelectorAll('button')].find(b => b.innerText.trim() === 'Далее').click()
```

### Publication workflow (proven order, Ep1 & Ep2)
1. Upload file → fill title, description (with chapters), tags
2. Thumbnail → upload (user pastes path in native dialog via clipboard)
3. Playlist → add to existing or create
4. Audience → "Не для детей"
5. AI disclosure → Настройки → scroll to `main.scrollTop ≈ 1918` → "Использование ИИ" → Да
6. End screens → import from previous video (Подписка + Лучшее видео)
7. Subtitles → upload TXT "Без временных кодов" (YouTube auto-syncs timing)
8. Publish PUBLIC
9. **⚠️ Language check (MANDATORY)** → /translations tab → confirm "Английский (Соединённые Штаты) (язык видео)" appears. If Ukrainian shows as default language → RE-UPLOAD immediately (Ep1 lesson: UA metadata = 0 search views)
10. Shorts: ffmpeg crop → upload 3 one by one → set "Видео по теме" + description for each

### Language Metadata — Critical Rule
**Ep1 lesson:** YouTube RSS sync set defaultLanguage=uk → video invisible to English audience in search/suggested → 0 views on long video despite 3000+ Short views.
- After EVERY upload: go to `/translations` tab and verify the language shows **"Английский (Соединённые Штаты) (язык видео)"**
- If it shows Ukrainian as the video language → re-upload. There is no fix in Studio UI.
- Ep2 verified English ✅ · Ep1 re-uploaded to fix ✅

### Shorts — Required Description Template
Series-branded template (Ep4+). For Ep1/Ep2 the older minimal form is fine.
```
🎬 Music's Darkest Stories — Short #N
Full story → https://youtu.be/VIDEO_ID

🔔 Subscribe — a new music story every week.

#Tag1 #Tag2 #Tag3 #Tag4 #Shorts
```
And "Видео по теме" set to the corresponding long video immediately after upload.

**CTA overlay (auto):** `create_shorts.ps1` burns "SUBSCRIBE / for the full story" into the last
3s of every Short (ON by default; `-NoCTA` to skip). The #1 subscriber-conversion lever — see
`docs/growth-playbook.md`. Do NOT re-cut Ep3 Shorts (already uploaded with view momentum).

### "Видео по теме" in Shorts
- Phone verification required — **already done on this channel** ✅
- Set via Studio: video edit page → right panel → "Видео по теме" → Нет → pick video
- Can be set for all Shorts in one session without phone again
- **All Ep1 & Ep2 Shorts confirmed set ✅ (verified 2026-06-25)**

## Shorts Creation (ffmpeg — proven command)
```powershell
$ffmpeg = "C:\Temp\ffmpeg_dl\ffmpeg-8.1.1-essentials_build\bin\ffmpeg.exe"
$crop = "crop=ih*9/16:ih:(iw-ih*9/16)/2:0,scale=1080:1920"   # center-crop 16:9 → 9:16
# Example: cut 3:01–4:34 from final video
& $ffmpeg -y -ss 00:03:01 -to 00:04:34 -i "ep_final.mp4" `
  -vf $crop -c:v libx264 -preset fast -crf 18 -c:a aac -b:a 192k "short1.mp4"
```
- Use `scripts/create_shorts.ps1 -Episode 2` for automated 3-Short generation
- Shorts must be ≤60s for YouTube Shorts feed, up to 3 min for longer cuts
- Upload via Studio → "Выбрать файлы" → user pastes path from clipboard

## Production Workflow (VO-first — proven on Ep2)
1. **Script** → lock in `EpN/docs/EpN_script_EN.md`
2. **VO** → record with ElevenLabs → `EpN_VO_full.mp3`
3. **Timecodes** → `ffmpeg -af silencedetect` → `EpN_timecode_map.md`
4. **Images** → Higgsfield batches of 4, named `MMSS.png`
5. **Animation** → Kling for 6–9 key moments
6. **Music** → Suno 5 tracks (T1 tension / T2 warm / T3 melancholy / T4 bittersweet / T5 pastiche)
7. **Assembly** → `scripts/assemble_epN.ps1` (Ken Burns + clips) → ep_video.mp4
8. **CapCut** → VO + assembled video + music mix → export 1080p
9. **Publish** → see publication workflow above
10. **Shorts** → `scripts/create_shorts.ps1 -Episode N` → upload 3

## Real Audio Timing (VO = 5:21, Ep1 only)
Hook→Bit3: 0:00–3:10 · Bit4: 3:10–4:03 · Bit5: 4:03–4:26 · Climax: 4:26–4:58 · Outro: 4:58–5:21.
Ep2 VO = 11:56. Each episode's timecodes come from real audio silencedetect.

## Higgsfield Image Generation
- Model: Soul Location (cinematic scenes, environments)
- Format: 16:9, no text/logos in frame
- Batch size: max 4 simultaneous (starter plan limit)
- Naming: always MMSS.png matching CapCut timecode
- Prompt style: `cinematic, analog grain, moody, [era] aesthetic, no text, no logos, photorealistic, 16:9`
- Negative: `text, words, letters, logos, watermarks, modern technology`

## Suno Music (5 Tracks Per Episode)
See `docs/suno-prompts.md` for full prompts.
- T1: Tension (recurring motif, hook + outro)
- T2: Warm/Calm (success/Bit 1)
- T3: Melancholy (breakups/Bit 2)
- T4: Bittersweet (climax)
- T5: Era pastiche (feature moment — raised to foreground for 13s)

## CapCut Assembly Order
1. VO on Track 2 (reference volume)
2. 46 images on Track 1 at 5s each → covers 0:00–3:50
3. Music on Tracks 3–4 (interleaved for crossfades)
4. Base music volume: −16 to −18 dB
5. Two keyframe peaks: T5 at 7:00 (−5 dB) and T4 at 8:55 (−9 dB)
6. Hard cut at 0:33 (no crossfade — intentional)
7. Export: 1080p, Loudness Normalization ON

## Script Structure (Template)
- Hook (0–15s): Paradox/shocking fact, no intro
- Open Loop (15–35s): Promise of what's revealed at end
- Bits 1–3: ~60–90s each, micro-hook at end of each
- Emotional breath: slow shot + bird sounds mid-video (keeps 45+ audience)
- Climax: deliver the promised loop
- CTA: question about their experience ("What did you think of…?")

## Next Episode Ideas (Ep3+)
1. "Never Mind the Bollocks" — the UK ban and its backfire
2. Woodstock '99 — how one weekend ended the 90s music era
3. Phil Spector's "Wall of Sound" — genius and horror
4. Napster — the rise and fall that rewrote the music industry
5. Kurt Cobain / Nevermind — the accidental revolution
