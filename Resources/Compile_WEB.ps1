# Onur Zobi - 02/2019
#

$folderOutput = Resolve-Path ".\Outputs"

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

# Copy files to TEMP folder
Write-Host Copying files... -foregroundcolor Yellow
Write-Host 

Copy-Item -Path $manDir\mkdocs.yml -Destination $TEMP

Copy-Item -Recurse -Path $textDir -Destination $TEMP\docs
$contentDir = Resolve-Path $TEMP\docs

Copy-Item -Recurse -Path $imgDir -Destination $contentDir

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

# Edit Cross References
Write-Host Editing references... -foregroundcolor Yellow
Write-Host 

$list = Get-ChildItem -Path $contentDir -Recurse -Filter *.md
foreach($file in $list){
    (Get-Content -Path $file.FullName -Raw) -Replace "\\label.*?\}","" -Replace " \\ref.*?\}","" | Set-Content -Path $file.FullName
}

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

# Compile
Write-Host Compiling with MKDocs Material... -foregroundcolor Yellow
Write-Host 

mkdocs build --clean --config-file "$TEMP\mkdocs.yml" --site-dir "$folderOutput\$folderName"

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

Remove-Item -path .\_TEMP -recurse -force