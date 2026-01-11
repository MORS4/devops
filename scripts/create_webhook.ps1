param(
  [Parameter(Mandatory = $false)]
  [string]$Repo = "MORS4/devops",

  [Parameter(Mandatory = $true)]
  [string]$JenkinsUrl,

  [Parameter(Mandatory = $false)]
  [string]$Secret = "",

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

$payloadUrl = $JenkinsUrl.TrimEnd('/') + "/github-webhook/"

# Check existing hooks
$hooks = Invoke-GhApi "GET" "https://api.github.com/repos/$Repo/hooks"
$existing = $hooks | Where-Object { $_.config.url -eq $payloadUrl }
if ($null -ne $existing) {
  Write-Host "Webhook already exists for: $payloadUrl"
  exit 0
}

$payload = @{
  name   = "web"
  active = $true
  events = @("push", "pull_request")
  config = @{
    url          = $payloadUrl
    content_type = "json"
    insecure_ssl = "0"
    secret       = $Secret
  }
}

$hook = Invoke-GhApi "POST" "https://api.github.com/repos/$Repo/hooks" $payload
Write-Host "Created webhook id=$($hook.id) url=$payloadUrl"

