<#
  Build 3 vertical (1080x1920) Shorts from the pilot:
  VO sliced from Ютуб 1.mp3 at silence boundaries + blurred-fill visual +
  big hook caption + low music + bottom CTA. -> out/shorts/*.mp4
#>
$ErrorActionPreference = "Stop"
$FF  = "G:\Claude Suno promt\node_modules\ffmpeg-static\ffmpeg.exe"
$IMG = "G:\Claude Youtube Muz\images\higgsfield_images"
$AUD = "G:\Claude Youtube Muz\audio"
$VO  = "G:\Ютуб 1.mp3"
$OUT = "G:\Claude Youtube Muz\out\shorts"
New-Item -ItemType Directory -Force $OUT | Out-Null
$FONT = "C:/Windows/Fonts/impact.ttf" -replace ':','\:'

$shorts = @(
  @{name="short1_hook"; vin=0.0;    vout=19.6;  still="0145"; mus="T3"; lines=@("THEY MADE AN ALBUM","ABOUT LOVE -","WHILE EVERYONE BROKE UP")},
  @{name="short2_dog";  vin=229.6;  vout=240.0; still="0425"; mus="T3"; lines=@("SHE SAID THE SONG","WAS ABOUT HER DOG")},
  @{name="short3_40m";  vin=278.57; vout=294.38;still="0505"; mus="T4"; lines=@("THEY SOLD THEIR DIVORCE","40 MILLION TIMES")}
)

foreach ($s in $shorts) {
  $dur = [math]::Round($s.vout - $s.vin, 3)
  $N = [int]([math]::Round($dur * 30))
  $M = $N - 1

  # captions (top third)
  $caps = ""
  $y = 230
  foreach ($ln in $s.lines) {
    $caps += ",drawtext=fontfile='$FONT':text='$ln':x=(w-tw)/2:y=${y}:fontsize=70:fontcolor=white:borderw=6:bordercolor=black"
    $y += 100
  }
  $cta = ",drawbox=x=0:y=1690:w=1080:h=90:color=black@0.5:t=fill,drawtext=fontfile='$FONT':text='FULL STORY ON THE CHANNEL':x=(w-tw)/2:y=1710:fontsize=46:fontcolor=#FFD24A:borderw=3:bordercolor=black"

  $vfc = "[0:v]split=2[a][b];" +
    "[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=22,eq=brightness=-0.32[bg];" +
    "[b]scale=1080:-2[fg];" +
    "[bg][fg]overlay=(W-w)/2:(H-h)/2,zoompan=z=1+0.06*on/${M}:x=iw/2-(iw/zoom/2):y=ih/2-(ih/zoom/2):d=${N}:s=1080x1920:fps=30,format=yuv420p${caps}${cta}[v];" +
    "[1:a]loudnorm=I=-14:TP=-1.5:LRA=11[vo];" +
    "[2:a]volume=0.10,afade=t=out:st=$([math]::Round($dur-1,2)):d=1[mu];" +
    "[vo][mu]amix=inputs=2:normalize=0[a]"

  $segPath = "$OUT\$($s.name).mp4"
  & $FF -y -loop 1 -t $dur -i "$IMG\$($s.still).png" `
        -ss $s.vin -t $dur -i $VO `
        -ss 0 -t $dur -i "$AUD\$($s.mus).mp3" `
        -filter_complex $vfc -map "[v]" -map "[a]" `
        -r 30 -c:v libx264 -preset veryfast -pix_fmt yuv420p -c:a aac -b:a 256k -t $dur $segPath 2>$null
  if (-not (Test-Path $segPath)) { throw "short failed: $($s.name)" }
  $sz = [math]::Round((Get-Item $segPath).Length/1MB,1)
  Write-Host ("OK {0}.mp4  ({1}s, {2} MB)" -f $s.name, $dur, $sz)
}
Write-Host "DONE: out\shorts\"
