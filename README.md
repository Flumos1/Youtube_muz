# Fleetwood Mac / Rumours — Faceless YouTube Channel

Faceless YouTube video project: documentary-style narration over AI-generated images.

## Project Structure

```
├── scripts/
│   └── download_higgsfield_images.py   # Download all 46 Higgsfield images
├── docs/
│   ├── Pilot_Fleetwood_Mac_Rumours_EN.md   # Voiceover script (EN, ~9:40)
│   ├── Pilot_Fleetwood_Mac_Rumours.md      # Voiceover script (RU)
│   └── capcut-naming-map.md                # Timecode → filename reference
├── images/
│   └── higgsfield_images/              # Downloaded images (created by script)
└── README.md
```

## Quick Start

### 1. Download images
```bash
cd scripts
python download_higgsfield_images.py
```
Images save to `images/higgsfield_images/` as `MMSS.png` (e.g. `0000.png`, `0005.png`).

### 2. Record voiceover
Open `docs/Pilot_Fleetwood_Mac_Rumours_EN.md` and record narration. Target: ~9:40.

### 3. Assemble in CapCut
- Import voiceover track
- Add music (Suno / licensed instrumental)
- Drag images in timecode order — each image lasts 5 seconds
- Use `docs/capcut-naming-map.md` as the reference map

### 4. Export & Upload
- Export 1080p / 30fps
- Upload to YouTube with SEO-optimized title/description

## Production Checklist

- [ ] Download all 46 images (`python scripts/download_higgsfield_images.py`)
- [ ] Record English voiceover
- [ ] Generate background music (Suno)
- [ ] Assemble video in CapCut
- [ ] Export 1080p
- [ ] Upload to YouTube

## Image Map (46 frames, 5 sec each)

| File | Timecode | Scene |
|------|----------|-------|
| 0000.png | 0:00 | Dark studio, mixing board |
| 0005.png | 0:05 | Two couples with backs turned |
| 0010.png | 0:10 | Solitary figure at the board |
| 0015.png | 0:15 | Live room |
| 0020.png | 0:20 | Microphone |
| 0025.png | 0:25 | Hand writing |
| 0030.png | 0:30 | VU meter |
| 0035.png | 0:35 | Concert |
| 0040.png | 0:40 | Tour bus |
| 0045.png | 0:45 | Gold records |
| 0050.png | 0:50 | 5 silhouettes gathering |
| 0055.png | 0:55 | Drummer |
| 0100.png | 1:00 | Guitarist and singer |
| 0105.png | 1:05 | Piano + bassist |
| 0110.png | 1:10 | Two rings |
| 0115.png | 1:15 | Vinyl factory |
| 0120.png | 1:20 | Spinning record |
| 0125.png | 1:25 | Crowd outside venue |
| 0130.png | 1:30 | Money / champagne |
| 0135.png | 1:35 | Golden portrait |
| 0140.png | 1:40 | Stage crack |
| 0145.png | 1:45 | Two couples with rift |
| 0150.png | 1:50 | Dawn on the highway |
| 0155.png | 1:55 | Backstage silhouette |
| 0200.png | 2:00 | Couple drifting apart |
| 0205.png | 2:05 | Guitar / departure |
| 0210.png | 2:10 | Torn photo |
| 0215.png | 2:15 | Divorce papers |
| 0220.png | 2:20 | Two silhouettes back to back |
| 0225.png | 2:25 | Woman at the piano |
| 0230.png | 2:30 | Phone off hook |
| 0235.png | 2:35 | Head in hands |
| 0240.png | 2:40 | Door and two shadows |
| 0245.png | 2:45 | Wilting roses |
| 0250.png | 2:50 | Three couples dissolving |
| 0255.png | 2:55 | Split silhouette |
| 0300.png | 3:00 | Clasped hands |
| 0305.png | 3:05 | Clock / time |
| 0310.png | 3:10 | Silhouette at microphone |
| 0315.png | 3:15 | Empty control room |
| 0320.png | 3:20 | Rain and two cups |
| 0325.png | 3:25 | Single lamp in darkness |
| 0330.png | 3:30 | Studio by the bay |
| 0335.png | 3:35 | Bridge in the fog |
| 0340.png | 3:40 | Clock at 4am |
| 0345.png | 3:45 | Exhausted figure at the board |
