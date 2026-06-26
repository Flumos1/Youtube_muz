# One-off: download Ep4 Higgsfield images and name them by timecode (MMSS.png)
$ErrorActionPreference = "Stop"
$dir = "G:\Claude Youtube Muz\Эпизод 4\images\higgsfield_images"
New-Item -ItemType Directory -Force $dir | Out-Null

# Source 1: the saved show_generations snapshot (S1-S17 = 67 images)
$snap = "C:\Users\Рус_Д\.claude\projects\G--Claude-Youtube-Muz\cb7e6b10-ef9f-4a20-981c-9ebea6be2b0a\tool-results\mcp-f0718410-a29d-4e80-805e-53883438d8fe-show_generations-1782482070168.txt"
$j = Get-Content $snap -Raw | ConvertFrom-Json
$today = $j.items | Where-Object { $_.createdAt -ge 1782481367 } | Sort-Object createdAt
$urls = @($today | ForEach-Object { $_.results.rawUrl })

# Source 2: S18 (4 images) not in snapshot - append in createdAt order
$urls += "https://d8j0ntlcm91z4.cloudfront.net/user_3A9UCB8azenuFKi8hYYQ9ZP1au1/hf_20260626_135415_7aa73117-326b-4873-bc8b-335ab17caf52.png"
$urls += "https://d8j0ntlcm91z4.cloudfront.net/user_3A9UCB8azenuFKi8hYYQ9ZP1au1/hf_20260626_135415_42e7a968-72e9-4abd-b415-8b0bdfe9bb5a.png"
$urls += "https://d8j0ntlcm91z4.cloudfront.net/user_3A9UCB8azenuFKi8hYYQ9ZP1au1/hf_20260626_135415_71d13a3a-152d-428f-b403-b02a75491292.png"
$urls += "https://d8j0ntlcm91z4.cloudfront.net/user_3A9UCB8azenuFKi8hYYQ9ZP1au1/hf_20260626_135417_d080ac01-6f7c-470a-8be4-45c78811c57f.png"

Write-Host "Total URLs: $($urls.Count)"

# Per-scene timecode names, in scene order S1..S18. Counts must sum to URL count (71).
$scenes = @(
  @("0000","0016","0032","0046"),   # S1 server room (hook)
  @("0054","0110","0126","0142"),   # S2 dorm room
  @("0149","0157","0205","0213"),   # S3 network spreads
  @("0216","0224","0240","0248"),   # S4 computer lab
  @("0256","0312","0328","0336"),   # S5 boardroom panic
  @("0343","0351","0359","0407"),   # S6 Metallica boxes
  @("0415","0431","0447"),          # S7 courtroom (3)
  @("0452","0508","0516","0524"),   # S8 Napster dies
  @("0530","0546","0554","0610"),   # S9 piracy spreads
  @("0612","0615","0620","0624"),   # S10 record store collapse
  @("0627","0635","0643","0651"),   # S11 $2B memo
  @("0659","0707","0723","0731"),   # S12 Jobs watches
  @("0737","0745","0753","0801"),   # S13 iTunes keynote
  @("0807","0815","0831","0839"),   # S14 mp3 players
  @("0846","0902","0918","0934"),   # S15 headphones montage
  @("0938","0946","0954","1002"),   # S16 Spotify climax
  @("1008","1016","1024","1032"),   # S17 irony boardroom
  @("1035","1038","1041","1044")    # S18 outro dorm dawn
)

$flat = @()
foreach ($s in $scenes) { foreach ($tc in $s) { $flat += $tc } }
Write-Host "Total timecodes: $($flat.Count)"
if ($flat.Count -ne $urls.Count) { Write-Error "MISMATCH: $($flat.Count) names vs $($urls.Count) urls"; exit 1 }

for ($i=0; $i -lt $urls.Count; $i++) {
  $out = Join-Path $dir ("{0}.png" -f $flat[$i])
  Invoke-WebRequest $urls[$i] -OutFile $out
  Write-Host ("  {0}.png  <-  {1}" -f $flat[$i], ($urls[$i] -replace '.*hf_',''))
}
# cleanup test files
Remove-Item (Join-Path $dir "_s1_test_*.png") -ErrorAction SilentlyContinue
Write-Host "DONE. Files in $dir"
Get-ChildItem $dir -Filter *.png | Measure-Object | ForEach-Object { "PNG count: $($_.Count)" }