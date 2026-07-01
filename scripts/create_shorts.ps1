<#
  Create 3 vertical Shorts from a finished episode video.
  Crops center 9:16 from 16:9 source, scales to 1080x1920.

  Usage:
    pwsh scripts\create_shorts.ps1 -Episode 2
    pwsh scripts\create_shorts.ps1 -Episode 3 -SourceFile "ep3_final.mp4"
    pwsh scripts\create_shorts.ps1 -Episode 4            # subscribe CTA overlay ON (default)
    pwsh scripts\create_shorts.ps1 -Episode 4 -NoCTA     # plain cut, no overlay

  TWO action buttons are burned into the LAST $CTASecs seconds of every Short
  (the #1 Short -> long-video + subscriber conversion lever):
    [ WATCH FULL VIDEO ]  (blue)  -> points to the "Видео по теме"/related link
    [ SUBSCRIBE ]         (red)   -> nudges the native channel subscribe
  Pass -NoCTA to skip the overlay. Use -CTASecs N to change how long it shows (default 5).

  NOTE: buttons are visual cues, not clickable. The only clickable Short->long link is
  the "Видео по теме" chip set in Studio. Always set it after upload.

  Cut points are defined per-episode in the $cuts hashtable below.
  Add a new entry for each episode before running.
#>
param(
  [Parameter(Mandatory)][int]$Episode,
  [string]$SourceFile = "",   # auto-resolved if omitted
  [switch]$NoCTA,             # disable the end-of-Short CTA overlay
  [int]$CTASecs = 5          # how many seconds the two buttons stay on screen (end of clip)
)

$ROOT   = Split-Path $PSScriptRoot -Parent
# Resolve ffmpeg: prefer the C:\Temp build, fall back to node_modules (this machine), then PATH
$FFMPEG = @(
  (Get-ChildItem "C:\Temp\ffmpeg_dl\ffmpeg-*essentials_build\bin\ffmpeg.exe" -ErrorAction SilentlyContinue |
     Sort-Object FullName -Descending | Select-Object -First 1 -Expand FullName),
  (Join-Path $ROOT "node_modules\ffmpeg-static\ffmpeg.exe")
) | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1
if (-not $FFMPEG) { $FFMPEG = (Get-Command ffmpeg -ErrorAction SilentlyContinue).Source }
if (-not $FFMPEG) { Write-Error "ffmpeg not found (C:\Temp, node_modules, or PATH)"; exit 1 }
$CROP   = "crop=ih*9/16:ih:(iw-ih*9/16)/2:0,scale=1080:1920"
$FONT   = "C\:/Windows/Fonts/impact.ttf"   # burned-in subscribe CTA font (last 3s)

# ── Per-episode cut points ────────────────────────────────────────────────────
# Format: @{ label; start (HH:MM:SS); end (HH:MM:SS) }
$cuts = @{
  1 = @(
    @{ label="short1_dog";     start="00:00:00"; end="00:00:33" }
    @{ label="short2_divorce"; start="00:00:33"; end="00:01:25" }
    @{ label="short3_40m";     start="00:03:10"; end="00:04:10" }
  )
  2 = @(
    @{ label="short1_spit";   start="00:03:01"; end="00:04:34" }
    @{ label="short2_syd";    start="00:01:33"; end="00:03:01" }
    @{ label="short3_wright"; start="00:07:46"; end="00:08:46" }
  )
  3 = @(
    @{ label="short1_hook";    start="00:00:00"; end="00:01:00" }   # arrested shop owner -> McLaren premise
    @{ label="short2_grundy";  start="00:04:40"; end="00:05:40" }   # Bill Grundy live TV incident
    @{ label="short3_trial";   start="00:08:45"; end="00:09:45" }   # chart irregularities -> Bollocks trial
  )
  4 = @(
    @{ label="short1_hook";    start="00:00:00"; end="00:01:00" }   # two college kids -> federal judge (animated 0000-0102)
    @{ label="short2_metallica"; start="00:03:35"; end="00:04:40" } # Metallica 13 boxes, 317K users, most hated band
    @{ label="short3_40billion"; start="00:09:30"; end="00:10:30" } # $40B, labels are Spotify shareholders (irony)
  )
}
# ─────────────────────────────────────────────────────────────────────────────

if (-not $cuts.ContainsKey($Episode)) {
  Write-Error "No cut points defined for Episode $Episode. Add them to the `$cuts hashtable in this script."
  exit 1
}

# Resolve episode folder (Cyrillic name — use wildcard)
$EP = (Get-ChildItem -LiteralPath $ROOT -Directory |
       Where-Object { $_.Name -like "* $Episode" } |
       Select-Object -First 1).FullName
if (-not $EP) { Write-Error "Episode $Episode folder not found"; exit 1 }

$OUT = Join-Path $EP "out"
New-Item -ItemType Directory -Force $OUT | Out-Null

# Resolve source file
if (-not $SourceFile) {
  $src = Get-ChildItem $OUT -Filter "ep${Episode}_final.mp4" | Select-Object -First 1
  if (-not $src) { $src = Get-ChildItem $OUT -Filter "*.mp4" | Sort-Object LastWriteTime -Descending | Select-Object -First 1 }
  if (-not $src) { Write-Error "No source file found in $OUT. Pass -SourceFile explicitly."; exit 1 }
  $SourceFile = $src.FullName
}
Write-Host "Source: $SourceFile"

foreach ($cut in $cuts[$Episode]) {
  $dest = Join-Path $OUT "ep${Episode}_$($cut.label).mp4"

  # Build the video filter: center-crop/scale, plus TWO action buttons burned into the
  # last $CTASecs seconds — [WATCH FULL VIDEO] (blue) over [SUBSCRIBE] (red).
  $vf = $CROP
  if (-not $NoCTA) {
    $dur = [int](([timespan]$cut.end).TotalSeconds - ([timespan]$cut.start).TotalSeconds)
    $cs  = [math]::Max(0, $dur - $CTASecs)
    $en  = "enable='between(t,$cs,$dur)'"
    # Button 1 — WATCH FULL VIDEO (blue), sits mid-low; subtext points at the related-video chip
    $btn1 = "drawtext=fontfile='$FONT':text='WATCH FULL VIDEO':fontcolor=white:fontsize=86:box=1:boxcolor=0x1565C0@0.95:boxborderw=24:x=(w-text_w)/2:y=h*0.50:$en," +
            "drawtext=fontfile='$FONT':text='tap the link bottom-left':fontcolor=white:fontsize=46:box=1:boxcolor=black@0.55:boxborderw=12:x=(w-text_w)/2:y=h*0.50+140:$en"
    # Button 2 — SUBSCRIBE (red), below it; subtext = value promise
    $btn2 = "drawtext=fontfile='$FONT':text='SUBSCRIBE':fontcolor=white:fontsize=110:box=1:boxcolor=red@0.95:boxborderw=26:x=(w-text_w)/2:y=h*0.66:$en," +
            "drawtext=fontfile='$FONT':text='a new music story every week':fontcolor=white:fontsize=46:box=1:boxcolor=black@0.55:boxborderw=12:x=(w-text_w)/2:y=h*0.66+170:$en"
    $vf = "$CROP,$btn1,$btn2"
  }

  Write-Host "Cutting $($cut.label): $($cut.start) → $($cut.end)  (CTA: $(-not $NoCTA))"
  & $FFMPEG -y -ss $cut.start -to $cut.end -i $SourceFile `
    -vf $vf -c:v libx264 -preset fast -crf 18 -c:a aac -b:a 192k $dest 2>$null
  if (Test-Path $dest) {
    $mb = [math]::Round((Get-Item $dest).Length/1MB, 1)
    Write-Host "  -> $dest ($mb MB)"
  } else {
    Write-Error "  FAILED: $dest"
  }
}

Write-Host "`nDone. Upload order: short1, short2, short3"
Write-Host "Clipboard tip: write each path via: mcp__computer-use__write_clipboard"
