<#
  Generate a Suno track via TTAPI (submit -> poll -> download).
  Reads TTAPI_KEY from G:\Claude Youtube Muz\.env (gitignored).

  Usage:
    pwsh scripts/generate_suno.ps1 -Prompt "1970s analog tension cue..." -Out "T1"
    pwsh scripts/generate_suno.ps1 -Prompt "..." -Out "T3" -Mv chirp-v5-5
    Add -Vocals to allow vocals (default is instrumental).

  Saves to G:\Claude Youtube Muz\audio\<Out>.mp3 (TTAPI usually returns 2 takes -> <Out>_v1/_v2).
#>
param(
  [Parameter(Mandatory=$true)][string]$Prompt,
  [Parameter(Mandatory=$true)][string]$Out,
  [string]$Mv = "chirp-v5",
  [string]$AudioDir = "G:\Claude Youtube Muz\audio",
  [switch]$Vocals
)
$ErrorActionPreference = "Stop"

# --- load TTAPI_KEY from .env ---
$envPath = "G:\Claude Youtube Muz\.env"
if (-not (Test-Path $envPath)) { throw ".env not found at $envPath" }
$key = $null
foreach ($line in Get-Content $envPath) {
  if ($line -match '^\s*TTAPI_KEY\s*=\s*(.+?)\s*$') { $key = $Matches[1].Trim() }
}
if (-not $key) { throw "TTAPI_KEY is empty or missing in $envPath" }

$headers = @{ "TT-API-KEY" = $key; "Content-Type" = "application/json" }
$body = @{
  custom                 = $false           # inspiration mode (single style/vibe text)
  instrumental           = (-not $Vocals)   # default: instrumental
  mv                     = $Mv
  gpt_description_prompt = $Prompt
} | ConvertTo-Json -Depth 5

Write-Host "Submitting '$Out' (mv=$Mv, instrumental=$(-not $Vocals))..."
$submit = Invoke-RestMethod -Uri "https://api.ttapi.io/suno/v1/music" -Method Post -Headers $headers -Body $body
$jobId = $submit.data.job_id
if (-not $jobId) { $jobId = $submit.data.jobId }
if (-not $jobId) { throw "No job_id in response: $($submit | ConvertTo-Json -Depth 5)" }
Write-Host "job_id: $jobId"

# --- poll ---
$audioDir = $AudioDir
New-Item -ItemType Directory -Force $audioDir | Out-Null
$deadline = (Get-Date).AddMinutes(6)
while ((Get-Date) -lt $deadline) {
  Start-Sleep -Seconds 6
  $fetch = Invoke-RestMethod -Uri "https://api.ttapi.io/suno/v2/fetch?jobId=$([uri]::EscapeDataString($jobId))" -Headers @{ "TT-API-KEY" = $key }
  $status = $fetch.status; if (-not $status) { $status = $fetch.data.status }
  $progress = $fetch.data.progress
  Write-Host ("  status={0} progress={1}" -f $status, $progress)
  if ($status -eq "SUCCESS") {
    $musics = $fetch.data.musics
    $i = 0
    foreach ($m in $musics) {
      $i++
      $name = if ($musics.Count -gt 1) { "${Out}_v$i" } else { $Out }
      $dest = "$audioDir\$name.mp3"
      Invoke-WebRequest -Uri $m.audioUrl -OutFile $dest -UseBasicParsing
      $sz = [math]::Round((Get-Item $dest).Length / 1MB, 1)
      Write-Host ("  saved {0}.mp3 ({1} MB, {2}s)" -f $name, $sz, $m.duration)
    }
    Write-Host "DONE: $Out"
    return
  }
  if ($status -eq "FAILED") {
    throw "Generation FAILED: $($fetch.data.failReason)"
  }
}
throw "Timed out after 6 min for $Out"
