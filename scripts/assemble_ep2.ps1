<#
  Assemble Episode 2 — Pink Floyd / The Wall
  92 stills (Ken Burns) + 9 animation clips -> build/ep2_video.mp4
  Duration follows VO_ep2_full.mp3 = 11:56 (716.12s)

  Usage:
    pwsh scripts\assemble_ep2.ps1
    pwsh scripts\assemble_ep2.ps1 -Preview   # first 10 segments only, fast check
#>
param([switch]$Preview)
# NOTE: keep this "Continue" — under Windows PowerShell 5.1, "Stop" turns ffmpeg's
# stderr banner into a terminating error. Critical failures are caught explicitly
# by the Test-Path guard after each segment below.
$ErrorActionPreference = "Continue"

# Resolve paths relative to project root (this script lives in <root>\scripts).
# Episode folder name is Cyrillic ("Эпизод 2"); match it via wildcard so this
# .ps1 stays ASCII-only and is immune to console-codepage mangling.
$ROOT   = Split-Path $PSScriptRoot -Parent
$FF     = Join-Path $ROOT "node_modules\ffmpeg-static\ffmpeg.exe"
$EP     = (Get-ChildItem -LiteralPath $ROOT -Directory |
           Where-Object { $_.Name -like '* 2' -and (Test-Path (Join-Path $_.FullName 'images\higgsfield_images')) } |
           Select-Object -First 1).FullName
if (-not $EP) { throw "Episode 2 folder (with images\higgsfield_images) not found under $ROOT" }
$IMG    = Join-Path $EP "images\higgsfield_images"
$VID    = Join-Path $EP "videos"
$BUILD  = Join-Path $EP "build"
$SEG    = "$BUILD\seg"
New-Item -ItemType Directory -Force $SEG | Out-Null
Get-ChildItem "$SEG\*.mp4" -ErrorAction SilentlyContinue | Remove-Item -Force

# VO duration in seconds
$VO_END = 716.12

# Frames that have animation clips (MMSS names)
$clips = @("0024","0157","0245","0421","0514","0720","0942","1036","1116")

# Ken Burns cycle: IN zoom-in, OUT zoom-out, PANR pan right, PANL pan left
$kbCycle = @("IN","OUT","IN","PANR","IN","OUT","IN","PANL","OUT","IN","OUT","IN")

# Convert MMSS string to seconds
function To-Sec($mmss) {
  $mm = [int]$mmss.Substring(0,2)
  $ss = [int]$mmss.Substring(2,2)
  return $mm * 60 + $ss
}

# Get sorted list of all image timecodes
$timecodes = Get-ChildItem "$IMG\*.png" |
  Where-Object { $_.BaseName -match '^\d{4}$' } |
  Sort-Object Name |
  ForEach-Object { $_.BaseName }

$total = $timecodes.Count
Write-Host "Found $total frames. VO = $VO_END s"

$list = "$BUILD\ep2_list.txt"
$listLines = New-Object System.Collections.Generic.List[string]

$kbIdx = 0
$idx   = 0

foreach ($tc in $timecodes) {
  if ($Preview -and $idx -ge 10) { break }

  # Duration = next timecode - this timecode (last frame fills to VO end)
  $tcSec = To-Sec $tc
  if ($idx -lt $total - 1) {
    $nextSec = To-Sec $timecodes[$idx + 1]
    $durSec  = $nextSec - $tcSec
  } else {
    $durSec = [math]::Ceiling($VO_END - $tcSec)
  }

  $N   = [int]($durSec * 30)   # frame count at 30fps
  $M   = $N - 1
  $out = "$SEG\{0:D3}.mp4" -f $idx

  if ($clips -contains $tc) {
    # Animation clip — scale to 1080p, pad/trim to exact length
    $src = "$VID\$tc.mp4"
    $vf  = "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,fps=30,format=yuv420p,tpad=stop_mode=clone:stop_duration=$([int]($durSec+2))"
    & $FF -y -i $src -an -vf $vf -frames:v $N -r 30 -c:v libx264 -preset veryfast -pix_fmt yuv420p $out 2>$null
    Write-Host ("[{0,2}/{1}] {2} CLIP  {3}s ({4}f)" -f ($idx+1), $total, $tc, $durSec, $N)
  } else {
    # Still image with Ken Burns
    $src = "$IMG\$tc.png"
    $kb  = $kbCycle[$kbIdx % $kbCycle.Count]
    $kbIdx++
    switch ($kb) {
      "IN"   { $z="z=1+0.08*on/$M";                $x="x=iw/2-(iw/zoom/2)"; $y="y=ih/2-(ih/zoom/2)" }
      "OUT"  { $z="z=1.08-0.08*on/$M";              $x="x=iw/2-(iw/zoom/2)"; $y="y=ih/2-(ih/zoom/2)" }
      "PANR" { $z="z=1.06";                          $x="x=(iw-iw/zoom)*on/$M"; $y="y=ih/2-(ih/zoom/2)" }
      "PANL" { $z="z=1.06";                          $x="x=(iw-iw/zoom)*(1-on/$M)"; $y="y=ih/2-(ih/zoom/2)" }
    }
    $vf = "scale=3840:2160:force_original_aspect_ratio=increase,crop=3840:2160,zoompan=${z}:${x}:${y}:d=${N}:s=1920x1080:fps=30,format=yuv420p"
    & $FF -y -loop 1 -i $src -vf $vf -frames:v $N -r 30 -c:v libx264 -preset veryfast -pix_fmt yuv420p $out 2>$null
    Write-Host ("[{0,2}/{1}] {2} {3,-4}  {4}s ({5}f)" -f ($idx+1), $total, $tc, $kb, $durSec, $N)
  }

  if (-not (Test-Path $out)) { throw "Segment failed: $tc" }
  $listLines.Add("file '$($out -replace '\\','/')'")
  $idx++
}

# Write concat list as UTF-8 without BOM — paths contain Cyrillic ("Эпизод 2"),
# so ascii would corrupt them and ffmpeg concat would not find the segments.
[System.IO.File]::WriteAllLines($list, $listLines, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "`nConcatenating $idx segments..."
$outFile = if ($Preview) { "$BUILD\ep2_preview.mp4" } else { "$BUILD\ep2_video.mp4" }
& $FF -y -f concat -safe 0 -i $list -c copy $outFile 2>$null
$sz = [math]::Round((Get-Item $outFile).Length/1MB,1)
Write-Host "DONE: $outFile ($sz MB)"
