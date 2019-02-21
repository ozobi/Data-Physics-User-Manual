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
$doc = "UserManual.md"

# Create TEMP directory
Write-Host Creating TEMP directory... -foregroundcolor Yellow
Write-Host 

if (Test-Path .\_TEMP ) {
    Remove-Item -path .\_TEMP -recurse -force
}
$TEMP = New-Item -Name ".\_TEMP" -Type Directory

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

# Set content directory 
Write-Host Verifying content directory... -foregroundcolor Yellow
Write-Host 

$contentDir = Resolve-Path .\Contents\$folderName
$textDir = Resolve-Path $contentDir\text
$imgDir = Resolve-Path $contentDir\images
$titleDir = Resolve-Path $contentDir\title
$titlePath = Resolve-Path $textDir\_index.md

$titleText = $titleDir.Path.Replace("\", "/")

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

# Create output file
Write-Host Creating output file... -foregroundcolor Yellow
Write-Host 

Set-Content -Path $doc -Value ""

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

# Get file list
Write-Host Getting file list... -foregroundcolor Yellow
Write-Host 

$listRaw = Get-ChildItem -Path $textDir -Recurse -Filter *.md
$baseN = $listRaw[0].FullName.ToString().Split('\\').Count # find base depth value for titles
$listRaw = $listRaw[1..$listRaw.Length]

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

# Processing files
Write-Host Preprocessing... -foregroundcolor Yellow
Write-Host 

foreach ($file in $listRaw){
    # Add Weight
    $weight = Get-Content -Path $file.fullname | Select-String -Pattern "weight:\s*(\d+)"
    Add-Member -InputObject $file -MemberType NoteProperty -Name "Weight" -Value $weight.Matches[0].Groups[1].value
    #Write-Host weight: $file.fullname
    
    # Add Depth
    $depth = $file.FullName.ToString().Split('\\').Count - $baseN
    if (! $file.Name.Equals("_index.md")){
    $depth +=1
    }
    Add-Member -InputObject $file -MemberType NoteProperty -Name "Depth" -Value $depth
    #Write-Host depth: $file.fullname
}

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

# Sort files
Write-Host Sorting file list... -foregroundcolor Yellow
Write-Host 

$list = $listRaw | Sort-Object -Property Directory, Weight, Name

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

# Edit & Merge files
Write-Host Processing files for merge... -foregroundcolor Yellow
Write-Host 

foreach ($file in $list){
    Write-Host "Processing:" $file.FullName -foregroundcolor Yellow

    # Copy to TEMP
    Write-Host Copying... -foregroundcolor Gray

    $fileEdit = Copy-Item -Path $file.FullName -Destination $TEMP -PassThru
    
    # Find Title Name
    Write-Host Finding title name... -foregroundcolor Gray

    try{
    $title_i = Get-Content -Path $fileEdit | Select-String -Pattern "^title:\s*(.+)$"
    $title = $title_i.Matches[0].Groups[1].Value
    } catch {
    Write-Host $fileEdit.FullName
    }
    
    # Remove Header
    Write-Host Removing header... -foregroundcolor Gray

    (Get-Content -Path $fileEdit.FullName -Raw) -Replace "(?m)^-{3}\s*(?:\w+:.+\r?\n?)+-{3}\s?\n^", "" | Set-Content -Path $fileEdit.FullName
    
    # Edit Web tags
    Write-Host Editing WEB tags... -foregroundcolor Gray

    (Get-Content -Path $fileEdit.FullName) -Replace "^\`{{2}%\s*\`/*\w+\s*(note)?\s*%\`}{2}$", ">" | Set-Content -Path $fileEdit.FullName
    
    # Edit image paths
    Write-Host Editing image paths... -foregroundcolor Gray

    (Get-Content -Path $fileEdit.FullName) -Replace "\/images", $imgDir | Set-Content -Path $fileEdit.FullName

    # Add Title
    Write-Host Adding title... -foregroundcolor Gray

    $writeTitle = "`#" * $file.Depth + " " + $title
    Add-Content $doc -Value $writeTitle
    
    # Merge File
    Write-Host Merging file... -foregroundcolor Gray

    Add-Content $doc -Value (Get-Content $fileEdit.FullName)
    
    # Delete File
    Write-Host Deleting temp file... -foregroundcolor Gray

    Remove-Item -Force -Path $fileEdit.FullName

    Write-Host SUCCESS! -foregroundcolor Green
    Write-Host 
}

# Generate PDF
Write-Host Generating PDF-Letter... -foregroundcolor Yellow
pandoc -s $titlePath.Path $doc -o .\$folderOutput\$folderName"_Letter.pdf" --toc --variable documentclass=memoir --variable papersize=letter --variable titleDir=$titleText --template=.\Resources\LaTeXTemplate\templates\extended.tex

Write-Host Generating PDF-A4... -foregroundcolor Yellow
pandoc -s $titlePath.Path $doc -o .\$folderOutput\$folderName"_A4.pdf" --toc --variable documentclass=memoir --variable papersize=a4 --variable titleDir=$titleText --template=.\Resources\LaTeXTemplate\templates\extended.tex

Write-Host 
Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

# Delete temporary files and folders
Write-Host Deleting temporary files and folders... -foregroundcolor Yellow
Write-Host

Remove-Item -Recurse -Force -Path $TEMP
#Remove-Item -Force -Path $doc

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

PAUSE