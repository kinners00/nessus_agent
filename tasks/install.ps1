[CmdletBinding()]
Param(
 [Parameter(Mandatory)][string]$installer_path
 )

 $nessus_cli="C:\Program Files\Tenable\Nessus Agent\nessuscli.exe"

# Verifying if an installer path has been provided 
 if (!($installer_path)) {
     Write-Host "***Error - No install path specified! Please specify path to installer***"
     exit
 }

 # Validating whether the correct file extension has been specified in $installer_path
 $file_ext=(Split-Path -Path ${installer_path} -Leaf).Split(".")[-1];

 if ($file_ext -ne "msi") {
     Write-Host "***Error - Unsupported file type. Found '$file_ext', should be '.msi'***"
     exit
 }

 if (!(Test-Path $installer_path)) {
     Write-Host "***Error - File path is invalid! Please specify valid path to installer***" 
     exit
 }

# Validating whether Nessus agent installation exists or not before attempting installation
 if (!(Test-Path $nessus_cli)) {
     Write-Host "***Installing Nessus agent***" 
     & msiexec /i "${installer_path}"
     sleep(20)
     if ((Test-Path $nessus_cli)) {
         Write-Host "***Nessus agent successfully installed***"
         Remove-Item $installer_path -force
     } else {
         Write-Host "***Error - Something went wrong***"
     }
 } else {
     Write-Host "***Error - Nessus agent is already installed at '$nessus_cli'***"
 }

  