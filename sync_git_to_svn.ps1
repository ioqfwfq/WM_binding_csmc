# sync_git_to_svn.ps1

$gitRoot = "D:\WM_binding_git"
$srcEvents = Join-Path $gitRoot "events_WM"
$dstEvents = "D:\neuro1\code\events\WM_binding_pilot"

$srcPsy = Join-Path $gitRoot "psychophysics_WM"
$dstPsy = "D:\neuro1\code\psychophysics\WM_binding_pilot"

Write-Host "`n==== $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ===="
Write-Host "`n=== Pulling latest from Git ==="
cd $gitRoot
$gitPull = git pull
if ($LASTEXITCODE -ne 0) {
    Write-Host " Git pull failed. Aborting sync."
    exit 1
}

Write-Host "`n=== Syncing Git -> SVN for events_WM ==="
robocopy $srcEvents $dstEvents /MIR /XD ".git" ".svn" ".venv"
robocopy $srcPsy $dstPsy /MIR /XD ".git" ".svn" ".venv"

Write-Host "`n=== Syncing Git -> SVN for psychophysics_WM ==="
robocopy $srcEvents $dstEvents /MIR /XD ".git" ".svn" ".venv"
robocopy $srcPsy $dstPsy /MIR /XD ".git" ".svn" ".venv"


Write-Host "` Sync complete. Launching TortoiseSVN Commit dialogs..."

# Open TortoiseSVN commit dialogs directly
Start-Process "TortoiseProc.exe" "/command:commit /path:`"$dstEvents`""
Start-Process "TortoiseProc.exe" "/command:commit /path:`"$dstPsy`""
