<#
  Assemble Episode 3 — Sex Pistols / Never Mind the Bollocks
  15 stills (Ken Burns) + 9 animation clips -> build/ep3_video.mp4
  Duration follows Ep3_VO_full.mp3 = 10:36 (636s); end card gets +4s padding.

  Usage:
    pwsh scripts\assemble_ep3.ps1
    pwsh scripts\assemble_ep3.ps1 -Preview   # first 10 segments only, fast check
#>
param([switch]$Preview)
$ErrorActionPreference = "Continue"

$ROOT  = Split-Path $PSScriptRoot -Parent
$FF    = Join-Path $ROOT "node_modules\ffmpeg-static\ffmpeg.exe"
$EP    = (Get-ChildItem -LiteralPath $ROOT -Directory |
          Where-Object { $_.Name -like '* 3' -and (Test-Path (Join-Path $_.FullName 'images\higgsfield_images')) } |
          Select-Object -First 1).FullName
if (-not $EP) { throw "Episode 3 folder not found under $ROOT" }
$IMG   = Join-Path $EP "images\higgsfield_images"
$VID   = Join-Path $EP "videos"
$BUILD = Join-Path $EP "build"
$SEG   = "$BUILD\seg"
New-Item -ItemType Directory -Force $SEG | Out-Null
Get-ChildItem "$SEG\*.mp4" -ErrorAction SilentlyContinue | Remove-Item -Force

# VO = 10:36 = 636s; +4s for end card
$VO_END = 640.0

# Timecodes that have Kling animation clips (named MMSS_*.mp4 in videos/)
$clipTCs = @("0000","0021","0108","0148","0253","0447","0549","0828","0953")

# Ken Burns cycle
$kbCycle = @("IN","OUT","IN","PANR","IN","OUT","IN","PANL","OUT","IN","OUT","IN","PANR","IN","OUT")

function To-Sec($mmss) {
  $mm = [int]$mmss.Substring(0,2)
  $ss = [int]$mmss.Substring(2,2)
  return $mm * 60 + $ss
}

$timecodes = Get-ChildItem "$IMG\*.png" |
  Where-Object { $_.BaseName -match '^\d{4}$' } |
  Sort-Object Name |
  ForEach-Object { $_.BaseName }

$total = $timecodes.Count
Write-Host "Found $total frames. VO_END = $VO_END s"

$list      = "$BUILD\ep3_list.txt"
$listLines = New-Object System.Collections.Generic.List[string]
$kbIdx     = 0
$idx       = 0

foreach ($tc in $timecodes) {
  if ($Preview -and $idx -ge 10) { break }

  $tcSec = To-Sec $tc
  if ($idx -lt $total - 1) {
    $nextSec = To-Sec $timecodes[$idx + 1]
    $durSec  = $nextSec - $tcSec
  } else {
    $durSec = [math]::Ceiling($VO_END - $tcSec)
  }
  if ($durSec -lt 1) { $durSec = 1 }

  $N   = [int]($durSec * 30)
  $M   = [math]::Max($N - 1, 1)
  $out = "$SEG\" + $idx.ToString("000") + ".mp4"

  if ($clipTCs -contains $tc) {
    # Find clip file — named MMSS_*.mp4
    $src = Get-ChildItem "$VID\$tc*.mp4" | Select-Object -First 1
    if (-not $src) { Write-Host "WARNING: clip $tc not found, using still"; $clipTCs = $clipTCs | Where-Object { $_ -ne $tc } }
  }

  if (($clipTCs -contains $tc) -and $src) {
    $vf = "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,fps=30,format=yuv420p,tpad=stop_mode=clone:stop_duration=$([int]($durSec+2))"
    & $FF -y -i $src.FullName -an -vf $vf -frames:v $N -r 30 -c:v libx264 -preset veryfast -pix_fmt yuv420p $out 2>$null
    Write-Host ("[{0,2}/{1}] {2} CLIP  {3}s ({4}f) <- {5}" -f ($idx+1), $total, $tc, $durSec, $N, $src.Name)
  } else {
    $srcImg = "$IMG\$tc.png"
    $kb     = $kbCycle[$kbIdx % $kbCycle.Count]
    $kbIdx++
    switch ($kb) {
      "IN"   { $z="z=1+0.08*on/$M";                $x="x=iw/2-(iw/zoom/2)"; $y="y=ih/2-(ih/zoom/2)" }
      "OUT"  { $z="z=1.08-0.08*on/$M";              $x="x=iw/2-(iw/zoom/2)"; $y="y=ih/2-(ih/zoom/2)" }
      "PANR" { $z="z=1.06";                          $x="x=(iw-iw/zoom)*on/$M"; $y="y=ih/2-(ih/zoom/2)" }
      "PANL" { $z="z=1.06";                          $x="x=(iw-iw/zoom)*(1-on/$M)"; $y="y=ih/2-(ih/zoom/2)" }
    }
    $vf = "scale=3840:2160:force_original_aspect_ratio=increase,crop=3840:2160,zoompan=${z}:${x}:${y}:d=${N}:s=1920x1080:fps=30,format=yuv420p"
    & $FF -y -loop 1 -i $srcImg -vf $vf -frames:v $N -r 30 -c:v libx264 -preset veryfast -pix_fmt yuv420p $out 2>$null
    Write-Host ("[{0,2}/{1}] {2} {3,-4}  {4}s ({5}f)" -f ($idx+1), $total, $tc, $kb, $durSec, $N)
  }

  if (-not (Test-Path $out)) { throw "Segment failed: $tc -> $out" }
  $listLines.Add("file '" + ($out -replace '\\','/') + "'")
  $idx++
}

[System.IO.File]::WriteAllLines($list, $listLines, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "`nConcatenating $idx segments..."
$outFile = if ($Preview) { "$BUILD\ep3_preview.mp4" } else { "$BUILD\ep3_video.mp4" }
& $FF -y -f concat -safe 0 -i $list -c copy $outFile 2>$null
$sz = [math]::Round((Get-Item $outFile).Length/1MB,1)
Write-Host "DONE: $outFile ($sz MB)"
