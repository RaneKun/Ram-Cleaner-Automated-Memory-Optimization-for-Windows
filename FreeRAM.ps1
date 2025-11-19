# FreeRAM.ps1
# ASUS-style memory cleaner script

# -------------------------
# Configuration
# -------------------------
$standbyClearTool = "C:\Scripts\EmptyStandbyList.exe"   # Path to EmptyStandbyList.exe
$logFile = "C:\Scripts\FreeRAM_Log.txt"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# -------------------------
# Function to get current memory stats
# -------------------------
function Get-MemoryStats {
    $os = Get-CimInstance Win32_OperatingSystem
    $total = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
    $free = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
    $used = [math]::Round($total - $free, 1)
    return [PSCustomObject]@{TotalGB=$total; UsedGB=$used; FreeGB=$free}
}

# -------------------------
# Get memory before cleanup
# -------------------------
$before = Get-MemoryStats

# -------------------------
# Trim working sets of active processes
# -------------------------
$processes = Get-Process | Where-Object { $_.Responding -eq $true }
foreach ($p in $processes) {
    try {
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($p) | Out-Null
        $null = (Get-Process -Id $p.Id).MinWorkingSet = $p.MinWorkingSet
        $null = (Get-Process -Id $p.Id).MaxWorkingSet = $p.MaxWorkingSet
    } catch {}
}

# -------------------------
# Optional: Clear standby memory (requires EmptyStandbyList.exe)
# -------------------------
if (Test-Path $standbyClearTool) {
    Start-Process -FilePath $standbyClearTool -ArgumentList workingsets -WindowStyle Hidden -Wait
    Start-Process -FilePath $standbyClearTool -ArgumentList modifiedpagelist -WindowStyle Hidden -Wait
    Start-Process -FilePath $standbyClearTool -ArgumentList standbylist -WindowStyle Hidden -Wait
}

# -------------------------
# Get memory after cleanup
# -------------------------
Start-Sleep -Seconds 3
$after = Get-MemoryStats

# -------------------------
# Calculate difference & log it
# -------------------------
$freed = [math]::Round(($after.FreeGB - $before.FreeGB), 2)

# Use ASCII arrow for Task Scheduler compatibility
$logEntry = ("{0} | Freed: {1}GB | Before: {2}GB free -> After: {3}GB free | Total: {4}GB" -f `
    $timestamp, $freed, $before.FreeGB, $after.FreeGB, $after.TotalGB)

# Ensure UTF-8 without BOM for correct symbols
$logEntry | Out-File -FilePath $logFile -Encoding UTF8 -Append

# -------------------------
# Optional console output (safe for manual runs)
# -------------------------
Write-Output $logEntry