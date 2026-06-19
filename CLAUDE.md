# Claude Code — Project Context

## Project
Faceless YouTube documentary channel. Pilot episode: Fleetwood Mac *Rumours* (1977).
Format: AI-generated images + recorded voiceover + licensed music, assembled in CapCut.

## File Conventions
- Scripts go in `scripts/`
- Voiceover scripts and timecode maps go in `docs/`
- Downloaded/generated images go in `images/`
- Image filenames use `MMSS.png` format matching CapCut timecodes

## Key Files
- `scripts/download_higgsfield_images.py` — downloads 46 images from Higgsfield CDN, saves as `images/higgsfield_images/MMSS.png`
- `docs/Pilot_Fleetwood_Mac_Rumours_EN.md` — English voiceover script (~9:40)
- `docs/Pilot_Fleetwood_Mac_Rumours.md` — Russian voiceover script
- `docs/capcut-naming-map.md` — maps filenames to CapCut timecodes

## Image Pipeline
1. Higgsfield generates images → stored on CDN at `d8j0ntlcm91z4.cloudfront.net`
2. Script downloads and renames to `MMSS.png`
3. Images imported into CapCut, placed at matching timecodes (5 sec each)

## CapCut Assembly Order
Images are 5-second slots. Filename = timecode in minutes+seconds (0000 = 0:00, 0005 = 0:05 ... 0345 = 3:45).
Total image coverage: 46 × 5s = 3:50. Remaining runtime filled with last image or B-roll.

## Next Episodes
Follow the same structure: `docs/Pilot_<Artist>_<Album>_EN.md` for each new episode.
