#!/usr/bin/env bash
#>
#(
set -u
set +x
set -o pipefail
cd `dirname $0`

source ./00.setenv.sh

download_dir=`conf 00-RND-195.conf download_dir`

out="$download_dir/00.count.stat.txt"

withhead="--with-head"
[[ -s "$out" ]] && withhead=""

#dt=`date +"%F %H:%M"`

./00.count.stat.jl --download-dir="$download_dir" --silent-not-a-dir $withhead >> "$out"

    
    



#)>>"$0.log" 2>&1
