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

## Channel Status (2026-06-26)
**Ep1 — Fleetwood Mac Rumours** (reupload 2026-06-24, `TCrq1Xa3_Pg`)
- Shorts: `DEMp1Rw5I5A` · `QBdQUtxlGI8` (~1.6K views best) · `FOq1P5qFWCY`
- All "Видео по теме" → `TCrq1Xa3_Pg` ✅

**Ep2 — Pink Floyd The Wall** (2026-06-24, `rmIUQdDgztY`, 11:58)
- Shorts: `vfZpweKMsAg` · `v8tkO607Cqs` · `P9OjAIyAxE8`
- All "Видео по теме" → `rmIUQdDgztY` ✅
- Phone verified ✅ · All channel features unlocked ✅

**Ep4 — Napster** (2026-06-26, `sUzpQCJhziQ`, 10:47)
- Short #1 `OUnxWwYZoZw` "The Day Music Industry Nearly Died" ✅ — "Видео по теме" → `sUzpQCJhziQ` ✅
- Short #2 `IoLDVLCT_TA` "Metallica Showed Up With 317,000 Names" ✅ — "Видео по теме" → `sUzpQCJhziQ` ✅
- Short #3 `5ibSBt5u5ak` "Who Really Won the $40 Billion War?" ✅ — "Видео по теме" → `sUzpQCJhziQ` ✅
- All Shorts "Видео по теме" → `sUzpQCJhziQ` ✅
- ⚠️ AI disclosure — set after video finishes processing (not visible during SD processing)
- ⚠️ Thumbnail — upload via Значок → Загрузить файл after processing completes

## ✅ Subtitles + End Screens pass (2026-07-01)
**Subtitles:** all 23 channel videos now have manually-uploaded English subtitles (uploaded via "Без
временных кодов" → YouTube auto-syncs to audio) — 5 long videos + 18 Shorts (12 original + 6 round-2).
Text for videos with no local script file (Phil Spector) was reconstructed from YouTube's own
auto-captions via `get_video_transcript`/`get_bulk_video_transcripts` (Nexlev MCP) — fast and accurate,
reuse this approach for any future episode missing a local script.
**End screens:** all 5 long videos now chain to each other (not "Самое подходящее" auto-pick) in a closed
loop matching publish order: Fleetwood Mac → Pink Floyd → Sex Pistols → Napster → Phil Spector → back to
Fleetwood Mac. Set via Редактор → Конечные заставки → Изменить → click the video element → "Выбранное
видео" → search by title. Subscribe element left as-is.
**Still pending (user must do — Studio can't post Shorts comments):** pinned comment with the long-video
link on each Short, pack ready in `docs/shorts_pinned_comments.md`. Start with the highest-view Shorts
(Fleetwood Mac 1.7–1.8K).

## 📉 Channel Diagnosis — why long videos have ~0 views (2026-06-27)
Channel `@flumos` `UCY703fBZ7zpLokv1oPea_gA` = **4 subs**, all 4 long videos published 24–26 Jun (1–3 days old).
Pulled Studio **Охват/Reach** (С момента публикации):
- Napster `sUzpQCJhziQ` (1 day): **4 impressions**, CTR 25%, 2 views; traffic = Channel pages 50%.
- Pink Floyd `rmIUQdDgztY` (3 days): **19 impressions**, 6 views, 2 unique; traffic = **Shorts по ссылке 100%**.
**Root cause: NOT a bug.** Videos are Public, crawlable, English, Music category, worldwide (checked
youtube_video_details). Ep1 Ukrainian-language bug is GONE. CTR where measurable is healthy (25% ≫ 4–6% norm)
→ thumbnails/titles fine. Problem = **impression starvation**: a 4-sub, days-old channel gets almost no
algorithmic distribution on long-form. Search/Suggested/Browse ≈ 0.
**What IS working: the Shorts→long funnel** — 100% of Pink Floyd traffic came via the Short's "Видео по теме"
link. Mechanism fine; just not enough Shorts volume.
**Fix (priority): (1) Shorts volume — DAILY (upgraded 2026-07-01 from 3-5/week; only fast source of
subs + long-form traffic at this size). (2) 1 long/week, not in bursts. (3) patience. (4) hygiene —
mostly already OK (see below). Full breakdown: see [[project_growth_breakthrough_strategy]] in memory.**
**Hygiene done 2026-06-27:** Tags — Ep2 Pink Floyd & Ep4 Napster had EMPTY tag fields → filled (~12 each);
Ep1 Fleetwood Mac & Ep3 Sex Pistols already had full tag sets. All 4 confirmed video-language = English.
Subtitles — DON'T bother uploading manual TXT: every long video already has **published English AUTO-captions**
(checked Napster /translations). `youtube_video_details.hasCaption:false` only means "no manual track"; auto-captions
are live and cover accessibility/indexing. API `keywords:[]` is also unreliable — verify tags in Studio, not via API.
**6 FRESH Shorts (round 2) CUT & READY 2026-06-27** (1080x1920, 54s, SUBSCRIBE CTA) — pending upload, in each `out/`:
`ep2_v2_father` `ep2_v2_berlin` → set Видео по теме `rmIUQdDgztY` · `ep3_v2_mclaren` `ep3_v2_amrecords` → `6Q0QNLyHBvM`
· `ep4_v2_explosion` `ep4_v2_death` → `sUzpQCJhziQ`. Cut script: scratchpad `cut_fresh_shorts.ps1` (avoids short1/2/3 ranges).
**Reusable diagnostic:** Studio → video → Analytics → Охват → check Показы(impressions) + источник трафика.
Single/double-digit impressions = cold-channel starvation, not a metadata fault. Don't blame thumbnail if CTR is OK.

## ▶ NEXT SESSION — START HERE (updated 2026-07-01)
**Ep4 PUBLISHED & COMPLETE (long + 3 Shorts + thumbnail).** All done, AI disclosure set.

**Ep5 = PHIL SPECTOR — PUBLISHED** (`n6unybgd5E4`, 15:45, "He Invented the Sound of the 60s — Then Shot
a Woman Dead"), playlist "Music's Darkest Stories", language English ✅, AI disclosure = Да ✅, not-for-kids ✅,
copyright clean ✅. 5 Shorts published: `oPpupkvFyh4` `dxhTLuf9vgE` `7pk51gqK-vE` `_a7mJy0mqxY` `ZXpqnMZINcA`,
all "Видео по теме" → `n6unybgd5E4` ✅. **Discovered 2026-07-01**: this episode was produced/published in a
session not reflected in CLAUDE.md at the time — no script files exist locally for it (text was
reconstructed from YouTube auto-captions via `get_video_transcript` when backfilling subtitles 2026-07-01).
Top-performing Shorts on the channel currently (190/92/76 views in 48h).

**Эпизод 5/ folder on disk ≠ Phil Spector** — it contains a fully-scripted, VO-recorded **Whitney Houston**
project (`Эпизод 5/docs/Ep5_VO_clean_EN.txt`, full audio in `Эпизод 5/audio/`) that was never assembled or
published. Treat Whitney Houston as the **next episode to assemble** (visuals/animation/assembly steps still
needed) — don't re-script it, the VO-first script + audio are done. Title (working): "Whitney Houston: The
Voice That Drowned Twice." Hook: "She had the greatest voice on the planet. She drowned in a hotel bathtub
at 48. Three years later her only daughter died the exact same way." Copyright: titles/facts/AI era visuals
OK; NO real recordings, real photos, lyrics, or AI voice clone. Treatment: addiction + a child's death —
documentary/respectful tone.

**⚠️ Superseding growth data found on origin/master (2026-06-28 session, different machine) — see
`docs/growth-playbook.md`.** Real Studio pull: 96.2% of traffic is the Shorts feed, subscriber
conversion 0.045%, top content = 11-20s micro-Shorts (72% of all views), long videos got 2-7 views in
28 days despite full production pipelines. Proposed pivot: **kill 11-20s micro-Shorts, go 30-50s with
hook→tension→cliffhanger + a SPOKEN subscribe-ask** (not just the text overlay), Shorts daily/every-other-day,
pause or cheapen long-form until there's an audience. This refines (not replaces) [[project_growth_breakthrough_strategy]]
in memory — reconcile the two before the next production session.

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
  cue sheet, `sidechaincompress` duck under VO, `loudnorm I=-14`) → `out/`.
- **🎵 MUSIC MUST COVER THE WHOLE VIDEO (rule — user flagged 2026-06-30):** music bed has to play
  end-to-end with NO gaps and NOT cut off before the video ends. Two failure modes that bit us:
  (1) cue-sheet scheduling leaves silent gaps between cues; (2) final `[vo][music]amix=...:duration=first`
  ties total length to the VO, so any tail where video > VO has no audio. **Fix/standard:** build ONE
  continuous bed from **ALL Suno generations** (both variants of every prompt — there are ~9–10 mp3s/ep,
  not just 5), `concat`+`aloop` it to ≥ video length, duck under VO across the entire timeline, and end on
  **video duration (`-t <videoSec>` / `duration=longest`)**, never on the VO. Reusable: `scripts/mix_music_bed.ps1`.
- **Tooling (installed 2026-06-30):** full **ffmpeg + ffprobe 8.1.2** at `C:\Temp\ffmpeg_dl\ffmpeg-*essentials_build\bin`
  (added to USER PATH — new shells/apps get it; a *freshly spawned* shell in the SAME session may still need the
  full path until the harness restarts). `ffmpeg-static` (node_modules) has NO ffprobe — use the C:\Temp build for
  probing. Python 3.14 + `py` launcher present. Resolve ffmpeg via glob `C:\Temp\ffmpeg_dl\ffmpeg-*\bin\ffmpeg.exe`
  (version folder changes), then node_modules, then PATH — don't hardcode a version.

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
- **File upload**: CANNOT be done by me. YouTube's `input[type=file]` is in shadow DOM (no a11y ref → `file_upload` MCP can't target it), and `file_upload` also caps at 10 MB + shared files only. The native OS picker is outside the page. → I open Создать→Добавить видео and fill ALL metadata/schedule/Видео по теме; the USER does only the file-select step (proven 2026-06-30). Confirmed today's date via Studio = correct system clock.
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

**CTA overlay (auto, UPDATED 2026-06-30):** `create_shorts.ps1` now burns TWO stacked buttons into the
last 5s of every Short — blue **WATCH FULL VIDEO** ("tap the link bottom-left") over red **SUBSCRIBE**
("a new music story every week"). ON by default; `-NoCTA` to skip, `-CTASecs N` to change duration.
Buttons are English (audience is English) and are visual cues only — the sole clickable Short→long link
is the "Видео по теме" chip, so ALWAYS set it in Studio after upload. The #1 Short→long+subscriber lever.
Do NOT re-cut already-uploaded Shorts that have view momentum (re-upload = lost views/comments).

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
6b. **Music length check** → total Suno music must be ≥ video length; if not, generate MORE tracks (all variants).
7. **Assembly** → `scripts/assemble_epN.ps1` (Ken Burns + clips) → ep_video.mp4
8. **Audio mix** → `scripts/mix_music_bed.ps1 -Episode N` — continuous bed from ALL Suno tracks, full length, ducked.
8b. **🚦 QC GATE (MANDATORY before publish)** → `scripts/check_audio_coverage.ps1 -Episode N`. Must print
   **PASS**. FAIL = silent/music-less tail or audio dies early (the Ep5 Phil Spector bug) → re-mix, do NOT upload.
9. **Publish** → see publication workflow above
10. **Shorts** → `scripts/create_shorts.ps1 -Episode N` → upload 3 (two-button CTA auto)

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

## Next Episode Ideas (Ep7+)
**Done:** Ep3 = Sex Pistols · Ep4 = Napster · Ep5 = Phil Spector (PUBLISHED, see NEXT SESSION).
**Next to assemble:** Whitney Houston (script + VO already done, sitting in `Эпизод 5/` folder — see
NEXT SESSION note on the folder-numbering mismatch). Assign it a real episode number once assembled.
**Audience strategy (from 2026-06-26 research):** current audience is mostly men ~27-35. Pivoting to
pull WOMEN 27-35+ via famous-female-singer dark stories. Researched shortlist with real YT demand data:
1. Whitney Houston — next up (best demand×gap; script+VO ready, see NEXT SESSION)
2. Amy Winehouse — highest vidIQ score (71.5) but saturated; strong future candidate
3. Selena — 17M on top doc, true-crime hook, trending again (Yolanda parole/Netflix 2025); saturated
4. Tina Turner — abuse→escape→Queen of Rock empowerment arc; strong female resonance
5. Karen Carpenter — anorexia story, uniquely female-coded (875K/389K/339K demand)
**Older male-leaning backlog:** Woodstock '99 · Kurt Cobain/Nevermind
