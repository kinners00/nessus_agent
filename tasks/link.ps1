[CmdletBinding()]
Param(
 [Parameter(Mandatory)][string]$key,
 [Parameter(Mandatory)][string]$server,
 [Parameter(Mandatory)][int]$port,    
 [string]$name,
 [string]$ca_path,
 [string]$groups,
 [string]$offline_install,
 [string]$proxy_host,
 [string]$proxy_port,
 [string]$proxy_password,
 [string]$proxy_username,
 [string]$proxy_agent
 )

 $nessus_cli="C:\Program Files\Tenable\Nessus Agent\nessuscli.exe"

 # Validating that Nessus CLI exists before proceeding with agent link
 if (!(Test-Path $nessus_cli)) {
    Write-Host "Nessus agent is not installed because it was not found at $nessus_cli and therefore node cannot be linked with Tenable Instance. Please verify you've specified the correct path to the Nessus CLI" 
    exit
 }

 # Verifying Bolt parameter/variable inputs in order to populate flags and correspond values in Nessus CLI command below
 $cmd = @()

 if (($key)) {
    $key_flag="--key=$key"
    $cmd += $key_flag
 }
 if (($server)) {
    $server_flag="--host=$server"
    $cmd += $server_flag
 } 
 if (($port)) {
    $port_flag="--port=$port"
    $cmd += $port_flag
 } 
 if (($ca_path)) {
    $ca_flag="--ca-path=`"$ca_path`""
    $cmd += $ca_flag
 }
 if (($name)) {
    $name_flag="--name=$name"
    $cmd += $name_flag
 }
 if (($groups)) {
    $groups_flag="--groups=`"$groups`""
    $cmd += $groups_flag
 }
 if (($offline_install -eq "yes")) {
    $offline_flag="--offline-install=$offline_install"
    $cmd += $offline_flag
 }
 if (($proxy_host)) {
    $proxy_host_flag="--proxy-host=$proxy_host"
    $cmd += $proxy_host_flag
 }
 if (($proxy_port)) {
    $proxy_port_flag="--proxy-port=$proxy_port"
    $cmd += $proxy_port_flag
 }
 if (($proxy_password)) {
    $proxy_pass_flag="--proxy-password=$proxy_password"
    $cmd += $proxy_pass_flag
 }
 if (($proxy_username)) {
    $proxy_user_flag="--proxy-username=$proxy_username"
    $cmd += $proxy_user_flag
 }
 if (($proxy_agent)) {
    $proxy_agent_flag="--proxy-agent=$proxy_agent"
    $cmd += $proxy_agent_flag
 }
  
 # Nessus CLI command
& 'C:\Program Files\Tenable\Nessus Agent\nessuscli.exe'agent link $cmd








