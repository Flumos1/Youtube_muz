# Ep4 Kling Animation Plan — 16 clips

**Model:** kling3_0_turbo · 1080p · 5s · 16:9 · start_image = source PNG job_id
**Source job_ids** = the Higgsfield image generation jobs (pass as medias[].value, role start_image).
**Note:** decline preset "IN THE DARK" (id 24bae836-...) → generate literally for precise camera motion.
**Output:** save each as `Эпизод 4/videos/MMSS.mp4` (timecode = where it sits on the timeline).

| # | TC | job_id (start_image) | Short | Motion prompt |
|---|----|----|----|----|
| 1 | 0000 | 75154231-7082-49db-8399-35802800abe5 | S1 | slow dolly push-in down server aisle, LEDs flicker, haze drift |
| 2 | 0016 | 3409d80b-0dc6-4707-8f82-939b359c8fae | S1 | slow lateral truck past glowing drive racks, parallax |
| 3 | 0032 | a1958df7-364b-41b8-b0e3-e91ad7ef2d60 | S1 | slow tilt-up the server towers, LED shimmer |
| 4 | 0046 | dc838a35-2210-4920-83a2-1b0c27abb9ac | S1 | slow creep-in toward the distant terminal glow |
| 5 | 0054 | 21db66b8-d6bd-4d08-97d2-6af5b8457893 | S1 | gentle push toward boy at CRT, code scrolls, lamp flicker |
| 6 | 0149 | ca0aabbb-a2e5-4a9b-ac87-7cc11c3bc2dd | — | network threads igniting one by one across the map |
| 7 | 0224 | 0c4e9753-f3db-4447-b0c9-50d2ce96cb54 | — | slow truck down the lab row, monitors flicker in unison |
| 8 | 0343 | 4550c9a4-be57-41e6-bfcb-675d985d0b64 | S2 | slow push toward the box wall, figure shifts, tension |
| 9 | 0415 | e2f1a3ee-5522-41cc-a55b-45db69750cac | S2 | slow dolly toward bench, light shaft drifts, dust |
| 10 | 0452 | fbae6696-73fe-4150-9997-719d781bdb19 | — | screen fades to black, power LED dims, reflection still |
| 11 | 0612 | b7e46fb6-b5a4-4ded-8605-432d801d63fb | — | slow drift down empty CD aisle, fluorescent flicker |
| 12 | 0737 | 9c78fcdf-5fb7-48f9-a95c-7c27a4f58d5b | — | spotlight breathes, silhouette still, audience hush |
| 13 | 0938 | 5d095619-9ed1-4166-bb5a-69c0f9c0daeb | S3 | gentle push over shoulder to glowing screen, blue flicker |
| 14 | 1002 | b37c2678-7f67-47dd-8459-207c796db685 | S3 | slow pull-back from laptop into the warm dark room |
| 15 | 1016 | 8469f117-6880-4e5d-a6bb-5e3c1891b641 | S3 | slow push across boardroom, chart glows, city beyond |
| 16 | 1044 | d080ac01-6f7c-470a-8be4-45c78811c57f | — | dawn light creeps in, power LED blinks, dust motes |

**Status (2026-06-26): ✅ COMPLETE.** All 16 clips generated (kling3_0_turbo, 1080p, 5s) and
downloaded to `videos/MMSS.mp4`. 71 images in `images/higgsfield_images/MMSS.png`. Verified:
server-room push-in, Metallica box push, Spotify-climax profile reveal all clean & cinematic.
Spend: ~168 cr (71 imgs ≈ 3 cr + 16 clips ≈ 165 cr); 206 cr left.
**Note:** Kling clips carry native audio — mute/replace in CapCut (music = Suno T1–T5).

## NEXT: CapCut assembly
1. Import VO `audio/Ep4_VO_full.mp3` (10:45) on track 2 (reference).
2. Place 71 images on track 1 at their MMSS timecodes, ~8s each; Ken Burns (slow zoom/pan) on stills.
3. Drop the 16 MMSS.mp4 clips over their matching stills (mute their audio).
4. Music T1–T5 on tracks 3–4 per `Ep4_suno_prompts.md` cue sheet (T5 +-5dB at 3:43, T4 -10dB at 9:38).
5. Export 1080p, Loudness Normalization ON → `out/ep4_final.mp4`.
6. Shorts: `scripts/create_shorts.ps1 -Episode 4` (cuts already defined).
