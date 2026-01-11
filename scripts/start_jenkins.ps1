param(
  [Parameter(Mandatory = $false)]
  [string]$StudentName = "NomPrenom"
)

$ErrorActionPreference = "Stop"

Push-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)
Pop-Location

Push-Location (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "..")

try {
  $env:STUDENT_NAME = $StudentName
  docker compose -f docker-compose.jenkins.yml up -d --build
  Write-Host "Jenkins started on http://localhost:8081/ (admin/admin by default)."
} finally {
  Pop-Location
}

