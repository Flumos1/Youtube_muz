# Flumos — Growth Execution Plan (10 levers) — 2026-06-30

**Core problem (from real data):** Shorts get views (1.8K/1.7K/1.1K/577/423…), long videos get 1–13.
The funnel WIRING works (Видео по теме is set), but **conversion + cold-start impressions** are the gap.
4 subs from ~7,000 Short views. Fix = squeeze the Short→long→sub funnel + seed cold-start traffic.

Legend: ✅ done · 🔧 I implemented in Studio this session · 📋 ready artifact for you to execute · 🔁 ongoing habit

---

## 1. 📋 Cliffhanger Shorts (withhold the payoff) — BIGGEST lever
Current Shorts tell the whole mini-story → no reason to click the long video. New rule: **end on an open loop.**

**Ending template (last spoken line of every Short):**
> "…but what happened next is the part nobody talks about. The full story is in the video on screen. 👆"

**Cutting rule for `create_shorts.ps1`:** cut the clip so it STOPS right before the resolution (the "why/how"
reveal). Hook + escalation + question → cut. Never include the answer. The two buttons (already burned in)
then point to where the answer lives.

**Per-Short open-loop hooks to reuse:**
- Napster: "Two college kids built it in 60 days. What Metallica did next is why the music industry collapsed →"
- Sex Pistols: "One word on live TV. The trial that followed is still taught in law schools →"
- Pink Floyd: "He spat in a fan's face. The wall he built around himself became the best-selling—  →"

---

## 2. ✅/📋 Pinned comment with the long-video link on EVERY Short
Link in a Shorts COMMENT is clickable (description link is not). Pack ready: `docs/shorts_pinned_comments.md`.
Posting must be done by you (Studio can't post Short comments). Start with the 1.7–1.8K Fleetwood Mac Shorts.

## 3. ✅ Two-button end card (WATCH FULL VIDEO + SUBSCRIBE)
Burned into the last 5s of every new Short via `create_shorts.ps1` (default ON). 6 fresh Shorts re-rendered.

---

## 4. 📋 Matched pair: publish Short + long on the SAME topic, SAME day
When a Short pops, the same-topic long video is the natural next click and YouTube cross-promotes via
Видео по теме. Stop publishing longs in detached bursts.

**Weekly cadence (🔁, upgraded 2026-07-01 — Shorts now DAILY, not 3x/week):**
| Day | Action |
|---|---|
| Mon | Long video #N publishes (same topic as the week's Shorts) |
| Every day | 1 Short, all pointing to that week's long video (cliffhanger ending, no payoff) |
| Sat | Reply to all comments; pin the question |

## 5. 🔧 Packaging (titles/thumbnails)
Measured CTR is healthy (25% on Napster) → titles/thumbnails are NOT the bottleneck, impressions are.
So: keep titles, just make sure each long video's **description** front-loads the hook + has the Shorts/playlist
links (done in Studio this session). Thumbnail rule going forward: ONE bold face/emotion + ≤4 words.

## 6. 📋 Retention cold-open (first 15s)
The handful of viewers a long video gets MUST be held or the algorithm never expands reach. Open every long
video on the single most shocking fact in the first 10s (no channel intro, no "welcome back"). Check
Studio → Analytics → Audience retention; fix any first-30s cliff.

## 7. ✅ Playlist "Music's Darkest Stories" + end screens
Playlist created with all 5 long videos. End screens DONE (2026-07-01): all 5 long videos now chain to each
other (not auto-pick) in a closed loop matching publish order: Fleetwood Mac → Pink Floyd → Sex Pistols →
Napster → Phil Spector → back to Fleetwood Mac.

## 8. 🔁 Engagement loop
Pin a question comment on every Short and long video ("Which artist should I cover next? 👇") and reply to
every comment within the hour for the first day. Replies + pinned Q lift the video in the feed and convert
curious Short-viewers into subs.

## 9. 🔁 Consistent schedule
1 long/week on a fixed day + 3 Shorts/week. Erratic bursts (4 longs in 2 days) confuse distribution.
Consistency is what eventually unlocks Browse-feed impressions on a small channel.

## 10. 📋 External cold-start seeding (Reddit + groups) — fastest first 100–1000 views
Post each long video (or a 60–90s teaser) where music-history fans already gather. Within copyright rules
(your own AI-made docs). Draft posts below — paste & post.

### Reddit drafts (title → body)
**r/pinkfloyd / r/Music** — Pink Floyd:
> Title: TIL the wall Roger Waters built on stage came from him spitting on a fan in 1977 — I made a short doc on how The Wall was really born
> Body: Dug into how one moment of contempt for his own audience turned into a double album and a film. AI-assisted visuals, ~12 min. Would love feedback from people who know the album better than me. [link]

**r/punk / r/SexPistols** — Sex Pistols:
> Title: One word on live TV nearly got the Sex Pistols erased — and a shopkeeper arrested. The Grundy interview, the trial, the whole story.
> Body: Made a short documentary on how "Bollocks" ended up on trial in a British court and why it made the band immortal. ~11 min. [link]

**r/Music / r/technology / r/Metallica** — Napster:
> Title: Two college kids built Napster in 60 days. Then Metallica showed up with 317,000 usernames. How file-sharing nearly killed the music industry.
> Body: The $20B lawsuit, the irony of who actually profited, and how it led to Spotify. ~11 min doc. [link]

**r/Music / r/popheads** — Fleetwood Mac:
> Title: Fleetwood Mac recorded Rumours while every couple in the band was breaking up with each other — and it sold 40 million.
> Body: They turned their own divorces into the songs. Short doc on how. ~5 min. [link]

**r/Music / r/TrueCrime** — Phil Spector:
> Title: He invented the "Wall of Sound" that defined the 60s — then shot a woman dead in his mansion.
> Body: From producing girl-group masterpieces to a murder conviction. ~15 min doc. [link]

(Rules: post to ONE sub at a time, space them out, engage in comments, don't spam — Reddit nukes link-droppers.)

---

## 7-day action checklist
- [ ] Re-render endings of next Shorts as open loops (#1)
- [ ] Post + pin the link comment on the 3 Fleetwood Mac Shorts first (#2)
- [x] Add end screens (playlist "next") on all 5 long videos (#7) — done 2026-07-01
- [ ] Pin a question comment on each long video (#8)
- [ ] Post the Pink Floyd Reddit draft (your most-viewed Short topic) (#10)
- [ ] Lock the weekly calendar (#4/#9)
