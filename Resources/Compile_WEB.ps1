function PAUSE{
    Write-Host "Paused! Press Enter to continue..." -foregroundcolor Red
    Read-Host 
}

function TERMINATE{
    Write-Host
    Write-Host "Terminating program..." -foregroundcolor Red
    Write-Host
    PAUSE
    
    if (Test-Path .\_TEMP ) {
    	Remove-Item -path .\_TEMP -recurse -force
    }
    
    exit
    break
}

$folderOutput = "Outputs"
$webResources = Resolve-Path ".\Resources\WebsiteTemplate"

# Create TEMP directory
Write-Host Creating TEMP directory... -foregroundcolor Yellow
Write-Host 

if (Test-Path .\_TEMP ) {
    Remove-Item -path .\_TEMP -recurse -force
}
$TEMP = New-Item -Name ".\_TEMP" -Type Directory

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

# Verify content
Write-Host Verifying content... -foregroundcolor Yellow
Write-Host 

$manDir = Resolve-Path .\Contents\$folderName
$textDir = Resolve-Path $manDir\text
$imgDir = Resolve-Path $manDir\images

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

# Copy content to TEMP folder
Write-Host Copying content... -foregroundcolor Yellow
Write-Host 

Copy-Item -Recurse -Path $textDir -Destination $TEMP
$contentDir = Resolve-Path $TEMP\text

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

# Rename to .pandoc
Write-Host Renaming content... -foregroundcolor Yellow
Write-Host 

$list = Get-ChildItem -Path $contentDir -Recurse -Filter *.md
foreach($file in $list){
    Rename-Item -Path $file.FullName -NewName ($file.Name.Split(".")[0]+".pandoc")
}

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

# Compile
Write-Host Compiling with HUGO... -foregroundcolor Yellow
Write-Host 

Hugo --config $webResources\config.toml --contentDir $contentDir --layoutDir $webResources\layouts --destination .\$folderOutput\$folderName --cleanDestinationDir --gc

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

# Copy images folder
Write-Host Copying images... -foregroundcolor Yellow
Write-Host 

Copy-Item -Recurse -Force -Path $imgDir -Destination .\$folderOutput\$folderName

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

Remove-Item -path .\_TEMP -recurse -force

PAUSE