plan nessus_agent::install_link (
  TargetSpec $targets,
  Boolean $upload = true,
  Optional[String] $install_file_local = '',
  Optional[String] $install_file_destination = '',
  String $installer_path,
  String[64] $key,
  Optional[String[1]] $server = 'cloud.tenable.com',
  Integer[1] $port = 443,
  Optional[String] $ca_path = '',
  Optional[String] $name = '',
  Optional[String] $groups = '',
  Optional[String] $offline_install = '',
  Optional[String] $proxy_host = '',
  Optional[String] $proxy_port = '',
  Optional[String] $proxy_username = '',
  Optional[String] $proxy_password = '',
  Optional[String] $proxy_agent = '',
) {

  # Upload package
  if ($upload) {
    upload_file($install_file_local, $install_file_destination, $targets)
  }

  # Install Nessus agent
  run_task('nessus_agent::install', $targets, {'installer_path' => $installer_path })

  # Link Nessus agent with tenable instance
  run_task('nessus_agent::link', $targets, {
    'key' => $key,
    'server' => $server,
    'port' => $port,
    'ca_path' => $ca_path,
    'name' => $name,
    'groups' => $groups,
    'offline_install' => $offline_install,
    'proxy_host' => $proxy_host,
    'proxy_port' => $proxy_port,
    'proxy_username' => $proxy_username,
    'proxy_password' => $proxy_password,
    'proxy_agent' => $proxy_agent,
  })
    }
