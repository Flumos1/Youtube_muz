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

## Pilot Status (PUBLISHED — 2026-06-23)
- ✓ Main video `L-6A7jFUegY` → Public. Channel: Flumos / 1 subscriber
- ✓ Short 1 `DEMp1Rw5I5A` "She said the song was about her dog" → Public (~4 views)
- ✓ Short 2 `QBdQUtxlGI8` "They made an album about love while..." → Public (~100 views — best performer)
- ✓ Short 3 `FOq1P5qFWCY` "They sold their own divorce 40 million times" → Scheduled 11:00 2026-06-23
- ✓ Engagement comment posted on main video
- ✓ Episode 2 chosen: **Pink Floyd The Wall**. Script LOCKED → `Эпизод 2/docs/Ep2_Pink_Floyd_The_Wall_EN.md` (~9–10 min)
- ☐ NEXT (Ep2): user records EN VO → extract real timecodes → Higgsfield shots → Kling → Suno → assemble. Workflow = VO-FIRST (see memory).

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

## Real Audio Timing (VO = 5:21)
Hook→Bit3: 0:00–3:10 · Bit4: 3:10–4:03 · Bit5: 4:03–4:26 · Climax: 4:26–4:58 · Outro: 4:58–5:21.
Video length follows the 5:21 voiceover (not the original ~9:40 estimate).

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

## Next Episode Ideas
1. "The Wall" — Pink Floyd, the breakdown behind the double album
2. "Never Mind the Bollocks" — the UK ban and its backfire
3. Woodstock '99 — how one weekend ended the 90s music era
4. Phil Spector's "Wall of Sound" — genius and horror
5. Napster — the rise and fall that rewrote the music industry
