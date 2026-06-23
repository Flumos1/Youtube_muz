# CapCut Assembly Workflow — Faceless Music History Channel

## Track Layout (5 tracks)

| Track | Content |
|-------|---------|
| Track 1 | Video / visuals (images + B-roll) |
| Track 2 | Voiceover (English narration) — THE KING, everything bows to this |
| Track 3 | Music A (odd cue regions) |
| Track 4 | Music B (even cue regions, for crossfades) |
| Track 5 | SFX: vinyl crackle, film grain sound, swells (optional) |

Interleave music between Track 3 and 4 with 2-second overlaps for seamless crossfades.

---

## Step-by-Step

### 1. Lock Voiceover First
- Import VO to Track 2
- Set volume as reference (0 dB, or boost if TTS is quiet)
- All music volumes are set relative to this

### 2. Set Music Base Volume — Stay Quiet
- All music clips default to −16 to −18 dB (well under voiceover)
- Music is a bed, not a feature, except at two peak moments
- Speech nearly continuous → no need to duck under every sentence; just keep it quiet

### 3. Keyframes — Only Two Volume Peaks
CapCut keyframe method: position playhead → click diamond (◆) next to Volume → move playhead → change volume (second keyframe auto-creates).

**Peak 1 — T5 Feature (7:00–7:13)**
- Keyframe up to −5 dB at 7:00 (over 1 second)
- Hold
- Keyframe back down to −19 dB at 7:13 (over 1.5 seconds)
- Voiceover pauses here — music fills the silence

**Peak 2 — T4 Climax (8:15–8:55)**
- Gradual keyframe swell from −15 dB at 8:15 to −9 dB at 8:55
- Then fade back down as narrator wraps

### 4. Fades and Crossfades
- Every music clip: 1.5–2s Fade In at start, 2s Fade Out at end
- Crossfade between cue regions: overlap clips on Track 3 / Track 4 by ~2 seconds
- **Exception at 0:33**: HARD CUT, no crossfade. 0.5s silence. Intentional micro-hook.

### 5. Hard Cut at 0:33
- Cut T1 with scissors at 0:33
- Leave 0.5 second of silence
- T2 starts at 0:35 with 2s fade in
- This sharp break is the strongest moment in the hook — don't soften it

### 6. Auto Ducking (insurance)
- If voiceover still gets buried anywhere → select that music clip → Audio → Auto Ducking (on)
- Fine-tune with manual keyframes after
- Run Noise Reduction on VO first, then Auto Duck (order matters)

### 7. Voiceover Cleanup
- Select VO clip → Audio → Noise Reduction
- Light hand: remove hiss/hum, not character
- Aggressive NR makes voice thin and robotic

### 8. Export Settings
- Resolution: 1080p minimum (1440p or 4K preferred)
- Frame rate: 30fps
- Enable **Loudness Normalization** at export (targets ~−14 LUFS for YouTube)
- Enable High Quality Preview during editing to avoid export surprises

---

## Image Assembly Checklist

1. Sort 46 images by filename (alphabetical = chronological)
2. Drag all to Track 1 timeline
3. Set each to **exactly 5.0 seconds**
4. Images cover 0:00 → 3:50
5. After 3:50: loop last frame, use B-roll, or fade to black
6. Apply slow Ken Burns (pan/zoom) to each still: keeps the documentary feel alive

---

## Volume Reference Summary

| Element | Target Level |
|---------|-------------|
| Voiceover | 0 dB (reference) / ~−16 LUFS integrated |
| Music bed (most of video) | −16 to −18 dB below VO |
| T5 feature peak (7:00) | −5 dB (rises above VO, VO silent) |
| T4 climax peak (8:55) | −9 dB (near VO level, VO continues over it) |
| SFX accent hits | −12 to −15 dB, brief |

---

## Order of Operations (Don't skip steps)

1. Import VO → set reference volume
2. Import all 46 images → set 5s each
3. Apply Ken Burns effect to images
4. Import music tracks → lay down by cue sheet timecodes
5. Set all music to base quiet volume
6. Set Fade In/Out on every music clip
7. Create crossfades (Track 3 ↔ Track 4 overlaps)
8. Hard cut at 0:33
9. Keyframe Peak 1 (7:00) and Peak 2 (8:55)
10. Noise Reduction on VO (light)
11. Test playback on headphones — check for VO burial
12. Auto Duck any problem spots
13. Export with Loudness Normalization
