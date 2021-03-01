[CmdletBinding()]
Param(
 [string]$level,
 [boolean]$scrub
 )

 # Verifying Bolt parameter/variable inputs in order to populate flags and correspond values in Nessus CLI command below
 $flags = @( )

 if ($level -eq "full") {
    $full_flag="--full"
    $flags += $full_flag
} 
 if ($scrub) {
    $scrub_flag="--scrub"
    $flags += $scrub_flag
 } 

 $quiet_flag="--quiet"
 $flags += $quiet_flag


# Bug Report Generator command
& 'C:\Program Files\Tenable\Nessus Agent\nessuscli.exe'bug-report-generator $flags

