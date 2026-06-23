<#
  Mix Episode 2 final — ep2_video.mp4 + VO + 5 music stems -> ep2_final.mp4
  Cue sheet:
    0:00   T1 hook     -18 dB  (fade in 2s)
    0:50   T2 Syd      -18 dB  (xfade 3s)
    2:25   T3a wall    -18 dB  (xfade 2.5s)
    4:00   T3b wall    -18 dB  (xfade 2s — second T3 clip)
    5:45   T5 pastiche -19 dB  (xfade 2s; lifts to -7 dB at 6:30 for 15s)
    7:25   T1 reprise  -17 dB  (xfade 2s)
    8:20   T4 build    -17->-10 dB  (Berlin peak -8 dB at 9:25)
   10:35   T1 outro    -15 dB  (fade out to silence)
  Usage:  powershell -ExecutionPolicy Bypass -File scripts\mix_audio_ep2.ps1
#>
$ErrorActionPreference = "Continue"

$ROOT = Split-Path $PSScriptRoot -Parent
$FF   = Join-Path $ROOT "node_modules\ffmpeg-static\ffmpeg.exe"
$EP   = (Get-ChildItem -LiteralPath $ROOT -Directory |
         Where-Object { $_.Name -like '* 2' -and (Test-Path (Join-Path $_.FullName 'images\higgsfield_images')) } |
         Select-Object -First 1).FullName
if (-not $EP) { throw "Episode 2 folder not found under $ROOT" }

$AUD   = Join-Path $EP "audio"
$BLD   = Join-Path $EP "build"
$OUT   = Join-Path $EP "out"
New-Item -ItemType Directory -Force $OUT | Out-Null

$FINAL = Join-Path $OUT "ep2_final.mp4"

foreach ($f in @("$BLD\ep2_video.mp4","$AUD\VO_ep2_full.mp3","$AUD\T1.mp3","$AUD\T2.mp3","$AUD\T3.mp3","$AUD\T4.mp3","$AUD\T5.mp3")) {
    if (-not (Test-Path $f)) { throw "Missing: $f" }
}

# dBFS -> linear: -7=0.447  -8=0.398  -10=0.316  -15=0.178  -17=0.141  -18=0.126  -19=0.112

# T5: bed -19 dB; feature lift to -7 dB at relative t=43-60s (= 6:28-7:05 on timeline)
$T5vol = "if(lt(t,43),0.112,if(lt(t,45),0.112+(0.335*(t-43)/2),if(lt(t,58),0.447,if(lt(t,60),0.447-(0.335*(t-58)/2),0.112))))"

# T4: ramp -17->-10 dB over first 20s; Berlin peak -8 dB at t=63-75s; fade out t=125-135s
$T4vol = "if(lt(t,20),0.141+(0.175*(t/20)),if(lt(t,63),0.316,if(lt(t,65),0.316+(0.082*((t-63)/2)),if(lt(t,75),0.398,if(lt(t,85),0.398-(0.082*((t-75)/10)),if(lt(t,125),0.316,if(lt(t,135),0.316*((135-t)/10),0.0001)))))))"

# Inputs: 0=video  1=VO  2=T1  3=T2  4=T3  5=T4  6=T5
$fc = @"
[2]asplit=3[t1a][t1b][t1c];
[4]asplit=2[t3a][t3b];
[t1a]atrim=duration=53,afade=t=in:st=0:d=2,afade=t=out:st=50:d=3,volume=0.126,apad=whole_dur=716.12[stem1];
[3]atrim=duration=97.5,afade=t=in:st=0:d=3,afade=t=out:st=95:d=2.5,volume=0.126,adelay=50000:all=1,apad=whole_dur=716.12[stem2];
[t3a]atrim=duration=97,afade=t=in:st=0:d=2.5,afade=t=out:st=95:d=2,volume=0.126,adelay=145000:all=1,apad=whole_dur=716.12[stem3];
[t3b]atrim=duration=107,afade=t=in:st=0:d=2,afade=t=out:st=105:d=2,volume=0.126,adelay=240000:all=1,apad=whole_dur=716.12[stem4];
[6]atrim=duration=102,afade=t=in:st=0:d=2,afade=t=out:st=100:d=2,volume='$T5vol':eval=frame,adelay=345000:all=1,apad=whole_dur=716.12[stem5];
[t1b]atrim=duration=57,afade=t=in:st=0:d=2,afade=t=out:st=55:d=2,volume=0.141,adelay=445000:all=1,apad=whole_dur=716.12[stem6];
[5]atrim=duration=137,afade=t=in:st=0:d=3,afade=t=out:st=133:d=4,volume='$T4vol':eval=frame,adelay=500000:all=1,apad=whole_dur=716.12[stem7];
[t1c]atrim=duration=82,afade=t=out:st=71:d=11,volume=0.178,adelay=635000:all=1,apad=whole_dur=716.12[stem8];
[stem1][stem2][stem3][stem4][stem5][stem6][stem7][stem8]amix=inputs=8:normalize=0[music];
[1][music]amix=inputs=2:normalize=0[aout]
"@

Write-Host "Mixing VO + 5 music stems ..."
& $FF -y `
  -i (Join-Path $BLD "ep2_video.mp4") `
  -i (Join-Path $AUD "VO_ep2_full.mp3") `
  -i (Join-Path $AUD "T1.mp3") `
  -i (Join-Path $AUD "T2.mp3") `
  -i (Join-Path $AUD "T3.mp3") `
  -i (Join-Path $AUD "T4.mp3") `
  -i (Join-Path $AUD "T5.mp3") `
  -filter_complex $fc `
  -map 0:v -map "[aout]" `
  -c:v copy -c:a aac -b:a 192k `
  -shortest $FINAL *>$null

if (Test-Path $FINAL) {
    $sz = [math]::Round((Get-Item $FINAL).Length / 1MB, 1)
    Write-Host "DONE  ->  $FINAL  ($sz MB)"
} else {
    Write-Host "FAILED -- re-run without *>`$null to see ffmpeg errors"
    exit 1
}
