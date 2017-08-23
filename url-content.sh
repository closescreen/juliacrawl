#!/usr/bin/env bash
#> url-content.sh <http://url>
#(
set -u
set +x
set -o pipefail
cd `dirname $0`

url=${1:?URL!}

nice phantomjs ./url-content.js $1

#)>>"$0.log" 2>&1
