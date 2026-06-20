# Final Assembly Sheet — Fleetwood Mac Pilot (CapCut, 5:21)

One-page build order for THIS episode. Timeline: **1080p · 30fps · 5:21**.

## Assets on hand
- **VO:** `G:\Ютуб 1.mp3` (5:21)
- **Stills:** `images/higgsfield_images/0000.png … 0535.png` (68)
- **Animated clips:** `videos/0000.mp4 …` (15 — replace matching stills)
- **Music:** `audio/T1.mp3, T1-build.mp3, T2.mp3, T3.mp3, T4.mp3, T5.mp3`

## Track layout
| Track | Content |
|-------|---------|
| V1 (top) | Visuals: stills + 15 clips |
| A1 | Voiceover (`Ютуб 1.mp3`) — reference, everything ducks to this |
| A2 / A3 | Music (two tracks, interleaved for crossfades) |
| A4 | SFX (optional): vinyl crackle, film-burn, swells |

---

## Step 1 — Voiceover
Drop `Ютуб 1.mp3` on A1 at 0:00. Set as reference volume (0 dB / ~−16 LUFS). Light Noise Reduction (don't overdo).

## Step 2 — Visuals
- **0:00–3:10** → the 46 originals (0000–0345), ~4s each.
- **3:10–5:21** → the 22 tail frames (0350–0535), ~6s each.
- Place each frame at the line it illustrates (see `docs/capcut-naming-map.md`); don't force rigid 5s.
- **Replace these 15 stills with their `.mp4`:** 0000, 0005, 0010, 0015, 0020, 0025, 0030, 0035, 0040, 0120, 0435, 0455, 0505, 0515, 0535.
- Apply slow **Ken Burns** (pan/zoom) to every remaining still.

## Step 3 — Music (cue sheet, real 5:21)
Lay on A2/A3, base volume **−16 to −18 dB**. Crossfade = overlap clips ~2s, fade-out on outgoing + fade-in on incoming.

| Time | Track | Action |
|------|-------|--------|
| 0:00 | T1 | fade in 1.5s, bed |
| ~0:33 | — | **HARD CUT + 0.5s silence** (no crossfade — intentional) |
| 0:35 | T2 | fade in 2s |
| ~1:45 | T3 | crossfade 2.5s |
| ~2:50 | T1-build | crossfade 2s, creep −18 → −14 |
| 3:10 | T5 | crossfade 2s |
| ~3:30 | T5 | OPTIONAL lift to −7 for 6–8s between sentences, then back |
| 4:03 | T1 | crossfade 2s — **use the SAME T1 clip as 0:00** (closes the ring) |
| 4:26 | T4 | swell −15 → −9, peak ~4:50 ("40 million") |
| 4:58 | T1 | final motif, **fade out 4s** to silence |

## Step 4 — Volume / ducking
- VO is king. Music bed sits 12–15 dB under speech.
- **Only two peaks above bed:** optional T5 lift (~3:30) and T4 swell (~4:50). Use volume keyframes (◆).
- If VO ever gets buried → Auto Ducking on that music clip, then fine-tune with keyframes.

## Step 5 — Export
- 1080p · 30fps
- **Loudness Normalization ON** (~−14 LUFS for YouTube)
- High-Quality Preview on while editing.

## After export
Cut 2–3 Shorts: "velvet bag under the desk", "the song about the dog", "40 million from heartbreak".
