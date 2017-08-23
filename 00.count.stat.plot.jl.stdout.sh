#!/usr/bin/env bash
#>
#(
set -u
set +x
set -o pipefail
cd `dirname $0`

source ./00.setenv.sh

download_dir=`conf 00-RND-195.conf download_dir`

infile="$download_dir/00.count.stat.txt"

#out="$download_dir/00.count.stat.plot.txt"

titles=${1:-""} # можно указать строку именами колонок "-title=ROOT.saved -title=.saved"

jul=`which julia`
julcmd="$jul --color=yes"

cat "$infile" | $julcmd ./00.count.stat.plot.jl $titles




#)>>"$0.log" 2>&1
