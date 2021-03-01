plan nessus_agent::generatelogs (
  TargetSpec $targets,
  Boolean $scrub = false,
  Enum['standard','full'] $level = standard,
  String[1] $nix_source_file = '/opt/nessus_agent/var/nessus/logs/nessus-bug-report-archive.tar.gz',
  String[1] $win_source_file = 'C:\ProgramData\Tenable\Nessus Agent\nessus\logs\nessus-bug-report-archive.txt',
  String[1] $file_destination,
  Optional[String] $user = undef,
) {

# Use puppet agent/facter to determine target OS for further actions below
  $targets.apply_prep

  $win_targets = get_targets($targets).group_by |$target| { $target.facts['kernel'] }['windows']
  $nix_targets = get_targets($targets).group_by |$target| { $target.facts['kernel'] }['Linux']

# Generate bug report logs
  run_task('nessus_agent::generatelogs', $targets, {'level' => $level, 'scrub' => $scrub })

# Download logs to local workstation
  if ($win_targets) {
    download_file($win_source_file, $file_destination, $win_targets)
  } elsif ($nix_targets and $user != undef) {
    run_command("chown ${user} /opt/nessus_agent/var/nessus/logs/nessus-bug-report-archive.tar.gz",$nix_targets, '_run_as' => 'root')
    download_file($nix_source_file, $file_destination, $nix_targets)
  } else  {
    fail_plan("You must provide targets user name")
  }

  # Clean up
   if ($win_targets) {
    run_command('Remove-Item "C:\ProgramData\Tenable\Nessus Agent\nessus\logs\nessus-bug-report-archive.txt" -force',$win_targets, '_run_as' => 'root')
  } elsif ($nix_targets) {
    run_command("rm -f /opt/nessus_agent/var/nessus/logs/nessus-bug-report-archive.tar.gz",$nix_targets, '_run_as' => 'root')
  } else  {
    fail_plan("***Error - Something went wrong. Clean up could not be performed***")
  }

  }
