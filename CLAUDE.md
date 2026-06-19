# Claude Code — Project Context

## Project
Faceless YouTube documentary channel about music history, artists, and cultural moments.  
**Pilot episode**: Fleetwood Mac *Rumours* (1977) — "They Recorded Their Divorce and the World Bought It 40 Million Times."

## Copyright Rule (Non-Negotiable)
- **Allowed**: Mention song/album titles, discuss facts and history, AI visuals of the era
- **Blocked**: Original recordings, real artist photos, song lyrics, AI voice clones of artists
- **Music**: Generate in Suno as *style of era* — never name a real artist in the prompt
- **Visuals**: AI-generated scenes of studios/crowds/instruments, NOT real archival footage

## File Conventions
- Images: `images/higgsfield_images/MMSS.png` — filename = CapCut start timecode
- Scripts / docs: `docs/`
- Python utilities: `scripts/`
- Each image = exactly 5 seconds on the CapCut timeline

## Current Asset Status (as of 2026-06-19)
- ✓ 46 Higgsfield images downloaded → `images/higgsfield_images/0000.png … 0345.png`
- ✓ CapCut naming map → `docs/capcut-naming-map.md`
- ✓ Suno prompts (5 tracks) → `docs/suno-prompts.md`
- ✓ CapCut assembly workflow → `docs/capcut-workflow.md`
- ✓ Channel strategy → `docs/project-strategy.md`
- ✗ EN voiceover script → `docs/Pilot_Fleetwood_Mac_Rumours_EN.md` — MISSING, needs restoration
- ✗ RU script → `docs/Pilot_Fleetwood_Mac_Rumours.md` — MISSING, needs restoration

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
