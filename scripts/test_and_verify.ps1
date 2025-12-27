<#
  Test and verify PowerShell helper
  Generated: 2025-12-27T21:08:40.785Z
#>

function Write-Info($msg){ Write-Host $msg -ForegroundColor Cyan }
function Write-Success($msg){ Write-Host $msg -ForegroundColor Green }
function Write-Warn($msg){ Write-Host $msg -ForegroundColor Yellow }
function Write-Err($msg){ Write-Host $msg -ForegroundColor Red }

Write-Info "Test and verify FunnyHat plugin (PowerShell)"

$defaultLog = "$env:USERPROFILE\Palworld\BepInEx\LogOutput.log"
$log = Read-Host "Enter path to BepInEx LogOutput.log [$defaultLog]"
if ([string]::IsNullOrWhiteSpace($log)) { $log = $defaultLog }

if (-not (Test-Path -Path $log -PathType Leaf)) {
    Write-Err "Log file not found: $log"
    exit 1
}

Write-Success "Tailing the log: $log"
Write-Warn "Start the game if not running. Press Ctrl-C to stop."

Get-Content -Path $log -Tail 200 -Wait
