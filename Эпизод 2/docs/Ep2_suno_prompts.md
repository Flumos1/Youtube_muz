# Suno Prompts — Pink Floyd / The Wall (Ep2)

**Rule:** Always enable the Instrumental toggle in Suno. Never name real artists or bands.  
**Era:** Late 1970s British art rock / progressive rock / concept album sound.  
**Sonic DNA:** Sustain-heavy clean Stratocaster, Moog synth drones, Hammond organ swells,  
tight bass-and-drums with big room reverb, cinematic dynamic range, analog tape warmth.  
**Generate 2–3 variations per track, keep the best.**

---

## T1 — Tension / Alienation Motif (Hook, Beat 5 reprise, Outro)

Use at: 0:00–0:50 / 7:25–8:20 / 10:35–11:15  
Role: Recurring "brick by brick" motif — reuse the SAME clip each time so the ring closes.

```
late 1970s British art rock, cold and oppressive, single sustained Moog synthesizer drone, 
slow bass pulse, distant military snare march, empty stadium reverb, minor key, 
no lead melody — only pressure, tension and dread slowly building, cinematic darkness, 
sparse arrangement with long silences, analog tape warmth, 68 BPM, instrumental
```

Tempo: ~68 BPM. Sparse — bed under voiceover, never fills the space.

**T1-march variant** (for Beat 3 oppression, ~3:50–5:45):  
Same base, add: `relentless mechanical rhythm, stomping beat, walls closing in, no escape`

---

## T2 — Psychedelic Warmth (Beat 1 — Syd Barrett, the golden boy)

Use at: 0:50–2:25  
Role: The "before" — innocent beauty that carries seeds of its own destruction.

```
late 1960s British psychedelic pop, warm and dreamlike, swirling Farfisa organ, 
clean fingerpicked electric guitar arpeggios, gentle tambourine, whimsical and wide-eyed, 
kaleidoscopic color, major key with unexpected minor shadows, 
wistful nostalgia for a summer that ended badly, fragile and beautiful, 
analog warmth, bittersweet, 78 BPM, instrumental
```

Tempo: ~78 BPM. Let it breathe — warmth before the fall.

---

## T3 — Alienation / Isolation (Beats 2–3 — the spit, building the wall)

Use at: 2:25–5:45 (~3:20 total — generate 2 clips, crossfade at ~4:00)  
Role: The emotional core — cold glass between performer and world.

```
late 1970s British progressive rock, cold and emotionally numb, heavy reverb on electric guitar 
played in slow isolated chords, deep rumbling analog bass, minimal drums with stadium echo, 
sparse but oppressive, sense of glass wall between performer and audience, 
no warmth anywhere, relentless grey minor key, psychological claustrophobia, 
stadium-scale but achingly lonely, 63 BPM, instrumental
```

Tempo: ~63 BPM. The heaviest, most suffocating track. Long silences between chords.

---

## T4 — Collapse / Liberation (Climax + Berlin Coda)

Use at: 8:20–10:35 (swell peaks at ~9:25 — Berlin wall falls)  
Role: The release — grief and triumph simultaneously. Wall crashing down.

```
late 1970s British art rock climax, slow build from near-silence to full power, 
layered electric guitars rising through sustained notes, orchestral strings enter mid-build, 
thunderous drums crash in after long tension, bittersweet major key resolution, 
sense of liberation through destruction and collapse, emotional and monumental, 
tears and triumph together, full wall-of-sound production, cinematic, 
92 BPM after drums enter, instrumental
```

Tempo: starts slow/free, settles at ~92 BPM when the wall falls. Two peaks — one at 9:25 (Berlin), one smaller reprise at 10:00.

---

## T5 — Era Pastiche "This Is What It Sounded Like" (Beat 4 feature)

Use at: 5:45–7:25 (raise to foreground −7 dB at ~6:30 for 12–15s while VO pauses)  
Role: Most recognizable sonic snapshot of the era — NOT a cover, just the DNA.

```
late 1970s British concept album rock, clean Fender Stratocaster with long sustain and analog delay, 
expressive melodic guitar solo over full band arrangement, Hammond organ swells underneath, 
tight precise bass and drums in a large reverberant hall, cinematic and anthemic, 
dark verse resolving to soaring major key passage, arena-scale production with personal intimacy, 
layered guitars in thirds, slow vibrato on held notes, 1979 analog tape warmth, 
emotionally yearning, 82 BPM, instrumental
```

Tempo: ~82 BPM. This is the one track that comes forward — at ~6:30 let it breathe for 12–15s while VO is silent between sentences.

---

## Cue Sheet — 11:15 total runtime

| Timecode | Track | Volume | Action |
|----------|-------|--------|--------|
| 0:00 | T1 | −18 dB | Fade in 2s — cold drone opens (Hook) |
| 0:50 | T2 | −18 dB | Crossfade 3s — psychedelic warmth (Beat 1, Syd) |
| 2:25 | T3 | −18 dB | Crossfade 2.5s — glass wall descends (Beat 2) |
| ~4:00 | T3 clip 2 | −18 dB | Crossfade 2s — second T3 clip, same mood |
| 5:45 | T5 | −19 dB | Crossfade 2s — era pastiche bed (Beat 4) |
| ~6:30 | T5 | −7 dB | Feature lift 12–15s (VO silent between sentences) |
| ~6:45 | T5 | −19 dB | Fade back under VO |
| 7:25 | T1 | −17 dB | Crossfade 2s — tension reprise (Beat 5, loop closing) |
| 8:20 | T4 | −17→−10 dB | Collapse begins, slow build (Climax) |
| 9:25 | T4 | −10→−8 dB | Berlin peak — wall falls |
| 10:35 | T1 | −15 dB → fade | Final motif, fade to one note, then silence (Outro) |

**Music peaks above bed only twice:** T5 feature lift (~6:30) and T4 Berlin peak (~9:25). Everywhere else quiet bed.

---

## Track lengths to generate

| Track | Duration needed | Notes |
|-------|----------------|-------|
| T1 | ~60s (reused 3×) | Same clip each time — ring closes |
| T2 | ~95s | Beat 1 only |
| T3 | ~200s total | Generate 2 clips × 2 min each, crossfade |
| T5 | ~100s | Needs a singable/memorable guitar phrase for feature lift |
| T4 | ~135s | Long slow build — Suno 2-min clip works perfectly |

---

## Status
- [x] T1 generated → T1_v1.mp3 (2:15) · T1_v2.mp3 (2:44)
- [x] T2 generated → T2_v1.mp3 (1:28) · T2_v2.mp3 (1:51)
- [x] T3 generated → T3_v1.mp3 (4:16) · T3_v2.mp3 (4:49)
- [x] T4 generated → T4_v1.mp3 (4:25) · T4_v2.mp3 (3:10)
- [x] T5 generated → T5_v1.mp3 (4:24) · T5_v2.mp3 (3:53)
- [ ] All reviewed, best variations selected
- [ ] Rename winners to T1.mp3–T5.mp3
