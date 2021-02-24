#!/bin/bash

nessus_cli="/opt/nessus_agent/sbin/nessuscli"
bug_report="bug-report-generator"
quiet="--quiet"

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

cmd="$nessus_cli $bug_report ${flags[@]} $quiet"

$cmd