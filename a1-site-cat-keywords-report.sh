#!/usr/bin/env bash
 выкинуть
# Самая простая  версия . Без IDF. 
#> отчет:
#> по доменам из handmade.<day>.doms ---> по их урлам ---> dom, url, title, ключевые слова
#(
set -u
set +x
set -o pipefail
cd `dirname $0`
source ./00.setenv.sh

N=3 # количество процессов

if [[ ${1:-""} == "start" ]];then shift && nice fork -pf="$0.pids" -n="$N" -dela=3 -ed=s "$0 $@"  --wait # enable -wait or redirect out to log
elif [[ ${1:-""}  == "stop" ]];then shift && fork -pf="$0.pids" -kila
else 
# --------- begin of script body ----

# определить download_dir:
downl=${1-""} # < ----[ можно указать download_dir параметром]
[[ -z "$downl" ]] && cd .. && downl=`conf ./00-RND-195.conf download_dir` && cd ./rake+ruterm

# определить день:
day=`echo "$downl" | fn2days`
[[ -z "$day" ]] && echo "day!">&2 && exit 1

# определить файл доменов:
doms="../copyed/handmade.$day.doms.txt"
[[ ! -s "$doms" ]] && echo "$doms file not found!">&2 && exit 1

# найти соотв. доменам скачанные файлы в DOWNLOAD
cat "$doms" | ../9110.site-place "$downl" | # dom .saved
 while read dom rootsaved; do
    [[ ! -s "$rootsaved" ]] && continue # не нашли для домена сохраненую страницу
    sitedir=`dirname "$rootsaved"`
    find "$sitedir" -name "*.main.text" |
        while read textf; do
            noext=`echo "$textf" | sed -e's|\.main\.text||'` # имя файла без расширения .main.text
            urlf="$noext.saved.url"
            url=`cat "$urlf"`
            title=`cat "$noext.saved" | ./html-title.pl`
            
            keywords=`cat "$textf"| cut -d* -f2 | ./textract.py | ./rake.py 3 10 1 15 | perl -e'print join("|",map {chomp; $_} <>);'`
            
            echo "$dom*$url*$title*$keywords"
            
        done


    
    
         
 done

# в отчете нужно:
#  - домен
#  - saved.url --> url
#  - saved --> title
#  - main.text через --> textract.py (нормализованые слова) --> через rake.py (ключевые слова)




# --------- end of script bidy ------ 
fi

#)>>"$0.log" 2>&1
