#!/bin/bash

nessus_cli="/opt/nessus_agent/sbin/nessuscli"
al="agent link"
nessus="$nessus_cli $al"

# Validating that Nessus CLI exists before proceeding with agent link
  if [[ ! -f $nessus_cli ]] ; then
    echo "***Nessus Agent is not installed because it could found at $nessus_cli and therefore node cannot be linked with Tenable Instance***"
    exit
  fi

# Verifying Bolt parameter/variable inputs in order to populate flags and correspond values in Nessus CLI command below
cmd=($nessus)

  if [[ ! -z $PT_key ]]; then
    key_flag="--key=$PT_key"
    cmd+=( $key_flag )
  fi

  if [[ ! -z $PT_server ]]; then
    host_flag="--host=$PT_server"
    cmd+=( $host_flag )
  fi

  if [[ ! -z $PT_port ]]; then
    port_flag="--port=$PT_port"
    cmd+=( $port_flag )
  fi

  if [[ ! -z $PT_ca_path ]]; then
    ca_flag="--ca-path=\"$PT_ca_path\""
    cmd+=( $ca_flag )
  fi

  if [[ ! -z $PT_name ]]; then
    name_flag="--name=$PT_name"
    cmd+=( $name_flag )
  fi

  if [[ ! -z $PT_groups ]]; then
    groups_flag="--groups=\"$PT_groups\""
    cmd+=( $groups_flag )
  fi

  if [[ "${PT_offline_install}" == @(yes|Yes) ]]; then
    offline_flag="--offline-install=$PT_offline_install"
    cmd+=( $offline_flag )
  fi

  if [[ ! -z $PT_proxy_host ]]; then
    proxy_host_flag="--proxy-host=$PT_proxy_host"
    cmd+=( $proxy_host_flag )
  fi

  if [[ ! -z $PT_proxy_port ]]; then
    proxy_port_flag="--proxy-port=$PT_proxy_port"
    cmd+=( $proxy_port_flag )
  fi

  if [[ ! -z $PT_proxy_password ]]; then
    proxy_password_flag="--proxy-password=$PT_proxy_password"
    cmd+=( $proxy_password_flag )
  fi

  if [[ ! -z $PT_proxy_username ]]; then
    proxy_username_flag="--proxy-username=$PT_proxy_username"
    cmd+=( $proxy_username_flag )
  fi

  if [[ ! -z $PT_proxy_agent ]]; then
    proxy_agent_flag="--proxy-agent=$PT_proxy_agent"
    cmd+=( $proxy_agent_flag )
  fi

# Nessus CLI command
${cmd[@]}