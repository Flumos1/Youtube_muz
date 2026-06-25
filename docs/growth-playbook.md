# Growth Playbook — Flumos (road to 1,000 subscribers)

> Operational companion to `project-strategy.md`. That file is the *what/why* of the channel.
> This file is the *what to do every upload* to fix the one number that matters right now.

## The one problem (snapshot 2026-06-25)

| Metric | 24th | 25th |
|--------|------|------|
| Views | 3,163 | **4,717** (+1,554/day) |
| Videos | 8 | 9 (Short 3 live) |
| **Subscribers** | **3** | **3** ⚠️ |

Views move. Subscribers don't. Conversion ≈ **0.04%** (3 subs / 4,717 views).
At that rate, reaching 1,000 subs needs ~2.4M views — that's running in place.

**YPP threshold:** 1,000 subscribers **AND** (4,000 watch-hours OR 10M Shorts views / 90 days).
The binding constraint for us is **subscribers**, full stop.

**The whole strategy in one line:** stop optimizing for views, optimize for the *subscribe click*.
Lifting conversion 0.04% → 1% is a **25× gain from the same traffic** — far cheaper than 25× more views.

---

## Why viewers don't subscribe (the 3 holes)

1. **No ask.** Shorts had zero subscribe prompt — no text, no voice. Viewer finishes and leaves.
2. **No series pull.** Shorts aren't branded as a series, so there's no "subscribe so I don't miss the next one."
3. **Channel page doesn't sell.** Weak reason to hit Subscribe when landing on the profile.

---

## The 4 levers (status)

### 1. Subscribe CTA burned into every Short — ✅ DONE (2026-06-25)
`scripts/create_shorts.ps1` now burns **"SUBSCRIBE / for the full story"** (red Impact box, lower third)
into the **last 3 seconds** of every Short. ON by default; `-NoCTA` to skip. Verified on this machine.
- **Also (manual, in script/VO):** end every Short's VO with *"Full story's on the channel — subscribe."*
- Applies to **Ep4 onward**. Do **not** re-cut/re-upload Ep3 Shorts (they already have view momentum).

### 2. Channel SEO — ✅ DONE (2026-06-25)
Description was already good (left as-is). Channel keywords expanded **8 → 13**
(added: banned albums, faceless documentary, punk history, music stories, rock documentary).

### 3. Series branding — apply per upload
- Playlist **"Music's Darkest Stories"** already exists → add every long video to it.
- Each Short's description carries a **series marker** (Short #1 / #2 / #3 of the episode).
- Pin a question comment on every video to seed the "subscribe for more" loop.

### 4. Daily routine — see below

---

## Per-upload checklist

**Long video**
- [ ] Title = paradox / curiosity hook (see `project-strategy.md` formulas)
- [ ] Add to **Music's Darkest Stories** playlist
- [ ] Description ends with: `🔔 New story every week — subscribe.`
- [ ] Language metadata = **English (US)** (verify in `/translations` — the Ep1 killer)
- [ ] Pin a question comment ("Which album should we cover next?")
- [ ] End screen: Subscribe + best video

**Each Short (×3)**
- [ ] CTA overlay present (automatic via `create_shorts.ps1`)
- [ ] Description from the template below (series marker + full-story link)
- [ ] "Видео по теме" → the long video (only works once the long is public)
- [ ] Same pinned question comment

### Shorts description template
```
🎬 Music's Darkest Stories — Short #N
Full story → https://youtu.be/VIDEO_ID

🔔 Subscribe — a new music story every week.

#Tag1 #Tag2 #Tag3 #Tag4 #Shorts
```

---

## Daily routine (the unglamorous part)

- **Reply to every comment within 24h** — biggest free algorithm + loyalty boost.
- **Keep the pinned question** fresh on the newest upload.
- **Rhythm:** 1 episode / week + 3 Shorts from it. When idle, re-cut older long videos into new Shorts.
- **Watch the right metric:** track *subscribers gained per 1,000 views*, not raw views.

## Targets

| Milestone | Subs | Realistic note |
|-----------|------|----------------|
| Proof of conversion | 1% subs/view on new Shorts | weeks, if CTA + series land |
| Monetization | 1,000 subs | months at a steady cadence — subscribers first, always |

---

## ▶ EXECUTION SUBPLAN — NEXT SESSION, START HERE (set 2026-06-25)

> Goal: do **all** the additional subscriber levers below. Ordered by leverage.
> Each step is tagged with what it needs, because the next session may run on a
> **different computer** (Chrome extension, analytics MCP, and the ffmpeg path are
> all machine-specific — verify before relying on them).

**STEP 0 — verify tools on this machine** (1 min)
- [ ] ffmpeg present? (`C:\Temp\ffmpeg_dl\...\ffmpeg.exe` — path may differ on a new PC)
- [ ] Chrome extension connected? (needed for any Studio task)
- [ ] Analytics MCP available? (Nexlev / YouTube analytics tools)
- Pick the first do-able step below based on what's available.

**STEP 1 — pull real analytics, find the leak** _(needs analytics MCP; machine-independent otherwise)_
- [ ] Where do the 3 subs come from — Shorts or long? (subscriber source)
- [ ] Long video retention curve — where do people drop?
- [ ] Which Short converted best → clone that hook type.
- Aim the rest of the plan at the biggest hole instead of guessing.

**STEP 2 — Ep4 content levers** _(pure content + ffmpeg; any machine)_
- [ ] Ep4 script: add a **subscribe-ask at the CLIMAX** (the payoff moment), not only the outro.
- [ ] End every Ep4 Short's VO with *"Full story's on the channel — subscribe."*
- [ ] Plan 1 **serialized cliffhanger Short** ("Part 1 — the rest is on the channel") to push Shorts viewers to the long video.

**STEP 3 — Studio quick wins** _(NEEDS the computer with the Chrome extension)_
- [ ] **Video watermark / branded subscribe button**: Studio → Customization → Branding → "Video watermark" → show "At the end of the video". Adds a subscribe button on every long video.
- [ ] **One-click subscribe link** `https://youtube.com/@flumos?sub_confirmation=1` → first line of every description + every pinned comment.
- [ ] **Channel trailer for non-subscribers**: assemble (trailer builder in `scripts/`) → upload → set as channel trailer.
- [ ] **End screen** subscribe element on Ep4.
- [ ] **Thumbnail Test & Compare** on one long video to lift CTR.

**STEP 4 — carryover from 2026-06-25** _(Studio; do once Ep3 long is public)_
- [ ] Bind **"Видео по теме"** in the 3 Ep3 Shorts → long `6Q0QNLyHBvM`.
- [ ] Pin a question comment on every video; reply to all comments within 24h.

**Recommended first move tomorrow:** STEP 1 if analytics MCP is up (aim precisely),
otherwise STEP 2 (Ep4 climax subscribe-ask — works on any machine).

_Last updated: 2026-06-25._

