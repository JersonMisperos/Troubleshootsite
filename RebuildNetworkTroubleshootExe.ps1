$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$project = Join-Path $root 'NetworkTroubleshootLauncher\NetworkTroubleshootLauncher.csproj'
$outputExe = Join-Path $root 'NetworkTroubleshootLauncher\bin\Release\net6.0-windows\NetworkTroubleshoot.exe'
$finalExe = Join-Path $root 'NetworkTroubleshoot.exe'

Write-Host 'Building updated EXE...' -ForegroundColor Cyan
& dotnet build $project -c Release

if (-not (Test-Path $outputExe)) {
    throw "Build output not found: $outputExe"
}

Copy-Item $outputExe $finalExe -Force
Write-Host "EXE updated successfully: $finalExe" -ForegroundColor Green
