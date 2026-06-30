<#
  mix_music_bed.ps1 — GAPLESS, FULL-LENGTH music bed for a finished episode.

  WHY (user rule 2026-06-30): "музыки должно хватать на ВСЁ видео — брать ВСЕ генерации Suno".
  Past bugs: cue-sheet gaps left stretches with no music; `amix=duration=first` tied audio length
  to the VO so the tail (video > VO) was silent. This script removes both:
    - concatenates ALL Suno mp3s in the episode's audio/ (every generation, both variants),
    - loops that concat to >= video length and trims to EXACT video length,
    - ducks it under the VO across the WHOLE timeline (sidechaincompress),
    - ends on VIDEO duration (-t), never on the VO,
    - loudnorm I=-14.

  It takes the VIDEO stream from the existing final (-c:v copy, no re-encode) and rebuilds only audio
  from the separate VO mp3 + music, writing a NEW file so the original is untouched until you verify.

  Usage:
    pwsh scripts\mix_music_bed.ps1 -Episode 3
    pwsh scripts\mix_music_bed.ps1 -Episode 4 -BedVol 0.20
    pwsh scripts\mix_music_bed.ps1 -Episode 2 -VideoFile "...\out\ep2_final.mp4" -VO "...\audio\Ep2_VO_full.mp3"
#>
param(
  [Parameter(Mandatory)][int]$Episode,
  [string]$VideoFile = "",      # source for the video stream (default: out/ep{N}_final.mp4)
  [string]$VO        = "",      # voiceover mp3 (auto-detected if omitted)
  [string[]]$Music   = @(),     # explicit music list (default: every non-VO mp3 in audio/)
  [double]$BedVol    = 0.11,    # base music level AFTER dynaudnorm evens tracks (lower = quieter bed)
  [double]$VoGain    = 1.35,    # VO boost (kept dominant)
  [double]$OutroFade = 8,       # seconds of fade-out at the very end (gentle tail)
  [string]$OutFile   = ""       # default: out/ep{N}_final_musicfix.mp4
)
$ErrorActionPreference = "Stop"
$ROOT = Split-Path $PSScriptRoot -Parent

# ── resolve ffmpeg/ffprobe (glob the C:\Temp build first — it has ffprobe; node_modules has none) ──
$bin = Get-ChildItem "C:\Temp\ffmpeg_dl\ffmpeg-*essentials_build\bin" -Directory -ErrorAction SilentlyContinue |
         Sort-Object FullName -Descending | Select-Object -First 1 -Expand FullName
$FF = if ($bin) { Join-Path $bin "ffmpeg.exe" } else { Join-Path $ROOT "node_modules\ffmpeg-static\ffmpeg.exe" }
$FP = if ($bin) { Join-Path $bin "ffprobe.exe" } else { (Get-Command ffprobe -ErrorAction SilentlyContinue).Source }
if (-not (Test-Path $FF)) { throw "ffmpeg not found" }
if (-not $FP -or -not (Test-Path $FP)) { throw "ffprobe not found (install full ffmpeg build)" }

# ── resolve episode paths ──
$EP = (Get-ChildItem -LiteralPath $ROOT -Directory | Where-Object { $_.Name -like "* $Episode" } | Select-Object -First 1).FullName
if (-not $EP) { throw "Episode $Episode folder not found" }
$AUD = Join-Path $EP "audio"
$OUT = Join-Path $EP "out"

if (-not $VideoFile) { $VideoFile = Join-Path $OUT "ep${Episode}_final.mp4" }
if (-not (Test-Path $VideoFile)) { throw "Video file not found: $VideoFile" }
if (-not $VO) {
  $VO = (Get-ChildItem $AUD -Filter "*.mp3" | Where-Object { $_.Name -match 'VO|ElevenLabs|voice' } |
         Sort-Object Length -Descending | Select-Object -First 1).FullName
}
if (-not $VO -or -not (Test-Path $VO)) { throw "VO mp3 not found in $AUD (pass -VO)" }
if (-not $Music -or $Music.Count -eq 0) {
  $Music = @(Get-ChildItem $AUD -Filter "*.mp3" | Where-Object { $_.Name -notmatch 'VO|ElevenLabs|voice' } |
             Sort-Object Name | Select-Object -Expand FullName)
}
if ($Music.Count -eq 0) { throw "No music mp3s found in $AUD" }
if (-not $OutFile) { $OutFile = Join-Path $OUT "ep${Episode}_final_musicfix.mp4" }

function Dur($f){ [double](& $FP -v error -show_entries format=duration -of csv=p=0 -- "$f" 2>$null) }
$VDUR = [math]::Round((Dur $VideoFile), 2)
$mTot = ($Music | ForEach-Object { Dur $_ } | Measure-Object -Sum).Sum

Write-Host "Episode $Episode"
Write-Host "  Video : $VideoFile  ($([timespan]::FromSeconds($VDUR).ToString('mm\:ss')))"
Write-Host "  VO    : $VO"
Write-Host "  Music : $($Music.Count) tracks, total $([timespan]::FromSeconds([math]::Round($mTot)).ToString('mm\:ss')) (looped/trimmed to video length)"
Write-Host "  Out   : $OutFile"

# ── build filter_complex ──
# Inputs: 0 = video(+its old audio, ignored), 1 = VO, 2..(N+1) = music
$labels = @()
$chains = @()
for ($i = 0; $i -lt $Music.Count; $i++) {
  $idx = $i + 2
  $chains += "[$idx`:a]aresample=44100[m$i]"
  $labels += "[m$i]"
}
$fadeOut = [math]::Max(0, $VDUR - $OutroFade)
$chains += "$($labels -join '')concat=n=$($Music.Count):v=0:a=1[cat]"
# dynaudnorm evens every track to a similar level so hot tracks (e.g. rock guitar) don't spike above the rest;
# THEN volume scales the whole bed down. afade out is long+gentle so the music-only tail isn't abrupt/loud.
$chains += "[cat]aloop=loop=-1:size=2147483647,atrim=0:$VDUR,asetpts=N/SR/TB,dynaudnorm=f=250:g=15:p=0.55:m=8,afade=t=in:st=0:d=2,afade=t=out:st=$fadeOut`:d=$OutroFade,volume=$BedVol[bed]"
$chains += "[1:a]aresample=44100,volume=$VoGain,asetpts=N/SR/TB[vo]"
$chains += "[vo]asplit=2[vo1][vosc]"
# stronger duck: music drops hard whenever VO is present so narration always cuts through
$chains += "[bed][vosc]sidechaincompress=threshold=0.03:ratio=12:attack=15:release=300[duck]"
# duration=first => follows [duck] (= full video length), so audio never stops at VO end
$chains += "[duck][vo1]amix=inputs=2:normalize=0:duration=first,loudnorm=I=-14:TP=-1.5:LRA=11[aout]"
$fc = ($chains -join ";")

$args = @("-y","-i",$VideoFile,"-i",$VO)
foreach ($m in $Music) { $args += @("-i",$m) }
$args += @("-filter_complex",$fc,"-map","0:v","-map","[aout]","-c:v","copy","-c:a","aac","-b:a","192k","-ar","44100","-t","$VDUR",$OutFile)

& $FF @args 2>$null
if (-not (Test-Path $OutFile)) { throw "Output not created: $OutFile" }

# ── verify: no trailing silence in last 25s ──
$tailStart = [math]::Max(0, $VDUR - 25)
$sil = & $FF -ss $tailStart -i $OutFile -af "silencedetect=noise=-50dB:d=2" -f null - 2>&1 | Select-String "silence_start"
$mb = [math]::Round((Get-Item $OutFile).Length/1MB,1)
Write-Host "`nDONE: $OutFile ($mb MB, $([timespan]::FromSeconds($VDUR).ToString('mm\:ss')))"
if ($sil) { Write-Host "  ⚠ trailing silence still detected:`n   $sil" }
else      { Write-Host "  ✓ music+VO play continuously to the end (no trailing silence)" }
