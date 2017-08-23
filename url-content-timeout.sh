#!/usr/bin/env bash
#> url-content.sh <http://url> <timeout>ms
#(
set -u
set +x
set -o pipefail
cd `dirname $0`

url=${1:?URL!}

tmout_ms=${2:?"timeout ms!"} # указать timeout ms
tmout_sec=$(( tmout_ms / 1000 + 5 ))


timeout $tmout_sec nice phantomjs ./url-content-timeout.js "$url" "$tmout_ms"

#)>>"$0.log" 2>&1
