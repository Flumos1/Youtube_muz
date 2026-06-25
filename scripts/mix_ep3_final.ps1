<#
  Mix Episode 3 final video: ep3_video.mp4 + VO + Suno music -> out/ep3_final.mp4
  Music design (VO-forward — music sits well under narration):
    VO           : boosted 1.4x — clearly dominant
    T1 tension   : full duration, -24 dB base (looped)
    T5 pastiche  : enters at 4:47 (287s), -19 dB — punk lift at Grundy scene
    T4 triumph   : enters at 7:30 (450s), -17 dB — climax at Thames/chart reveal
  Output loudness-normalized to -14 LUFS.

  Usage: pwsh scripts\mix_ep3_final.ps1
#>
$ErrorActionPreference = "Continue"

$ROOT  = Split-Path $PSScriptRoot -Parent
$FF    = Join-Path $ROOT "node_modules\ffmpeg-static\ffmpeg.exe"

$EP    = (Get-ChildItem -LiteralPath $ROOT -Directory |
          Where-Object { $_.Name -like '* 3' } |
          Select-Object -First 1).FullName
if (-not $EP) { throw "Episode 3 folder not found" }

$AUDIO = Join-Path $EP "audio"
$BUILD = Join-Path $EP "build"
$OUT   = Join-Path $EP "out"
New-Item -ItemType Directory -Force $OUT | Out-Null

$VID   = Join-Path $BUILD "ep3_video.mp4"
$VO    = Join-Path $AUDIO "Ep3_VO_full.mp3"
$T1    = Join-Path $AUDIO "Ep3_T1_tension.mp3"
$T4    = Join-Path $AUDIO "Ep3_T4_triumph.mp3"
$T5    = Join-Path $AUDIO "Ep3_T5_pastiche.mp3"
$FINAL = Join-Path $OUT   "ep3_final.mp4"

foreach ($f in $VID, $VO, $T1, $T4, $T5) {
  if (-not (Test-Path $f)) { throw "Missing: $f" }
}
Write-Host "Mixing Episode 3 final..."
Write-Host "  Video : $VID"
Write-Host "  VO    : $VO"
Write-Host "  VO    : 1.4x (forward)"
Write-Host "  T1    : $T1  (-24 dB, looped)"
Write-Host "  T5    : $T5  (-19 dB from 4:47)"
Write-Host "  T4    : $T4  (-17 dB from 7:30)"

# Volume levels (linear amplitude):
#  VO  = 1.400  (boosted, dominant)
# -17 dB= 0.141  (T4 climax)
# -19 dB= 0.112  (T5 Grundy lift)
# -24 dB= 0.063  (T1 base / general background)

# filter_complex:
#  [0] = ep3_video.mp4 (video only, no audio)
#  [1] = Ep3_VO_full.mp3
#  [2] = Ep3_T1_tension.mp3
#  [3] = Ep3_T5_pastiche.mp3  (delayed to 4:47 = 287s)
#  [4] = Ep3_T4_triumph.mp3   (delayed to 7:30 = 450s)

$fc = @'
[1:a]volume=1.4[vo];
[2:a]aloop=loop=-1:size=2147483647,atrim=0:640,asetpts=PTS-STARTPTS,volume=0.063[t1];
[3:a]adelay=287000|287000,volume=0.112[t5];
[4:a]adelay=450000|450000,volume=0.141[t4];
[t1][t5][t4]amix=inputs=3:duration=first:normalize=0[music];
[vo][music]amix=inputs=2:duration=first:normalize=0[premix];
[premix]loudnorm=I=-14:TP=-1.5:LRA=11[aout]
'@

& $FF -y `
  -i $VID `
  -i $VO `
  -i $T1 `
  -i $T5 `
  -i $T4 `
  -filter_complex $fc `
  -map "0:v" -map "[aout]" `
  -c:v copy `
  -c:a aac -b:a 192k -ar 44100 `
  -t 640 `
  $FINAL 2>$null

if (Test-Path $FINAL) {
  $sz  = [math]::Round((Get-Item $FINAL).Length / 1MB, 1)
  $dur = & $FF -i $FINAL 2>&1 | Select-String "Duration" | ForEach-Object { ($_ -split "Duration: ")[1].Split(",")[0].Trim() }
  Write-Host "`nDONE: $FINAL"
  Write-Host "  Size    : $sz MB"
  Write-Host "  Duration: $dur"
} else {
  throw "Output file not created: $FINAL"
}
