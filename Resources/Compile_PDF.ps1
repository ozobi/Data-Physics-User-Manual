# Onur Zobi - 02/2019
#

$folderOutput = Resolve-Path ".\Outputs"
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
$templateDir = Resolve-Path .\Resources\eisvogel.tex
$header = Resolve-Path $contentDir\header.md

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
    if ($weight.Matches[0].Groups[1].value.Length -eq 1){
        $weightStr = "0" + $weight.Matches[0].Groups[1].value
    } else{
        $weightStr = $weight.Matches[0].Groups[1].value
    }
    Add-Member -InputObject $file -MemberType NoteProperty -Name "Weight" -Value $weightStr
    
    # Add Depth
    $depth = $file.FullName.ToString().Split('\\').Count - $baseN
    if (! $file.Name.Equals("index.md")){ $depth +=1 }
    Add-Member -InputObject $file -MemberType NoteProperty -Name "Depth" -Value $depth

    #Write-Host $file.fullname weight: $weight.Matches[0].Groups[1].value depth: $depth
}

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

# Sort files
Write-Host Sorting file list... -foregroundcolor Yellow
Write-Host 

$list = $listRaw | Sort-Object -Property Directory, Depth, Weight, Name

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

    (Get-Content -Path $fileEdit.FullName -Raw) -Replace "^\s*-{3}\s*[\w\W]*?-{3}", "" | Set-Content -Path $fileEdit.FullName
    
    # Edit Web tags
    Write-Host Editing WEB tags... -foregroundcolor Gray

    (Get-Content -Path $fileEdit.FullName -Raw)  -Replace "!!! .*\s*", ">`n" | Set-Content -Path $fileEdit.FullName

    # Add Title
    Write-Host Adding title... -foregroundcolor Gray

    $trimD = $file.Directory.Name.Split("-")[0]+"-"
    $trimF = $file.Name.Split("-")[0]+"-"
    $title1 = $file.Directory.Name.TrimStart($trimD) -Replace '[^a-zA-Z0-9_ ]',''
    $title2 = $file.Name.Split(".")[0].TrimStart($trimF) -Replace '[^a-zA-Z0-9_ ]',''
    if($file.Name -eq "index.md"){
        $ref = $title1 + "-" + $file.Name.Split(".")[0]
    } else{
        $ref = $title1 + "-" + $title2
    }
    $writeTitle = "`n"+"`#" * $file.Depth + " " + $title + " {#" + $ref + "}"
    Add-Content $doc -Value $writeTitle

    # Add Title Reference
    Write-Host Adding title references... -foregroundcolor Gray

    $title_s = (Get-Content -Path $fileEdit.FullName) | Select-String -AllMatches -Pattern "(^#+ )(.*)"
    ForEach($t in $title_s){
        $tEdit1 = $t.Matches[0].Value.TrimEnd(" ")
        $tEdit1_S = $tEdit1 -Replace '[\(\)\[\]\{\}\$\^\*\?\+]',"\`$0"
        $tEdit2 = ($t.Matches[0].Groups[2].Value).ToLower().TrimEnd(" ") -Replace '[^a-zA-Z0-9_ ]','' -Replace ' {2,}',' ' -Replace ' ','-'
        $tEdit =  "$tEdit1 {#$ref-$tEdit2}"
        (Get-Content -Path $fileEdit.FullName -Raw) -Replace "$tEdit1_S\s*\n","$tEdit`n`n" | Set-Content -Path $fileEdit.FullName
    }

    #(Get-Content -Path $fileEdit.FullName) -Replace "^#+ .*", ('$1$2'+" {#$ref-"+'$2'+"}") | Set-Content -Path $fileEdit.FullName

    # Edit Cross References
    Write-Host Editing references... -foregroundcolor Gray

    (Get-Content -Path $fileEdit.FullName) -Replace '\.md#','.md-' | Set-Content -Path $fileEdit.FullName
    (Get-Content -Path $fileEdit.FullName) -Replace ']\(\.\.\/\d{2}-(.*?)\/\d{0,2}-?(.*?)\.md(.*?)\)', '](#$1-$2$3)' | Set-Content -Path $fileEdit.FullName
    
    # Edit image paths
    Write-Host Editing image paths... -foregroundcolor Gray

    (Get-Content -Path $fileEdit.FullName) -Replace "\/images", $imgDir | Set-Content -Path $fileEdit.FullName

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
pandoc $header $doc -o "$folderOutput\UserManual-Letter.pdf" --from markdown --template "$templateDir" --toc --number-sections --top-level-division=chapter --listings --variable papersize=letter

Write-Host Generating PDF-A4... -foregroundcolor Yellow
pandoc $header $doc -o "$folderOutput\UserManual-A4.pdf" --from markdown --template "$templateDir" --toc --number-sections --top-level-division=chapter --listings --variable papersize=a4

Write-Host 
Write-Host SUCCESS! -foregroundcolor Green
Write-Host 

# Delete temporary files and folders
Write-Host Deleting temporary files and folders... -foregroundcolor Yellow
Write-Host

Remove-Item -Recurse -Force -Path $TEMP
Remove-Item -Force -Path $doc

Write-Host SUCCESS! -foregroundcolor Green
Write-Host 