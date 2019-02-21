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

Write-Host Starting server... -foregroundcolor Yellow
Write-Host 

try{
    ..\Resources\tinyweb-1-94\tiny.exe (Resolve-Path ..\Outputs\DP960_User_Manual) 1314 http://127.0.0.1
} catch {
    Write-Host FAILED! -foregroundcolor Red
    Write-Host 
    TERMINATE
}

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

PAUSE