<#
  Build the silent video track for the Fleetwood Mac pilot:
  68 segments (53 stills with Ken Burns + 15 Kling clips) -> build/video.mp4
  Total = 321.83s (matches the 5:21 voiceover). 1080p / 30fps.
#>
$ErrorActionPreference = "Stop"
$FF    = "G:\Claude Suno promt\node_modules\ffmpeg-static\ffmpeg.exe"
$IMG   = "G:\Claude Youtube Muz\images\higgsfield_images"
$VID   = "G:\Claude Youtube Muz\videos"
$BUILD = "G:\Claude Youtube Muz\build"
$SEG   = "$BUILD\seg"
New-Item -ItemType Directory -Force $SEG | Out-Null
Get-ChildItem "$SEG\*.mp4" -ErrorAction SilentlyContinue | Remove-Item -Force

# Ordered frame list: "NAME KB"  (KB = IN/OUT/PANR/PANL/CLIP)
$frames = @(
 "0000 CLIP","0005 CLIP","0010 CLIP","0015 CLIP","0020 CLIP","0025 CLIP","0030 CLIP","0035 CLIP","0040 CLIP",
 "0045 OUT","0050 IN","0055 IN","0100 IN","0105 PANR","0110 IN","0115 OUT","0120 CLIP","0125 OUT","0130 IN",
 "0135 IN","0140 IN","0145 OUT","0150 PANL","0155 IN","0200 OUT","0205 PANR","0210 IN","0215 IN","0220 OUT",
 "0225 IN","0230 IN","0235 IN","0240 IN","0245 IN","0250 OUT","0255 IN","0300 IN","0305 IN","0310 IN",
 "0315 OUT","0320 IN","0325 IN","0330 OUT","0335 PANL","0340 IN","0345 IN",
 "0350 IN","0355 IN","0400 IN","0405 OUT","0410 PANR","0415 IN","0420 IN","0425 IN","0430 IN","0435 CLIP",
 "0440 IN","0445 OUT","0450 IN","0455 CLIP","0500 OUT","0505 CLIP","0510 IN","0515 CLIP","0520 PANL",
 "0525 IN","0530 OUT","0535 CLIP"
)

# Frame-count plan to hit 321.83s exactly (9655 frames @30fps).
# Section A (first 46): 42x124 + 4x123 = 5700.  Section B (last 22): 17x180 + 5x179 = 3955.
function Get-N($i){
  if ($i -lt 46) { if ($i -lt 42) { 124 } else { 123 } }
  else { $j = $i - 46; if ($j -lt 17) { 180 } else { 179 } }
}

$list = "$BUILD\list.txt"
"" | Out-File -Encoding ascii $list
$idx = 0
foreach ($f in $frames) {
  $parts = $f.Split(" "); $name = $parts[0]; $kb = $parts[1]
  $N = Get-N $idx
  $M = $N - 1
  $out = "$SEG\{0:D3}.mp4" -f $idx
  $dur = [math]::Round($N/30,4)

  if ($kb -eq "CLIP") {
    $src = "$VID\$name.mp4"
    $vf = "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,fps=30,format=yuv420p,tpad=stop_mode=clone:stop_duration=12"
    & $FF -y -i $src -an -vf $vf -frames:v $N -r 30 -c:v libx264 -preset veryfast -pix_fmt yuv420p $out 2>$null
  }
  else {
    $src = "$IMG\$name.png"
    switch ($kb) {
      "IN"   { $z="z=1+0.10*on/$M";    $x="x=iw/2-(iw/zoom/2)"; $y="y=ih/2-(ih/zoom/2)" }
      "OUT"  { $z="z=1.10-0.10*on/$M"; $x="x=iw/2-(iw/zoom/2)"; $y="y=ih/2-(ih/zoom/2)" }
      "PANR" { $z="z=1.08";            $x="x=(iw-iw/zoom)*on/$M"; $y="y=ih/2-(ih/zoom/2)" }
      "PANL" { $z="z=1.08";            $x="x=(iw-iw/zoom)*(1-on/$M)"; $y="y=ih/2-(ih/zoom/2)" }
    }
    $vf = "scale=3840:2160:force_original_aspect_ratio=increase,crop=3840:2160,zoompan=${z}:${x}:${y}:d=${N}:s=1920x1080:fps=30,format=yuv420p"
    & $FF -y -loop 1 -i $src -vf $vf -frames:v $N -r 30 -c:v libx264 -preset veryfast -pix_fmt yuv420p $out 2>$null
  }
  if (-not (Test-Path $out)) { throw "Segment failed: $name ($kb)" }
  "file '$($out -replace '\\','/')'" | Out-File -Encoding ascii -Append $list
  Write-Host ("[{0,2}/68] {1} {2,-4} N={3} ({4}s)" -f ($idx+1), $name, $kb, $N, $dur)
  $idx++
}

Write-Host "Concatenating 68 segments..."
& $FF -y -f concat -safe 0 -i $list -c copy "$BUILD\video.mp4" 2>$null
$sz = [math]::Round((Get-Item "$BUILD\video.mp4").Length/1MB,1)
Write-Host "DONE: build\video.mp4 ($sz MB)"
