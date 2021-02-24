[CmdletBinding()]
Param(
 [string]$level,
 [boolean]$scrub
 )

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

  # Nessus CLI command
& 'C:\Program Files\Tenable\Nessus Agent\nessuscli.exe'bug-report-generator $flags

