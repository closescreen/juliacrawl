#!/usr/bin/env bash

set -u
set +x
set -o pipefail
cd `dirname $0`

(for f in `find /home/d.belyaev/share3/TIKETS/RND-195/DOWNLOAD/2016-10-31/ -type f -name "*.main.text" | 
 head -n10000 |sort -R|head -n 100`; 
 do

 extracted=`cat "$f"| cut -d* -f2 | ./textract.py` 
 
 echo -e "\n==================$(basename $f):============="; 
 cat "$f"| cut -d* -f2 
 echo -e "\n*********** extracted: ***********"
 echo "$extracted"
 echo "\n-----------keywords: -------------"; 
 echo "$extracted" | python2.7 ./rake.py 3 10 1 15; #minchars maxwords minfreq head
  
 echo -e "======================end of $f==================================\n\n"; 
done;)  


