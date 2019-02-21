# Onur Zobi - 02/2019
#

function PAUSE{
    write-host "Paused! Press Enter to continue..." -foregroundcolor Red
    read-host 
}

# DP
Write-Host "
   MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM   
  MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM 
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM        MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM       MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM       MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM       MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM       MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM       MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMM       MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMM       MMMMMMMMMMM        MMMMMMMMMMMMMMMM
MMMMMMMMMMMMMM                      MMMM                    MMMMMMMMMMM
MMMMMMMMMMMM                        MMM                      MMMMMMMMMM
MMMMMMMMMMM       MMMMMMMMMM       MM        MMMMMMMMMM       MMMMMMMMM
MMMMMMMMMM       MMMMMMMMMMM       MM       MMMMMMMMMMM       MMMMMMMMM
MMMMMMMMMM       MMMMMMMMMMM       MM       MMMMMMMMMMM       MMMMMMMMM
MMMMMMMMM        MMMMMMMMMMM       MM       MMMMMMMMMMM       MMMMMMMMM
MMMMMMMM         MMMMMMMMMMM       MM       MMMMMMMMMMM       MMMMMMMMM
MMMMMMMM        MMMMMMMMMMM        MM      MMMMMMMMMMMM       MMMMMMMMM
MMMMMMMM        MMMMMMMMMMM       MM       MMMMMMMMMMMM       MMMMMMMMM
MMMMMMMM        MMMMMMMMMMM       MM       MMMMMMMMMMM        MMMMMMMMM
MMMMMMMM        MMMMMMMMMM        MM       MMMMMMMMMMM       MMMMMMMMMM
MMMMMMMM       MMMMMMMMMMM        MM       MMMMMMMMMMM       MMMMMMMMMM
MMMMMMMMM      MMMMMMMMMMM       MM        MMMMMMMMMM       MMMMMMMMMMM
MMMMMMMMM      MMMMMMMMMMM       MM        MMMMMMMMMM       MMMMMMMMMMM
MMMMMMMMM      MMMMMMMMMMM       MM       MMMMMMMMMMM      MMMMMMMMMMMM
MMMMMMMMMM                       MM                       MMMMMMMMMMMMM
MMMMMMMMMMMM                    MM                      MMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM        MMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM       MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM       MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM       MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM        MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM        MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM        MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM        MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM 
   MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM  
" -foregroundcolor Red -backgroundcolor White

if (Test-Path .\_TEMP ) {
    	Remove-Item -path .\_TEMP -recurse -force
}
    
Write-Host Welcome! -foregroundcolor Magenta
Write-Host 

# Selection PDF, WEB, or ALL
Write-Host "Select to compile" -foregroundcolor DarkCyan
Write-Host "1. PDF"
Write-Host "2. Website"
Write-Host "3. BOTH"
Write-Host 
$num1 = Read-Host "Enter the number"
Write-Host 

# Selection of Content
$list = Get-ChildItem -Path ./Contents -Attributes Directory

Write-Host "Select content from the list" -foregroundcolor DarkCyan
$k=1;
foreach ($file in $list) {
    Write-Host "$k. $file"
    Add-Member -InputObject $file -MemberType NoteProperty -Name "Type" -Value $file.Name.Split("_")[0]
    $k++
}
Write-Host "$k. ALL"
Write-Host 
$num2 = Read-Host "Enter the number"
Write-Host 
Write-Host 

# Compile Selection
switch ( $num1 ){
	"1" { # Compile PDF
		if($num2 -eq $k){ # Complete List
			foreach ($file in $list) {
				$folderName=$file.Name
                Write-Host Compiling $file.Name PDF -foregroundcolor DarkCyan
                Write-Host 
				(.\Resources\Compile_PDF.ps1)
			}
            PAUSE
		} else{ # Selection
			$folderName=$list[$num2-1].Name
            Write-Host Compiling $list[$num2-1].Name PDF -foregroundcolor DarkCyan
            Write-Host 
			(.\Resources\Compile_PDF.ps1)
            PAUSE
		}
        break
	}

	"2" { # Compile Website
		if($num2 -eq $k){ # Complete List
			foreach ($file in $list) {
				$folderName=$file.Name
                $configName="config-"+$file.Type+".toml"
                Write-Host Compiling $file.Name WEB -foregroundcolor DarkCyan
                Write-Host 
				(.\Resources\Compile_WEB.ps1)
			}
            PAUSE
		} else{ # Selection
			$folderName=$list[$num2-1].Name
            $configName="config-"+$list[$num2-1].Type+".toml"
            Write-Host Compiling $list[$num2-1].Name WEB -foregroundcolor DarkCyan
            Write-Host 
			(.\Resources\Compile_WEB.ps1)
            PAUSE
		}
		break
	}

	"3" { # Compile Both PDF and Website
		if($num2 -eq $k){ # Complete List
			foreach ($file in $list) {
				$folderName=$file.Name
                $configName="config-"+$file.Type+".toml"
                Write-Host Compiling $file.Name WEB -foregroundcolor DarkCyan
                Write-Host 
				(.\Resources\Compile_WEB.ps1)
                Write-Host Compiling $file.Name PDF -foregroundcolor DarkCyan
                Write-Host 
				(.\Resources\Compile_PDF.ps1)
			}
            PAUSE
		} else{ # Selection
			$folderName=$list[$num2-1].Name
            $configName="config-"+$list[$num2-1].Type+".toml"
            Write-Host Compiling $list[$num2-1].Name WEB -foregroundcolor DarkCyan
            Write-Host 
			(.\Resources\Compile_WEB.ps1)
            Write-Host Compiling $list[$num2-1].Name PDF -foregroundcolor DarkCyan
            Write-Host 
			(.\Resources\Compile_PDF.ps1)
            PAUSE
		}
		break
	}
	default {return 0; break}
}