function PAUSE{
    Write-Host "Paused! Press Enter to continue..." -foregroundcolor Red
    Read-Host 
}

function TERMINATE{
    Write-Host
    Write-Host "Terminating program..." -foregroundcolor Red
    Write-Host
    PAUSE
    
    exit
    break
}

Write-Host Stopping server... -foregroundcolor Yellow
Write-Host 

try{
    Stop-Process -Name "tiny"
	Write-Host SUCCESS! -foregroundcolor Green
	Write-Host 
	PAUSE
} catch {
	Write-Host FAILED! -foregroundcolor Red
    Write-Host 
    TERMINATE
}