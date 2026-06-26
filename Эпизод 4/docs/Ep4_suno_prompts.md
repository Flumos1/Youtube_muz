# Ep4 Suno Prompts — Napster

> Все треки: **Instrumental only** — никогда не указывай имена реальных артистов.
> Модель: **chirp-v4** (или лучшее доступное). Жанр = стиль эпохи, не имя исполнителя.
> Каждый трек генерируй дважды (v1/v2) — выбирай лучший дубль.

---

## T1 — "Digital Shadow" (Tension / Recurring motif)

**Используется:** Hook 0:00–0:40 + Outro 9:10–конец. Повторяется 3 раза — это фирменный мотив эпизода.

**Настроение:** Тёмный интернет 1999 года. Что-то большое надвигается — ты ещё не знаешь что. Dial-up соединение как предчувствие конца света. Неизбежность.

```
instrumental, late 1990s dark electronic ambient, cinematic tension, slow build,
digital paranoia, minor key, sparse piano melody over electronic pulse,
processed static texture, cold synthetic pads, slow BPM 65,
oppressive and inevitable, night atmosphere, no drums at start then subtle kick enters,
film score quality, documentary underscore, sense of something massive approaching,
no vocals, no lyrics
```

**Negative:** uplifting, major key, pop, cheerful, fast tempo, vocals

---

## T2 — "Sixty Days" (Wonder / Obsession)

**Используется:** Bit 1 — Dorm Room 0:40–2:10. Мальчик, который не может спать и меняет мир.

**Настроение:** 3 часа ночи в общежитии. Экран светится в темноте. Что-то складывается — строка за строкой кода. Не страх — азарт. Молодость, которая ещё не знает, что невозможно.

```
instrumental, late 1990s indie electronic, bedroom producer aesthetic,
lo-fi digital warmth, curious and propulsive, uptempo BPM 110,
electric piano riff, subtle synth arpeggios, crisp programmed drums,
early internet era optimism, caffeinated late-night energy, forward momentum,
Y2K electronic, bright but slightly melancholic undertone,
cinematic documentary feel, no vocals, no lyrics
```

**Negative:** heavy, dark, corporate, slow, orchestral, sad

---

## T3 — "The Machine" (Corporate Dread / Legal Pressure)

**Используется:** Bit 2 Panic 2:10–4:00 + Bit 3 Shutdown 4:00–5:50. Лейблы, юристы, суды. Стена закрывается.

**Настроение:** Институциональная машина. Холодная, безличная, неостановимая. Не злая — хуже: равнодушная. Тринадцать коробок с именами. Решение суда. Семьдесят миллионов пользователей остались в темноте.

```
instrumental, late 1990s industrial influenced dark electronic,
ominous corporate menace, slow grinding rhythm BPM 80,
heavy low-end bass pulse, dissonant synth stabs, mechanical percussion,
cold and oppressive atmosphere, minor key orchestral strings underneath,
sense of inevitable crushing weight, tension without release,
documentary underscore, cinematic, no vocals, no lyrics
```

**Negative:** uplifting, warm, fast, pop, acoustic, cheerful

---

## T4 — "Forty Billion" (Bittersweet Revelation / Climax)

**Используется:** Climax 8:00–9:10. Момент откровения — Napster был прав. Лейблы — акционеры Spotify. Триумф и горечь одновременно.

**Настроение:** Ты выиграл — но тебя уже нет. История доказала твою правоту через двадцать лет. Это не победный марш — это что-то куда более сложное: когда справедливость наконец восторжествовала, но слишком поздно и не для тех.

```
instrumental, cinematic bittersweet electronic, late 2000s indie film score aesthetic,
rising emotional arc, major key with minor undertones, slow build to powerful swell,
piano melody over sustained strings, electronic pulse underneath,
sense of distant triumph, melancholic resolution, emotional catharsis,
BPM 90 building, dynamic crescendo in final third, documentary emotional peak,
no vocals, no lyrics
```

**Negative:** aggressive, heavy metal, fast, chaotic, dark, oppressive

---

## T5 — "1999" (Era Pastiche / Feature moment)

**Используется:** Поднимается на передний план на 13 секунд в момент появления Metallica (~2:30) — самый узнаваемый звук эпохи. Потом уходит обратно в фон.

**Настроение:** Это ТОЧНО звучит как конец девяностых. Агрессия, стадионная энергия, тяжёлые гитары — эпоха, когда Metallica была богами. На 13 секунд зритель должен ПОЧУВСТВОВАТЬ то время кожей.

```
instrumental, late 1990s alternative rock, heavy distorted electric guitar riff,
aggressive stadium energy, tight punchy drums, powerful bass line,
nu-metal adjacent, dark and confident, BPM 120, driving rhythm,
cinematic rock underscore, era-defining sound of 1999-2001,
no vocals, no lyrics, no singing
```

**Negative:** electronic, ambient, soft, acoustic, orchestral, slow, pop

---

## Cue Sheet — раскладка по таймкоду

| Таймкод | Трек | Уровень | Действие |
|---------|------|---------|---------|
| 0:00 | T1 "Digital Shadow" | −16 dB | Начинается под Hook, медленно нарастает |
| 0:40 | T2 "Sixty Days" | −16 dB | Кроссфейд 2s → Dorm Room section |
| 2:10 | T3 "The Machine" | −16 dB | Кроссфейд 2s → Panic begins |
| 2:30 | T5 "1999" | **−5 dB** | **ПОДНЯТЬ на 13s** (Metallica moment) → обратно −16 dB |
| 5:50 | T3 → тишина | fade out | Emotional Breath — почти тишина, только T1 тихо |
| 6:00 | T1 whisper | −22 dB | Под $2B memo — очень тихо |
| 6:20 | T2 "Sixty Days" | −16 dB | Jobs/iTunes section — возвращение оптимизма |
| 8:00 | T4 "Forty Billion" | −16 dB | Climax — нарастает к кульминации |
| 8:45 | T4 | −10 dB | Пик — "Spotify is worth forty billion" |
| 9:10 | T1 "Digital Shadow" | −16 dB | Outro — кольцо закрывается |
| 9:35 | T1 | fade out | Конец |

---

## Ключевые правила
- Все треки: Instrumental only, никаких вокалов
- T5 — единственный момент, когда музыка выходит вперёд (−5 dB на 13s)
- T4 второй пик на −10 dB в момент "forty billion" (8:45)
- Везде остальное: музыка = фон под VO, −16 до −18 dB
- Кроссфейды между треками: 2 секунды
