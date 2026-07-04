<#
  Ep5 Phil Spector — silent video assembler (Ken Burns zoompan)
  117 PNGs × 8s each → ~936s  (VO = 15:46 = 946s)
  Outputs: Эпизод 5/out/ep5_video.mp4 (silent, 1080p)
  Then mux with VO + music bed → ep5_final.mp4
#>
$ErrorActionPreference = "Stop"

$ffmpeg  = "D:\Claude Youtube Muz\node_modules\ffmpeg-static\ffmpeg.exe"
$imgDir  = "D:\Claude Youtube Muz\Эпизод 5\images\higgsfield_images"
$audioDir= "D:\Claude Youtube Muz\Эпизод 5\audio"
$outDir  = "D:\Claude Youtube Muz\Эпизод 5\out"
$buildDir= "D:\Claude Youtube Muz\Эпизод 5\build"
New-Item -ItemType Directory -Force $outDir  | Out-Null
New-Item -ItemType Directory -Force $buildDir | Out-Null

$imgs = Get-ChildItem $imgDir -Filter "*.png" | Sort-Object Name
Write-Host "Images: $($imgs.Count)"

$dur = 8          # seconds per image
$fps = 25
$w   = 1920
$h   = 1080

# --- build concat list ---
$listFile = "$buildDir\imglist.txt"
$imgs | ForEach-Object { "file '$($_.FullName)'`nduration $dur" } | Out-File $listFile -Encoding utf8
# last entry needs explicit out point
"file '$($imgs[-1].FullName)'" | Add-Content $listFile

# Ken Burns zoompan filter (alternates zoom-in / zoom-out)
# d=fps*dur frames per image, s=output size
$zp  = "zoompan=z='if(eq(mod(on,$($fps*$dur)),0),if(eq(mod(trunc(on/$($fps*$dur)),2),0),1.04,1.08),z+0.0008)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=$($fps*$dur):s=${w}x${h}:fps=$fps"

$videoOut = "$outDir\ep5_video.mp4"
Write-Host "Encoding silent video..."
& $ffmpeg -y -f concat -safe 0 -i $listFile `
  -vf $zp `
  -c:v libx264 -preset fast -crf 18 -pix_fmt yuv420p `
  -t 946 `
  $videoOut

Write-Host "Silent video done: $videoOut"

# --- Music cue sheet (v1 tracks) ---
# T1 tension:      0:00-3:30  (210s)
# T2 warm:         3:30-7:00  (210s)
# T3 melancholy:   7:00-10:30 (210s)
# T4 bittersweet: 10:30-14:30 (240s)
# T1 again:       14:30-15:46 (76s) — outro reuse tension
$t1 = "$audioDir\Ep5_T1_v1.mp3"
$t2 = "$audioDir\Ep5_T2_v1.mp3"
$t3 = "$audioDir\Ep5_T3_v1.mp3"
$t4 = "$audioDir\Ep5_T4_v1.mp3"

# Build music mix: concat 5 segments
# T1(0-210) | T2(210-420) | T3(420-630) | T4(630-870) | T1(870-946)
$musicFilter = @"
[0:a]atrim=0:210,asetpts=PTS-STARTPTS[a1];
[1:a]atrim=0:210,asetpts=PTS-STARTPTS[a2];
[2:a]atrim=0:210,asetpts=PTS-STARTPTS[a3];
[3:a]atrim=0:240,asetpts=PTS-STARTPTS[a4];
[0:a]atrim=0:76,asetpts=PTS-STARTPTS[a5];
[a1][a2][a3][a4][a5]concat=n=5:v=0:a=1[music_raw];
[music_raw]volume=0.18,afade=t=in:st=0:d=2,afade=t=out:st=940:d=6[music]
"@

$voFile = "$audioDir\Ep5_VO_full.mp3"
$finalOut = "$outDir\ep5_final.mp4"

Write-Host "Muxing final video with VO + music..."
& $ffmpeg -y `
  -i $t1 -i $t2 -i $t3 -i $t4 `
  -i $voFile `
  -i $videoOut `
  -filter_complex "$musicFilter;[4:a]volume=1.0[vo];[music][vo]amix=inputs=2:duration=first:weights=1 1[aout];[aout]loudnorm=I=-14:TP=-1.5:LRA=11[aout_norm]" `
  -map "5:v" -map "[aout_norm]" `
  -c:v copy -c:a aac -b:a 192k `
  -t 946 `
  $finalOut

Write-Host "DONE: $finalOut"
