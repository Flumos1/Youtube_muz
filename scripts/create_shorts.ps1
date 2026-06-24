<#
  Create 3 vertical Shorts from a finished episode video.
  Crops center 9:16 from 16:9 source, scales to 1080x1920.

  Usage:
    pwsh scripts\create_shorts.ps1 -Episode 2
    pwsh scripts\create_shorts.ps1 -Episode 3 -SourceFile "ep3_final.mp4"

  Cut points are defined per-episode in the $cuts hashtable below.
  Add a new entry for each episode before running.
#>
param(
  [Parameter(Mandatory)][int]$Episode,
  [string]$SourceFile = ""   # auto-resolved if omitted
)

$ROOT   = Split-Path $PSScriptRoot -Parent
$FFMPEG = "C:\Temp\ffmpeg_dl\ffmpeg-8.1.1-essentials_build\bin\ffmpeg.exe"
$CROP   = "crop=ih*9/16:ih:(iw-ih*9/16)/2:0,scale=1080:1920"

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
  Write-Host "Cutting $($cut.label): $($cut.start) → $($cut.end)"
  & $FFMPEG -y -ss $cut.start -to $cut.end -i $SourceFile `
    -vf $CROP -c:v libx264 -preset fast -crf 18 -c:a aac -b:a 192k $dest 2>$null
  if (Test-Path $dest) {
    $mb = [math]::Round((Get-Item $dest).Length/1MB, 1)
    Write-Host "  -> $dest ($mb MB)"
  } else {
    Write-Error "  FAILED: $dest"
  }
}

Write-Host "`nDone. Upload order: short1, short2, short3"
Write-Host "Clipboard tip: write each path via: mcp__computer-use__write_clipboard"
