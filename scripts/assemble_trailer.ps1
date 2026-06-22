<#
  Build a ~34s Flumos channel trailer: montage of best clips/stills with
  text cards + a music bed (T4). No voiceover. -> out/flumos_trailer.mp4
#>
$ErrorActionPreference = "Stop"
$FF    = "G:\Claude Suno promt\node_modules\ffmpeg-static\ffmpeg.exe"
$IMG   = "G:\Claude Youtube Muz\images\higgsfield_images"
$VID   = "G:\Claude Youtube Muz\videos"
$AUD   = "G:\Claude Youtube Muz\audio"
$BUILD = "G:\Claude Youtube Muz\build\trailer"
$OUT   = "G:\Claude Youtube Muz\out"
New-Item -ItemType Directory -Force $BUILD,$OUT | Out-Null
Get-ChildItem "$BUILD\*.mp4" -ErrorAction SilentlyContinue | Remove-Item -Force
$FONT = "C:/Windows/Fonts/impact.ttf" -replace ':','\:'

function Caption($text, $y, $size, $color) {
  "drawtext=fontfile='$FONT':text='$text':x=(w-tw)/2:y=${y}:fontsize=${size}:fontcolor=${color}:borderw=4:bordercolor=black"
}
$bar = "drawbox=x=0:y=905:w=1920:h=150:color=black@0.45:t=fill"

# type,name,kb,frames,caption
$segs = @(
  @{t="clip"; n="0000"; f=150; cap="EVERY ALBUM HIDES A STORY"},
  @{t="still";n="0135"; kb="IN";  f=105; cap="THE BREAKUPS"},
  @{t="clip"; n="0435"; f=120; cap="THE BETRAYALS"},
  @{t="still";n="0250"; kb="OUT"; f=105; cap="THE DISASTERS"},
  @{t="clip"; n="0515"; f=150; cap="AND THE MASTERPIECES THAT SURVIVED THEM"},
  @{t="still";n="0510"; kb="IN";  f=120; cap="REAL STORIES.  CINEMATIC.  NO CLICKBAIT."},
  @{t="logo"; f=120},
  @{t="clip"; n="0535"; f=150; cap="SUB"}
)

$list = "$BUILD\list.txt"; "" | Out-File -Encoding ascii $list
$i = 0
foreach ($s in $segs) {
  $segPath = "$BUILD\{0:D2}.mp4" -f $i
  $N = $s.f; $M = $N - 1
  if ($s.t -eq "logo") {
    $vf = "$(Caption 'FLUMOS' 430 150 'white'),$(Caption 'THE DARKEST STORIES IN MUSIC' 620 58 '#FFD24A')"
    & $FF -y -f lavfi -i "color=c=black:s=1920x1080:r=30" -vf $vf -frames:v $N -c:v libx264 -preset veryfast -pix_fmt yuv420p $segPath 2>$null
  }
  elseif ($s.t -eq "clip") {
    $src = "$VID\$($s.n).mp4"
    if ($s.cap -eq "SUB") {
      $cap = "$bar,$(Caption 'NEW STORY EVERY WEEK' 930 52 'white'),$(Caption 'SUBSCRIBE' 990 60 '#FFD24A')"
      # two lines need more room -> raise bar
      $cap = "drawbox=x=0:y=880:w=1920:h=180:color=black@0.5:t=fill,$(Caption 'NEW STORY EVERY WEEK' 905 50 'white'),$(Caption 'SUBSCRIBE' 970 64 '#FFD24A')"
    } else {
      $cap = "$bar,$(Caption $s.cap 945 60 'white')"
    }
    $vf = "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,fps=30,format=yuv420p,tpad=stop_mode=clone:stop_duration=8,$cap"
    & $FF -y -i $src -an -vf $vf -frames:v $N -r 30 -c:v libx264 -preset veryfast -pix_fmt yuv420p $segPath 2>$null
  }
  else {
    $src = "$IMG\$($s.n).png"
    if ($s.kb -eq "IN") { $z="z=1+0.12*on/$M" } else { $z="z=1.12-0.12*on/$M" }
    $cap = "$bar,$(Caption $s.cap 945 64 'white')"
    $vf = "scale=3840:2160:force_original_aspect_ratio=increase,crop=3840:2160,zoompan=${z}:x=iw/2-(iw/zoom/2):y=ih/2-(ih/zoom/2):d=${N}:s=1920x1080:fps=30,format=yuv420p,$cap"
    & $FF -y -loop 1 -i $src -vf $vf -frames:v $N -r 30 -c:v libx264 -preset veryfast -pix_fmt yuv420p $segPath 2>$null
  }
  if (-not (Test-Path $segPath)) { throw "trailer seg failed: $($s.t) $($s.n)" }
  "file '$($segPath -replace '\\','/')'" | Out-File -Encoding ascii -Append $list
  Write-Host ("seg {0} {1} {2} ({3}f)" -f $i, $s.t, $s.n, $N)
  $i++
}

& $FF -y -f concat -safe 0 -i $list -c copy "$BUILD\silent.mp4" 2>$null
# total ≈ 1020 frames = 34s. Music: T4 trimmed + faded.
& $FF -y -i "$BUILD\silent.mp4" -i "$AUD\T4.mp3" `
  -filter_complex "[1:a]atrim=0:34,afade=t=in:st=0:d=1.5,afade=t=out:st=30:d=4,volume=0.7,loudnorm=I=-14:TP=-1.5:LRA=11[a]" `
  -map 0:v -map "[a]" -c:v copy -c:a aac -b:a 256k -shortest "$OUT\flumos_trailer.mp4" 2>$null
$sz = [math]::Round((Get-Item "$OUT\flumos_trailer.mp4").Length/1MB,1)
Write-Host "DONE: out\flumos_trailer.mp4 ($sz MB)"
