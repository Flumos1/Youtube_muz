<#
  check_audio_coverage.ps1 — PRE-PUBLISH QC GATE for music/audio coverage.

  WHY (Ep5 Phil Spector shipped with no music after 11:14, user rule 2026-06-30):
  music/audio MUST play to the very end — never a silent or music-less tail.
  Run this on every final BEFORE uploading. Non-zero exit = DO NOT PUBLISH, re-mix
  with scripts\mix_music_bed.ps1.

  Checks:
   1. Any silence gap >= -Gap seconds anywhere (noise floor -45 dB).
   2. Tail loudness: last 60s vs whole-file integrated LUFS — a big drop ⇒ audio fades/dies early.

  Usage:
    pwsh scripts\check_audio_coverage.ps1 -Episode 3
    pwsh scripts\check_audio_coverage.ps1 -File "...\out\ep3_final_musicfix2.mp4"
#>
param(
  [int]$Episode = 0,
  [string]$File = "",
  [double]$Gap = 2.0          # min silence length (s) to flag
)
$ErrorActionPreference = "Stop"
$ROOT = Split-Path $PSScriptRoot -Parent
$bin = (Get-ChildItem "C:\Temp\ffmpeg_dl\ffmpeg-*essentials_build\bin" -Directory -ErrorAction SilentlyContinue |
          Sort-Object FullName -Descending | Select-Object -First 1).FullName
$FF = Join-Path $bin "ffmpeg.exe"; $FP = Join-Path $bin "ffprobe.exe"

if (-not $File) {
  if ($Episode -le 0) { throw "Pass -Episode N or -File path" }
  $EP = (Get-ChildItem -LiteralPath $ROOT -Directory | Where-Object { $_.Name -like "* $Episode" } | Select-Object -First 1).FullName
  $File = Get-ChildItem (Join-Path $EP "out") -Filter "*final*.mp4" | Sort-Object LastWriteTime -Descending | Select-Object -First 1 -Expand FullName
}
if (-not (Test-Path $File)) { throw "Not found: $File" }

$dur = [double](& $FP -v error -show_entries format=duration -of csv=p=0 -- "$File" 2>$null)
function HMS($s){ [timespan]::FromSeconds([math]::Round($s)).ToString('mm\:ss') }
Write-Host "QC: $File  ($(HMS $dur))"

$fail = $false

# 1) silence gaps anywhere
$sil = & $FF -i $File -af "silencedetect=noise=-45dB:d=$Gap" -f null - 2>&1 | Select-String "silence_start|silence_duration"
if ($sil) {
  Write-Host "  ✗ SILENCE GAP(S) detected (>= ${Gap}s):" -ForegroundColor Red
  $sil | ForEach-Object { Write-Host "      $($_.ToString().Trim())" }
  $fail = $true
} else {
  Write-Host "  ✓ no silence gaps >= ${Gap}s"
}

# 2) tail loudness vs whole
function LUFS($ss,$len){
  $a = & $FF $(if($ss -gt 0){"-ss";"$ss"}) $(if($len){"-t";"$len"}) -i $File -af "ebur128" -f null - 2>&1
  $m = ($a | Select-String "I:\s+-?\d+(\.\d+)?\s+LUFS" | Select-Object -Last 1)
  if ($m) { [double](($m.ToString() -replace '.*I:\s+(-?\d+(\.\d+)?)\s+LUFS.*','$1') ) } else { -99 }
}
$whole = LUFS 0 $null
$tail  = LUFS ([math]::Max(0,$dur-60)) 60
$drop  = $tail - $whole
Write-Host ("  tail(last 60s)={0:N1} LUFS  whole={1:N1} LUFS  drop={2:N1} dB" -f $tail,$whole,$drop)
if ($drop -lt -6) {
  Write-Host "  ✗ tail is >6 dB quieter than the body — audio likely dies/fades early" -ForegroundColor Red
  $fail = $true
} else {
  Write-Host "  ✓ tail loudness consistent with body"
}

if ($fail) { Write-Host "`nRESULT: FAIL — do NOT publish; re-mix with scripts\mix_music_bed.ps1" -ForegroundColor Red; exit 1 }
else       { Write-Host "`nRESULT: PASS — audio covers the whole video" -ForegroundColor Green; exit 0 }
