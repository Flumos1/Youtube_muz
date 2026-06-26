<#
  Assemble Episode 4 — Napster
  71 stills (Ken Burns) + 16 animation clips -> build/ep4_video.mp4 (silent)
  then mux 5 Suno tracks (cue sheet, ducked under VO, loudnorm) -> out/ep4_final.mp4
  Duration follows Ep4_VO_full.mp3 = 10:45 (645s); end card gets +4s padding.

  Usage:
    pwsh scripts\assemble_ep4.ps1
    pwsh scripts\assemble_ep4.ps1 -Preview     # first 10 segments only, fast video check
    pwsh scripts\assemble_ep4.ps1 -AudioOnly   # skip video build, just (re)mux audio
#>
param([switch]$Preview, [switch]$AudioOnly)
$ErrorActionPreference = "Continue"

$ROOT  = Split-Path $PSScriptRoot -Parent
$FF    = Join-Path $ROOT "node_modules\ffmpeg-static\ffmpeg.exe"
$EP    = (Get-ChildItem -LiteralPath $ROOT -Directory |
          Where-Object { $_.Name -like '* 4' -and (Test-Path (Join-Path $_.FullName 'images\higgsfield_images')) } |
          Select-Object -First 1).FullName
if (-not $EP) { throw "Episode 4 folder not found under $ROOT" }
$IMG   = Join-Path $EP "images\higgsfield_images"
$VID   = Join-Path $EP "videos"
$AUD   = Join-Path $EP "audio"
$BUILD = Join-Path $EP "build"
$OUT   = Join-Path $EP "out"
$SEG   = "$BUILD\seg"
New-Item -ItemType Directory -Force $SEG, $OUT | Out-Null

$VO_END = 649.0   # 10:45 VO + 4s end card
$VO     = "$AUD\Ep4_VO_full.mp3"

# Timecodes that have Kling animation clips (videos/MMSS.mp4)
$clipTCs = @("0000","0016","0032","0046","0054","0149","0224","0343",
             "0415","0452","0612","0737","0938","1002","1016","1044")
$kbCycle = @("IN","OUT","IN","PANR","IN","OUT","IN","PANL","OUT","IN","OUT","IN","PANR","IN","OUT")

function To-Sec($mmss) { ([int]$mmss.Substring(0,2))*60 + [int]$mmss.Substring(2,2) }

# ---------------------------------------------------------------- VIDEO STAGE
if (-not $AudioOnly) {
  Get-ChildItem "$SEG\*.mp4" -ErrorAction SilentlyContinue | Remove-Item -Force
  $timecodes = Get-ChildItem "$IMG\*.png" | Where-Object { $_.BaseName -match '^\d{4}$' } |
               Sort-Object Name | ForEach-Object { $_.BaseName }
  $total = $timecodes.Count
  Write-Host "Found $total frames. VO_END = $VO_END s"

  $list = "$BUILD\ep4_list.txt"
  $listLines = New-Object System.Collections.Generic.List[string]
  $kbIdx = 0; $idx = 0
  foreach ($tc in $timecodes) {
    if ($Preview -and $idx -ge 10) { break }
    $tcSec = To-Sec $tc
    if ($idx -lt $total - 1) { $durSec = (To-Sec $timecodes[$idx+1]) - $tcSec }
    else                     { $durSec = [math]::Ceiling($VO_END - $tcSec) }
    if ($durSec -lt 1) { $durSec = 1 }
    $N = [int]($durSec * 30); $M = [math]::Max($N - 1, 1)
    $segOut = "$SEG\" + $idx.ToString("000") + ".mp4"

    $src = $null
    if ($clipTCs -contains $tc) { $src = Get-ChildItem "$VID\$tc.mp4" -ErrorAction SilentlyContinue | Select-Object -First 1 }

    if ($src) {
      # clip: scale/crop to 1080p, drop Kling audio, freeze last frame to fill the slot
      $vf = "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,fps=30,format=yuv420p,tpad=stop_mode=clone:stop_duration=$([int]($durSec+2))"
      & $FF -y -i $src.FullName -an -vf $vf -frames:v $N -r 30 -c:v libx264 -preset veryfast -pix_fmt yuv420p $segOut 2>$null
      Write-Host ("[{0,2}/{1}] {2} CLIP  {3}s" -f ($idx+1), $total, $tc, $durSec)
    } else {
      $kb = $kbCycle[$kbIdx % $kbCycle.Count]; $kbIdx++
      switch ($kb) {
        "IN"   { $z="z=1+0.08*on/$M";       $x="x=iw/2-(iw/zoom/2)";       $y="y=ih/2-(ih/zoom/2)" }
        "OUT"  { $z="z=1.08-0.08*on/$M";     $x="x=iw/2-(iw/zoom/2)";       $y="y=ih/2-(ih/zoom/2)" }
        "PANR" { $z="z=1.06";                $x="x=(iw-iw/zoom)*on/$M";     $y="y=ih/2-(ih/zoom/2)" }
        "PANL" { $z="z=1.06";                $x="x=(iw-iw/zoom)*(1-on/$M)"; $y="y=ih/2-(ih/zoom/2)" }
      }
      $vf = "scale=3840:2160:force_original_aspect_ratio=increase,crop=3840:2160,zoompan=${z}:${x}:${y}:d=${N}:s=1920x1080:fps=30,format=yuv420p"
      & $FF -y -loop 1 -i "$IMG\$tc.png" -vf $vf -frames:v $N -r 30 -c:v libx264 -preset veryfast -pix_fmt yuv420p $segOut 2>$null
      Write-Host ("[{0,2}/{1}] {2} {3,-4}  {4}s" -f ($idx+1), $total, $tc, $kb, $durSec)
    }
    if (-not (Test-Path $segOut)) { throw "Segment failed: $tc" }
    $listLines.Add("file '" + ($segOut -replace '\\','/') + "'")
    $idx++
  }
  [System.IO.File]::WriteAllLines($list, $listLines, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "`nConcatenating $idx segments..."
  $vOut = if ($Preview) { "$BUILD\ep4_preview.mp4" } else { "$BUILD\ep4_video.mp4" }
  & $FF -y -f concat -safe 0 -i $list -c copy $vOut 2>$null
  Write-Host "video: $vOut ($([math]::Round((Get-Item $vOut).Length/1MB,1)) MB)"
  if ($Preview) { return }
}

# ---------------------------------------------------------------- AUDIO STAGE
$videoIn = "$BUILD\ep4_video.mp4"
if (-not (Test-Path $videoIn)) { throw "build\ep4_video.mp4 not found — run without -AudioOnly first" }

# Inputs: 0 video, 1 VO, 2..9 music (T1 reused 3x, T2 2x -> separate inputs)
$inputs = @($videoIn, $VO,
  "$AUD\Ep4_T1.mp3", "$AUD\Ep4_T2.mp3", "$AUD\Ep4_T3.mp3", "$AUD\Ep4_T5.mp3",
  "$AUD\Ep4_T1.mp3", "$AUD\Ep4_T2.mp3", "$AUD\Ep4_T4.mp3", "$AUD\Ep4_T1.mp3")

# Cue sheet (real silencedetect anchors): inputIndex, startSec, durSec, fadeIn, fadeOut, volume
$cues = @(
  @{k=2; s=0.0;   d=54.0;  fi=1.5; fo=2.0; v=0.18},  # T1 hook
  @{k=3; s=54.0;  d=82.0;  fi=2.0; fo=2.0; v=0.18},  # T2 dorm (Bit1)
  @{k=4; s=136.0; d=216.0; fi=2.0; fo=3.0; v=0.17},  # T3 machine (panic+shutdown)
  @{k=5; s=223.0; d=15.0;  fi=1.0; fo=2.0; v=0.30},  # T5 Metallica raised (3:43)
  @{k=6; s=372.0; d=47.0;  fi=2.0; fo=2.0; v=0.10},  # T1 breath whisper ($2B memo)
  @{k=7; s=419.0; d=98.0;  fi=2.0; fo=2.0; v=0.18},  # T2 return (Jobs/iTunes)
  @{k=8; s=517.0; d=75.0;  fi=2.0; fo=3.0; v=0.24},  # T4 climax (peak ~9:38)
  @{k=9; s=592.0; d=57.0;  fi=2.0; fo=5.0; v=0.18}   # T1 outro
)

$chains = @(); $labels = @(); $n = 0
foreach ($c in $cues) {
  $lbl = "m$n"; $stOut = [math]::Round($c.d - $c.fo, 3); $delay = [int]([math]::Round($c.s*1000))
  $chains += "[$($c.k):a]atrim=0:$($c.d),asetpts=PTS-STARTPTS,afade=t=in:st=0:d=$($c.fi),afade=t=out:st=${stOut}:d=$($c.fo),volume=$($c.v),adelay=${delay}|${delay}[$lbl]"
  $labels += "[$lbl]"; $n++
}
$chains += (($labels -join "") + "amix=inputs=$($labels.Count):normalize=0[bed]")
$chains += "[1:a]asplit=2[vo1][vosc]"
$chains += "[bed][vosc]sidechaincompress=threshold=0.05:ratio=8:attack=20:release=250[duck]"
$chains += "[duck][vo1]amix=inputs=2:normalize=0,loudnorm=I=-14:TP=-1.5:LRA=11[aout]"
$fc = $chains -join ";"

$ffargs = @("-y")
foreach ($i in $inputs) { $ffargs += @("-i", $i) }
$ffargs += @("-filter_complex", $fc, "-map", "0:v", "-map", "[aout]",
             "-c:v", "copy", "-c:a", "aac", "-b:a", "256k", "-shortest", "$OUT\ep4_final.mp4")
Write-Host "Muxing audio + video..."
& $FF @ffargs 2>&1 | Select-Object -Last 3
$o = "$OUT\ep4_final.mp4"
if (Test-Path $o) { Write-Host "DONE: $o ($([math]::Round((Get-Item $o).Length/1MB,1)) MB)" } else { throw "mux failed" }
