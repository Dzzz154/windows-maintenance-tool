# Interactive Windows Maintenance Tool

function Show-Menu {
    Clear-Host
    Write-Host "=============================" -ForegroundColor Cyan
    Write-Host "    Windows Maintenance Tool " -ForegroundColor Cyan
    Write-Host "=============================" -ForegroundColor Cyan
    Write-Host "1. Clean System Files and Temp"
    Write-Host "2. Check Disk Health"
    Write-Host "3. Run Virus Scan (Quick)"
    Write-Host "4. Exit"
}

function Clean-System {
    Write-Host "`nStarting Disk Cleanup..." -ForegroundColor Yellow
    Start-Process cleanmgr.exe -ArgumentList "/sagerun:1" -Wait

    Write-Host "`nCleaning Temporary Files..." -ForegroundColor Yellow
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "`nCleaning Windows Update Cache..." -ForegroundColor Yellow
    Stop-Service wuauserv -Force
    Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
    Start-Service wuauserv

    Write-Host "`nSystem cleaning completed!" -ForegroundColor Green
    Pause
}

function Check-DiskHealth {
    Write-Host "`nChecking Disk Health..." -ForegroundColor Yellow
    Get-PhysicalDisk | Select-Object DeviceID, MediaType, Size, HealthStatus | Format-Table
    Pause
}

function Virus-Scan {
    Write-Host "`nStarting Quick Virus Scan..." -ForegroundColor Yellow
    Start-MpScan -ScanType QuickScan
    Write-Host "`nVirus scan initiated!" -ForegroundColor Green
    Pause
}

# Main Program Loop
do {
    Show-Menu
    $choice = Read-Host "`nSelect an option (1-4)"

    switch ($choice) {
        "1" { Clean-System }
        "2" { Check-DiskHealth }
        "3" { Virus-Scan }
        "4" { Write-Host "`nGoodbye!" -ForegroundColor Magenta }
        default { Write-Host "`nInvalid choice. Please select 1-4." -ForegroundColor Red; Pause }
    }
} while ($choice -ne "4")
