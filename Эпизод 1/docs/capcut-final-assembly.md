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

## Ken Burns map (53 stills)

Rule: **IN** = slow push 100→110% · **OUT** = pull 110→100% · **PAN** = ~108% scale + horizontal slide. Keep it slow and subtle. The 15 `.mp4` clips already move — leave them alone.

| File | Move | | File | Move |
|------|------|---|------|------|
| 0000 | clip | | 0240 | IN |
| 0005 | clip | | 0245 | IN |
| 0010 | clip | | 0250 | OUT |
| 0015 | clip | | 0255 | IN |
| 0020 | clip | | 0300 | IN |
| 0025 | clip | | 0305 | IN |
| 0030 | clip | | 0310 | IN |
| 0035 | clip | | 0315 | OUT |
| 0040 | clip | | 0320 | IN |
| 0045 | OUT | | 0325 | IN |
| 0050 | IN | | 0330 | OUT |
| 0055 | IN | | 0335 | PAN L→R |
| 0100 | IN | | 0340 | IN |
| 0105 | PAN R→L | | 0345 | IN |
| 0110 | IN | | 0350 | IN |
| 0115 | OUT | | 0355 | IN |
| 0120 | clip | | 0400 | IN |
| 0125 | OUT | | 0405 | OUT |
| 0130 | IN | | 0410 | PAN R→L |
| 0135 | IN | | 0415 | IN |
| 0140 | IN | | 0420 | IN |
| 0145 | OUT | | 0425 | IN |
| 0150 | PAN L→R | | 0430 | IN |
| 0155 | IN | | 0435 | clip |
| 0200 | OUT | | 0440 | IN |
| 0205 | PAN R→L | | 0445 | OUT |
| 0210 | IN | | 0450 | IN |
| 0215 | IN | | 0455 | clip |
| 0220 | OUT | | 0500 | OUT |
| 0225 | IN | | 0505 | clip |
| 0230 | IN | | 0510 | IN |
| 0235 | IN | | 0515 | clip |
| | | | 0520 | PAN L→R |
| | | | 0525 | IN |
| | | | 0530 | OUT |
| | | | 0535 | clip |

Quick read: pushes (IN) dominate the intimate/tense beats; pulls (OUT) land on scale and loss (gold records 0045, crowd 0125, the rift 0145, dissolving couples 0250, empty room 0315, city 0500, final dawn 0530); pans carry movement (highway 0150, leaving 0205, bridge 0335, the wall scan 0520).

## After export
Cut 2–3 Shorts: "velvet bag under the desk", "the song about the dog", "40 million from heartbreak".
