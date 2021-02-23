#!/bin/bash

nessus_cli="/opt/nessus_agent/sbin/nessuscli"
service_start="sudo /bin/systemctl start nessusagent.service"
sleep="sleep 15"

# Verifying if an installer path has been provided  
  if [[ -z $PT_installer_path ]]; then
    echo "***Error - No install path specified! Please specify path to installer***"
    exit
  fi

  # Verifying if installer path is valid
  if [[ ! -f $PT_installer_path ]]; then
    echo "***Error - File path invalid! Please specify valid path to installer***"
    exit
  fi

  # Validating whether Nessus agent installation already exists before attempting installation
  if [[ -f $nessus_cli ]] ; then
    echo "***Error - Nessus agent is already installed at '$nessus_cli'***"
    exit
  fi

# Debian/Ubuntu OS check
  if [ -e /etc/os-release ]; then
    export operating_system=$(sed -n -e "/^ID=/p" /etc/os-release | sed -e 's~\(.*\)=\(.*\)~\U\2~g' -e 's~"~~g')
  else
    export operating_system=$(lsb_release -a 2> /dev/null | grep Distributor | awk '{print toupper($3)}')
  fi

# Validating whether the correct file extension has been specified in $installer_path in relation to target node OS | Installs Agent
  if [[ $PT_installer_path == *.deb ]] && [[ "$operating_system" == @(DEBIAN|UBUNTU) ]]; then
    echo "***Installing Nessus agent (.deb)***"
    dpkg -i ${PT_installer_path}
    $sleep
    echo "***Starting Nessus agent service***"
    $service_start
  elif [[ $PT_installer_path == *.rpm ]] && [[ "$operating_system" != @(DEBIAN|UBUNTU) ]]; then
    echo "***Installing Nessus agent (.rpm)***"
    rpm -ivh ${PT_installer_path}
    $sleep
    echo "***Starting Nessus agent service***"
    $service_start
  else
    echo "***Error - Unsupported file type for targets Linux distribution.***"
  fi

# Verify installation
  if [[ -f $nessus_cli ]] ; then
    echo "***Nessus agent installed successfully***"
    rm -f ${PT_installer_path}
  else
    echo "***Error - Something went wrong***"
  fi
