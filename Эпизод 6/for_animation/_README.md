# Ep5 — Animation Handoff Folder

**Workflow (to save Kling credits — user animates externally):**

1. Claude generates all stills → selects **25** for animation and copies them HERE as `MMSS.png`
   (filename = timecode on the timeline; e.g. `0008.png` = 0:08).
   - First ~8 hook frames (0:00–0:40) — always animated.
   - Plus every still that falls inside the 3 Shorts windows.
2. **You animate** each `MMSS.png` → export a short clip → drop it back in THIS folder
   as `MMSS.mp4` (same timecode name, 1080p, ~5s, motion should match the still's mood).
3. Claude moves the finished `MMSS.mp4` files into `../videos/` and runs `assemble_ep5.ps1`,
   which overlays them onto the Ken Burns timeline (and MUTES any clip audio).

**Naming is everything:** `0008.png` → you return `0008.mp4`. Keep the 4-digit timecode.

The exact 25-frame list will be added here as `_animation_list.md` once the stills exist.
