# Suno Prompts — Fleetwood Mac / Rumours Pilot

**Rule:** Always enable the Instrumental toggle in Suno. Never name real artists.  
**Commercial use:** Requires paid Suno plan for commercial rights.  
Generate 2–3 variations per track, keep the best, build a reusable library by mood/era.

---

## T1 — Tension (Hook, Bit 3 reentry, Outro)

Use at: 0:00–0:33 / 7:30–8:15 / 9:10–9:40  
Role: Recurring motif — use the SAME generated clip each time so the "ring closes" subconsciously.

```
1970s analog tension cue, sparse and minimal, single sustained Rhodes electric piano note, 
low ominous bass drone, brushed cymbal swells, tape hiss, dark, slow build, no drums until 
late, cinematic, instrumental
```

Tempo: ~70 BPM, minor key. Keep sparse — this is a bed under voiceover.

**T1-build variant** (for Bit 3 pressure, 3:30–5:15):  
Same base prompt, add: `tight syncopated bass, driving hi-hat, rising intensity`

---

## T2 — Warm / Calm (Bit 1 — the success years)

Use at: 0:35–1:50  
Role: Deceptively hopeful — beautiful but slightly uneasy, pre-collapse warmth.

```
1970s california soft rock, warm, gentle, hopeful but slightly uneasy, soft Rhodes and clean 
guitar, mellow, sparse, instrumental
```

Tempo: ~80 BPM. Leave space (gaps) — don't fill every second.

---

## T3 — Melancholy (Bit 2 — the breakups)

Use at: 1:50–3:30  
Role: The "human" track — goes under the divorce and separation sections.

```
1970s california soft rock ballad, melancholic, warm analog tape, gentle Fender Rhodes, 
clean fingerpicked electric guitar, soft brushed drums, mellow bass, rainy late-night mood, 
minor key, slow, intimate, instrumental
```

Tempo: ~65–72 BPM. Leave air (pauses between phrases) — this is where emotions breathe.

---

## T4 — Bittersweet / Triumphant (Climax — "40 million copies")

Use at: 8:15–9:10 (swell peaks at 8:55)  
Role: Full dynamic moment — major key but with grief underneath.

```
1970s soft rock anthem, bittersweet, major key with melancholic undertones, full warm band 
arrangement, layered electric pianos, jangly clean guitars, steady drums, uplifting but 
wistful, analog warmth, building to emotional peak, instrumental
```

Tempo: ~90–100 BPM. This is one of only two moments where music rises above the voiceover.

---

## T5 — Pastiche "This Is What They Sounded Like" (Feature moment)

Use at: 5:15–7:13 (feature peak at 7:00–7:13, voiceover silent)  
Role: A 10–15 second original piece that sounds like the era — NOT a cover, NOT imitating FM.

```
1970s california soft rock, full song arrangement, catchy chord progression, warm Rhodes 
and clean electric guitar interplay, melodic bassline, steady soft rock groove, 
harmony-vocal feel but instrumental, sunny yet bittersweet, analog 1977 production, 
instrumental
```

At 7:00, bring this up to feature volume (−5 dB) for 13 seconds while voiceover pauses. Then fade back down.

---

## Cue Sheet — RECALCULATED for real 5:21 voiceover

| Timecode | Track | Volume | Action |
|----------|-------|--------|--------|
| 0:00 | T1 | −18 dB | Fade in 1.5s, tension motif (Hook) |
| ~0:33 | T1 | — | HARD CUT + 0.5s silence (end of open loop — intentional) |
| 0:35 | T2 | −18 dB | Fade in 2s (Bit 1 — success) |
| ~1:45 | T3 | −18 dB | Crossfade 2.5s (Bit 2 — breakups) |
| ~2:50 | T1-build | −18→−14 dB | Crossfade 2s, tension rises (Bit 3 — Sausalito) |
| 3:10 | T5 | −19 dB | Crossfade 2s, pastiche bed under Bit 4 (the songs) |
| ~3:30 | T5 | −7 dB | OPTIONAL feature lift 6–8s between sentences, then back to −19 |
| 4:03 | T1 | −17 dB | Crossfade 2s, tension reprise (Bit 5 — affair) |
| 4:26 | T4 | −15→−9 dB | Bittersweet swell, peaks ~4:50 ("40 million") |
| 4:58 | T1 | −15 dB → fade | Final motif, fade out 4s to silence (Outro) |

**Key rule:** Music peaks above bed only twice — the optional T5 lift (~3:30) and the T4 climax swell (~4:50). Everywhere else it's a quiet bed under the voice.

**Note on the feature moment:** the recorded VO is continuous (5:21), so there's no long silent gap for a 13s instrumental showcase. Use a short 6–8s T5 lift between sentences in Bit 4, or skip it and keep T5 as a bed.

## Track lengths to generate in Suno

| Track | Min length needed | Used at |
|-------|-------------------|---------|
| T1 (+ T1-build variant) | ~60s (reuse same motif 3×) | 0:00–0:35, 2:50–3:10, 4:03–4:26, 4:58–5:21 |
| T2 Warm | ~70s | 0:35–1:45 |
| T3 Melancholy | ~65s | 1:45–2:50 |
| T5 Pastiche | ~55s | 3:10–4:03 |
| T4 Bittersweet | ~35s | 4:26–4:58 |

Suno clips run 2–4 min, so length is never the problem — generate, then trim to the window above.

---

## For Future Episodes

Save generated clips by tag: `tension / warm / melancholy / bittersweet / pastiche / [era]`  
Each new episode reuses library tracks and only needs a new T5 pastiche for its specific era/genre.
