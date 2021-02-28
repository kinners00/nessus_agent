#!/bin/bash

nessus_cli="/opt/nessus_agent/sbin/nessuscli"
bug_report="bug-report-generator"
quiet="--quiet"

# Verifying Bolt parameter/variable inputs in order to populate flags and correspond values in Nessus CLI command below
flags=()

  if [[ $PT_scrub = true ]]; then
    scrub_flag="--scrub"
    flags+=( $scrub_flag )
  fi

  if [[ $PT_level == 'full' ]]; then
    full_flag="--full"
    flags+=( $full_flag )
    echo "Generating bug report - full"
  fi

# Bug Report Generator command
cmd="$nessus_cli $bug_report ${flags[@]} $quiet"

$cmd