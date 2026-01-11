param(
  [Parameter(Mandatory = $false)]
  [string]$Repo = "MORS4/devops",

  [Parameter(Mandatory = $false)]
  [string]$Base = "main",

  [Parameter(Mandatory = $false)]
  [string]$Head = "dev",

  [Parameter(Mandatory = $false)]
  [string]$Title = "Merge dev into main",

  [Parameter(Mandatory = $false)]
  [string]$Body = "Automated PR created for the DevOps mini project.",

  [Parameter(Mandatory = $false)]
  [string]$Token = $env:GITHUB_TOKEN
)

if ([string]::IsNullOrWhiteSpace($Token)) {
  Write-Error "Missing GitHub token. Set env var GITHUB_TOKEN (classic PAT) then re-run."
  exit 1
}

$headers = @{
  Authorization = "Bearer $Token"
  Accept        = "application/vnd.github+json"
  "User-Agent"  = "projet-devops-script"
}

function Invoke-GhApi($method, $url, $bodyObj = $null) {
  if ($null -eq $bodyObj) {
    return Invoke-RestMethod -Method $method -Uri $url -Headers $headers
  }
  $json = $bodyObj | ConvertTo-Json -Depth 10
  return Invoke-RestMethod -Method $method -Uri $url -Headers $headers -ContentType "application/json" -Body $json
}

# Check if PR already exists
$existing = Invoke-GhApi "GET" "https://api.github.com/repos/$Repo/pulls?state=open&head=$($Repo.Split('/')[0]):$Head&base=$Base"
if ($existing.Count -gt 0) {
  Write-Host "PR already exists: $($existing[0].html_url)"
  exit 0
}

$payload = @{
  title = $Title
  head  = $Head
  base  = $Base
  body  = $Body
}

$pr = Invoke-GhApi "POST" "https://api.github.com/repos/$Repo/pulls" $payload
Write-Host "Created PR: $($pr.html_url)"

