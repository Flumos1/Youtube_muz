# Ep4 Timecode Map — Napster

**VO duration:** 10:45
**Cadence:** новый кадр каждые **~8 секунд** (как Ep2/Ep3) → **~85 кадров всего**
**Image naming:** MMSS.png = таймкод слота
**Higgsfield workflow:** 1 сцена = 1 батч из 4 (макс на starter). Внутри сцены — 4+ ракурса/композиции одной локации (та же эпоха/настроение, разный кадр) → визуал меняется каждые 8s, не статично.

> ⚠️ Главное отличие от прошлой версии: НЕ 16 кадров по 40s, а ~85 кадров по 8s + анимация
> первых 5 кадров (хук) и попадание Kling в окна всех 3 Shorts. Это и есть «динамика».

---

## КАРТА АНИМАЦИИ (Kling) — 16 клипов

**Правило (из Ep2):** первые 5 кадров хука анимируются ВСЕ → зритель не успевает заскучать в первые 40s (решает retention). Дальше — по 1 анимации на ключевой бит, с прицелом в Shorts.

| Таймкод | Сцена | Зачем анимация | Short |
|---------|-------|----------------|-------|
| 0000 | server room | хук, движение в кадре | **S1** |
| 0008 | hard drives pulse | хук | **S1** |
| 0016 | terminal glow | хук | **S1** |
| 0024 | data spreading | хук | **S1** |
| 0032 | city scale | хук-финал | **S1** |
| 0046 | dorm reveal | переход к истории | **S1** |
| 0102 | Shawn coding | живой герой | **S1** |
| 0149 | Napster spreads | сеть оживает | |
| 0224 | 70M users | масштаб | |
| 0343 | Metallica 13 boxes | пик конфликта | **S2** |
| 0415 | courtroom | напряжение | **S2** |
| 0452 | Napster dies | эмоц. удар | |
| 0612 | empty record store | коллапс | |
| 0737 | iTunes launch | поворот | |
| 0938 | Spotify climax | кульминация | **S3** |
| 1016 | labels as shareholders | ирония-пейофф | **S3** |

**Приоритет рендера Kling** (если время поджимает): 0000-0032 (хук, обязательно) → 0343, 0415, 0938, 1016 (Shorts) → остальные.

---

## SHORTS — точки нарезки (добавлены в create_shorts.ps1)

| Short | Окно | Содержание | Анимация внутри |
|-------|------|-----------|-----------------|
| 1 | 00:00 – 01:00 | Хук: два студента, федеральный суд, угроза индустрии | 0000-0102 (7 клипов!) |
| 2 | 03:35 – 04:40 | Metallica: 13 коробок, 317K юзеров, самая ненавидимая группа | 0343, 0415 |
| 3 | 09:30 – 10:30 | $40 млрд, лейблы — акционеры Spotify (ирония) | 0938, 1016 |

Все 3 Shorts содержат анимацию → выше шанс залететь в Shorts-фид.

---

## СЕТКА КАДРОВ (8s слоты) + сцены

Каждая сцена = 1 Higgsfield батч. Генерируй **4+ вариаций** (разный ракурс/план/композиция,
одна локация и эпоха) и раскладывай по слотам. ⚡ = анимировать в Kling.

### S1 — Hook: цифровая угроза (0:00–0:54) · слоты: 0000⚡ 0008⚡ 0016⚡ 0024⚡ 0032⚡ 0040 0046⚡
```
cinematic, analog film grain, moody, 1999 digital aesthetic, no text, no logos, photorealistic, 16:9
Empty server room bathed in cold blue monitor light, rows of blinking hard drives, tangled cables,
a single figure silhouetted at a distant terminal, sense of something irreversible beginning,
digital paranoia, late-night dread. Variations: wide server aisle / macro blinking drive LEDs /
over-shoulder at glowing terminal code / pull-back revealing the lone figure.
Negative: text, words, letters, logos, watermarks, smartphones, color daylight
```

### S2 — Dorm room, Shawn Fanning 1998 (0:54–1:49) · слоты: 0054 0102⚡ 0110 0118 0126 0134 0142
```
cinematic, analog film grain, warm, 1998 college dorm aesthetic, no text, no logos, photorealistic, 16:9
Small messy dorm room at 3am, young man hunched over an old CRT monitor, empty energy-drink cans,
code reflected in his glasses, single desk lamp, stacks of CD cases. Caffeinated obsession.
Variations: wide messy room / close hands on keyboard / face lit by monitor / CRT screen full of code.
Negative: text, words, letters, logos, watermarks, smartphones, flat LCD screens
```

### S3 — Napster launches & spreads (1:49–2:16) · слоты: 0149⚡ 0157 0205
```
cinematic, analog film grain, moody, 2000 internet-era aesthetic, no text, no logos, photorealistic, 16:9
Abstract network coming alive: data streams as light threads connecting countless points across a
dark map, a quiet revolution propagating silently overnight. Variations: glowing node map /
download progress on a CRT / cables fanning out / city-of-lights data web.
Negative: text, words, letters, logos, watermarks, smartphones, modern UI
```

### S4 — 70 million users (2:16–2:56) · слоты: 0216 0224⚡ 0232 0240 0248
```
cinematic, analog film grain, moody, 2000 computer-lab aesthetic, no text, no logos, photorealistic, 16:9
Campus computer lab late at night, rows of CRT monitors all glowing, many people at machines,
mass simultaneous activity, overhead fluorescent hum, underground energy. Variations: long lab row /
two students sharing a screen / overhead of glowing monitors / dorm hallways lit by screens.
Negative: text, words, letters, logos, watermarks, smartphones, LCD screens
```

### S5 — Labels panic, boardroom (2:56–3:43) · слоты: 0256 0304 0312 0320 0328 0336
```
cinematic, analog film grain, cold, 2000 corporate aesthetic, no text, no logos, photorealistic, 16:9
Corporate conference room, suited executives around a long table covered in charts, urgent gestures,
disbelief and tension, projector light, emergency meeting, industry under siege. Variations:
wide boardroom / close anxious exec face / hand slamming a report / phones ringing off the hook.
Negative: text, words, letters, logos, watermarks, smartphones, modern tech
```

### S6 — Metallica, 13 boxes (3:43–4:15) · слоты: 0343⚡ 0351 0359 0407
```
cinematic, analog film grain, dramatic, 2000 office aesthetic, no text, no logos, photorealistic, 16:9
Lobby of a tech startup, heavy cardboard boxes stacked on the reception desk, young workers staring
in disbelief, fluorescent light, clash of informal startup vs formal legal intrusion, confrontation.
Variations: boxes towering on desk / worker's stunned face / rock-star figure in shades by the boxes /
wide standoff in the lobby.
Negative: text, words, letters, logos, watermarks, smartphones
```

### S7 — Courtroom ruling (4:15–4:52) · слоты: 0415⚡ 0423 0431 0439 0447
```
cinematic, analog film grain, cold institutional, 2001 aesthetic, no text, no logos, photorealistic, 16:9
Federal courtroom, wood paneling, judge's elevated bench, rows of attorneys with thick binders,
gallery watching tensely, shaft of light through tall windows, the machinery of law, quiet devastation.
Variations: wide courtroom / gavel close-up / attorney stack of documents / young defendant's profile.
Negative: text, words, letters, logos, watermarks, smartphones, modern tech
```

### S8 — Napster goes dark (4:52–5:30) · слоты: 0452⚡ 0500 0508 0516 0524
```
cinematic, analog film grain, moody, 2001 digital aesthetic, no text, no logos, photorealistic, 16:9
A computer screen fading to black, a face reflected watching it die, empty desk, half-drunk coffee,
sudden implied silence, monitor power light dimming, a digital eulogy. Variations: screen going dark /
reflected face / unplugged server rack / empty chair lit by dead monitor.
Negative: text, words, letters, logos, watermarks, smartphones, LCD screens
```

### S9 — Piracy spreads, the hydra (5:30–6:12) · слоты: 0530 0538 0546 0554 0602 0610
```
cinematic, analog film grain, dark, 2001-2003 internet aesthetic, no text, no logos, photorealistic, 16:9
Underground sharing: dim bedroom, multiple CRTs active, cables everywhere, printed forum pages on
walls, uncontrollable proliferation across many networks, post-Napster chaos. Variations: cluttered
desk of screens / many download bars / map of spreading nodes / hands swapping burned CDs.
Negative: text, words, letters, logos, watermarks, smartphones, modern UI
```

### S10 — CD sales collapse, empty stores (6:12–6:27) · слоты: 0612⚡ 0620
```
cinematic, analog film grain, melancholy, 2002-2004 aesthetic, no text, no logos, photorealistic, 16:9
A record store interior, CD racks half-empty, SALE signs, one lone customer browsing, flickering
fluorescents, an industry in slow collapse, afternoon light through the storefront. Variations:
empty aisle / clearance bin / lone customer / shuttered storefront from outside.
Negative: text, words, letters, logos, watermarks, smartphones
```

### S11 — The $2B memo, regret (6:27–6:59) · слоты: 0627 0635 0643 0651
```
cinematic, analog film grain, quiet, 2000 corporate aesthetic, no text, no logos, photorealistic, 16:9
An executive alone at a desk in a dim office, single lamp, an open folder, contemplative posture
looking out a rain-streaked window at the night city, the weight of an ignored decision, regret.
Variations: lone exec at desk / folder under lamp / rain on glass reflection / empty boardroom at night.
Negative: text, words, letters, logos, watermarks, smartphones, readable text
```

### S12 — Steve Jobs watches (6:59–7:37) · слоты: 0659 0707 0715 0723 0731
```
cinematic, analog film grain, contemplative, 2002 aesthetic, no text, no logos, photorealistic, 16:9
A lone visionary figure in a minimalist darkened room studying a glowing screen, calm certainty
while others panic, a quiet plan forming. Variations: silhouette at screen / close eyes lit by display /
sketching an idea on glass / pacing a clean empty office.
Negative: text, words, letters, logos, watermarks, visible branding, readable text
```

### S13 — iTunes launch (7:37–8:07) · слоты: 0737⚡ 0745 0753 0801
```
cinematic, sharp clean light, bright, 2003 tech-keynote aesthetic, no text, no logos, photorealistic, 16:9
A sleek minimalist stage with a single spotlight, a presenter silhouette at a podium, a vast audience
in darkness, a large blank white screen, the moment before a reveal, 2003 optimism. Variations:
stage wide / spotlight silhouette / audience in the dark / a 99-cent coin / clean white product on a table.
Negative: text, words, letters, logos, watermarks, visible Apple branding, readable text
```

### S14 — Apple becomes #1 retailer (8:07–8:46) · слоты: 0807 0815 0823 0831 0839
```
cinematic, soft cinematic light, 2003-2006 aesthetic, no text, no logos, photorealistic, 16:9
Rows of early mp3 players and white earbuds on a surface, the democratization of music ownership,
clean consumer objects, soft warm light, the future quietly arriving into daily life. Variations:
player grid / earbuds tangle / hand picking one up / glowing click-wheel device close.
Negative: text, words, letters, logos, watermarks, smartphones, modern devices
```

### S15 — Reflection: Napster was a prototype (8:46–9:38) · слоты: 0846 0854 0902 0910 0918 0926 0934
```
cinematic, soft melancholic light, late-2000s aesthetic, no text, no logos, photorealistic, 16:9
Quiet montage of the idea living on: people listening on headphones in everyday places, music
flowing invisibly to everyone, the original vision realized. Variations: commuter with headphones /
person at laptop at night / earbuds on a park bench / city of people all listening.
Negative: text, words, letters, logos, watermarks, visible app UI
```

### S16 — Climax: Spotify era, $40B (9:38–10:08) · слоты: 0938⚡ 0946 0954 1002
```
cinematic, warm melancholic light, late-2000s aesthetic, no text, no logos, photorealistic, 16:9
A person alone in an apartment at night, a laptop casting blue light, a vast music library implied
without branding — Napster's original vision made real: all music, anywhere, instantly. Bittersweet.
Variations: laptop glow on face / endless library scroll (abstract) / phone playing in the dark /
streetlight window with music in the air.
Negative: text, words, letters, logos, visible Spotify UI, watermarks
```

### S17 — Irony: labels as shareholders (10:08–10:35) · слоты: 1008 1016⚡ 1024 1032
```
cinematic, analog grain, cold corporate irony, 2010s aesthetic, no text, no logos, photorealistic, 16:9
A glass-walled corporate office, suited executives reviewing financial documents, abstract stock
charts on wall screens (no numbers), the establishment that tried to kill it now profiting from it,
distant triumph over a city skyline. Variations: boardroom with rising chart / handshake over a deal /
exec at window over city / champagne by a stock ticker (abstract).
Negative: text, words, letters, logos, watermarks, readable numbers, brand UI
```

### S18 — Outro: the dorm room echoes (10:35–10:45) · слоты: 1035 1043
```
cinematic, analog film grain, timeless, quiet aesthetic, no text, no logos, photorealistic, 16:9
The empty dorm desk, an old CRT dark but its power light still blinking, a rumpled college hoodie on
the chair, earbuds coiled by the keyboard — the room where it started, the person long gone, the idea
alive everywhere. Variations: empty desk wide / blinking power LED macro / hoodie on chair / window dawn.
Negative: text, words, letters, logos, watermarks, smartphones, modern tech
```

---

## Реальные паузы из silencedetect -35dB (для CapCut монтажа)

| Время | Событие |
|-------|---------|
| 0:46 | конец Hook |
| 0:54 | конец Open Loop → Dorm Room |
| 1:49 | "He called it Napster" |
| 2:56 | конец Bit 1 |
| 3:43 | Metallica section (T5 ⚡ поднять на 13s) |
| 4:34 | "wanted Napster dead" |
| 4:52 | Napster went dark |
| 6:12 | CD collapse |
| 6:27 | $2B memo (Emotional Breath) |
| 7:37 | iTunes launch |
| 9:38 | Climax peak (T4 ⚡ −10 dB) |
| 9:52 | Spotify |
| 10:35 | "they own a piece" → Outro |

---

## Assembly notes
- **Higgsfield model:** Soul Location · 16:9 · no text/logos · батч = 4
- **Цель:** ~85 кадров (18 сцен × 4-7 ракурсов). Меняй ракурс каждый слот — это даёт динамику.
- **Kling:** 16 клипов (см. карту анимации). Первые 5 кадров хука — обязательно.
- **Music cue:** T5 «1999» ⚡ −5 dB на 13s в момент Metallica (3:43). T4 ⚡ −10 dB на climax (9:38).
- **Ken Burns** на статичных кадрах (медленный zoom/pan) — псевдо-движение между анимациями.
