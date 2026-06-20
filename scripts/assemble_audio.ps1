<#
  Build the final audio (music bed per cue sheet + ducked under VO + loudnorm)
  and mux it onto build/video.mp4 -> out/fleetwood_rumours_v1.mp4
  Video stream is copied (no re-encode).
#>
$ErrorActionPreference = "Stop"
$FF    = "G:\Claude Suno promt\node_modules\ffmpeg-static\ffmpeg.exe"
$AUD   = "G:\Claude Youtube Muz\audio"
$BUILD = "G:\Claude Youtube Muz\build"
$OUT   = "G:\Claude Youtube Muz\out"
New-Item -ItemType Directory -Force $OUT | Out-Null
$VO    = "G:\Ютуб 1.mp3"

if (-not (Test-Path "$BUILD\video.mp4")) { throw "build\video.mp4 not found — run assemble_video.ps1 first" }

# Inputs: 0 video, 1 VO, 2..9 music
$inputs = @(
  "$BUILD\video.mp4", $VO,
  "$AUD\T1.mp3", "$AUD\T2.mp3", "$AUD\T3.mp3", "$AUD\T1-build.mp3",
  "$AUD\T5.mp3", "$AUD\T1.mp3", "$AUD\T4.mp3", "$AUD\T1.mp3"
)

# Cue segments: inputIndex, startSec, durSec, fadeIn, fadeOut, volume
$cues = @(
  @{k=2; s=0.0;   d=33.0;  fi=1.5; fo=0.5; v=0.18},  # T1   hook
  @{k=3; s=35.0;  d=70.0;  fi=2.0; fo=2.0; v=0.18},  # T2   Bit1
  @{k=4; s=105.0; d=65.0;  fi=2.0; fo=2.0; v=0.18},  # T3   Bit2
  @{k=5; s=170.0; d=20.0;  fi=1.5; fo=1.0; v=0.18},  # T1-build Bit3
  @{k=6; s=190.0; d=53.0;  fi=1.5; fo=1.5; v=0.20},  # T5   Bit4
  @{k=7; s=243.0; d=23.0;  fi=1.5; fo=1.5; v=0.18},  # T1   Bit5 reprise
  @{k=8; s=266.0; d=32.0;  fi=1.5; fo=2.0; v=0.26},  # T4   climax (louder)
  @{k=9; s=298.0; d=23.83; fi=1.5; fo=4.0; v=0.18}   # T1   outro
)

# Build per-segment filter chains
$chains = @()
$labels = @()
$n = 0
foreach ($c in $cues) {
  $lbl = "m$n"
  $stOut = [math]::Round($c.d - $c.fo, 3)
  $delay = [int]([math]::Round($c.s * 1000))
  $chains += "[$($c.k):a]atrim=0:$($c.d),asetpts=PTS-STARTPTS,afade=t=in:st=0:d=$($c.fi),afade=t=out:st=${stOut}:d=$($c.fo),volume=$($c.v),adelay=${delay}|${delay}[$lbl]"
  $labels += "[$lbl]"
  $n++
}
$mixIns = ($labels -join "")
$chains += "${mixIns}amix=inputs=$($labels.Count):normalize=0[bed]"
$chains += "[1:a]asplit=2[vo1][vosc]"
$chains += "[bed][vosc]sidechaincompress=threshold=0.05:ratio=8:attack=20:release=250[duck]"
$chains += "[duck][vo1]amix=inputs=2:normalize=0,loudnorm=I=-14:TP=-1.5:LRA=11[aout]"
$fc = $chains -join ";"

# Assemble ffmpeg args
$args = @("-y")
foreach ($i in $inputs) { $args += @("-i", $i) }
$args += @("-filter_complex", $fc, "-map", "0:v", "-map", "[aout]",
           "-c:v", "copy", "-c:a", "aac", "-b:a", "256k", "-shortest",
           "$OUT\fleetwood_rumours_v1.mp4")

Write-Host "Muxing audio + video..."
& $FF @args 2>&1 | Select-Object -Last 4
$o = "$OUT\fleetwood_rumours_v1.mp4"
if (Test-Path $o) {
  $sz = [math]::Round((Get-Item $o).Length/1MB,1)
  Write-Host "DONE: out\fleetwood_rumours_v1.mp4 ($sz MB)"
} else { throw "mux failed" }
