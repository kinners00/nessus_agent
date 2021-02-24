plan test::generatelogs (
  TargetSpec $targets,
  #Boolean $scrub = false,
  #Enum $level = [standard, full],
  String[1] $nix_source_file = '/opt/nessus_agent/var/nessus/logs/nessus-bug-report-archive.tar.gz',
  String[1] $win_source_file = 'C:\ProgramData\Tenable\Nessus Agent\nessus\logs\nessus-bug-report-archive.txt',
  String[1] $file_destination,
  Optional[String] $user = undef,
) {

  $targets.apply_prep

  $win_targets = get_targets($targets).group_by |$target| { $target.facts['kernel'] }['windows']
  $nix_targets = get_targets($targets).group_by |$target| { $target.facts['kernel'] }['Linux']

  # downloads bug report tarball
  # if ($download) {
  #   run_command("chown ${user} /opt/nessus_agent/var/nessus/logs/nessus-bug-report-archive.tar.gz",$targets, '_run_as' => 'root')
  #   download_file($source_file, $file_destination, $targets)
  # }

  if ($win_targets) {
    download_file($win_source_file, $file_destination, $win_targets)
  } elsif ($nix_targets and $user != undef) {
    run_command("chown ${user} /opt/nessus_agent/var/nessus/logs/nessus-bug-report-archive.tar.gz",$nix_targets, '_run_as' => 'root')
    download_file($nix_source_file, $file_destination, $nix_targets)
  } else  {
    fail_plan("You must provide targets user name")
  }

  # Install Nessus agent
 #run_task('nessus_agent::install', $targets, {'installer_path' => $installer_path })

  # Link Nessus agent with tenable instance
  #run_task('nessus_agent::link', $targets, {
  #  'key' => $key,
  #  'server' => $server,
  #  'port' => $port,
  #  'ca_path' => $ca_path,
  #  'name' => $name,
  #  'groups' => $groups,
  #  'offline_install' => $offline_install,
  #  'proxy_host' => $proxy_host,
  #  'proxy_port' => $proxy_port,
  #  'proxy_username' => $proxy_username,
  #  'proxy_password' => $proxy_password,
  #  'proxy_agent' => $proxy_agent,
  #})
    }
