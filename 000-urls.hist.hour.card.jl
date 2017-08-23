#!/usr/bin/env julia
#using Plans
c = sample("./copyed/urls.hist.2016-11-21T07.gz") |> 

card( s"(?<pref>\./copyed/urls.hist.)(?<hour>(?<day>\d\d\d\d-\d\d-\d\d)T(?<H>\d\d)).gz", "i" ) |>

need_will(s"""
    function( plan )
        pref = plan.addr[:pref]
        day = plan.addr[:day]
        h = parse( Int, plan.addr[:H] )
        [ \"./copyed/handmade.$day.doms.txt \" ]
    end""") |>

prepare_will(s"""
    function( plan, needs )
        ulsfile = needs[1]
        
        hl = `job_history_log -c ./history.conf \"$plan\" \"uid!=0,typenum=0,ref\" -true=ref -cut=\"typenum,uid\"`
        u1 = `uniq`
        murls = `./09-match_urls.pl \"$urlsfile\"`
        u2 = `uniq` # - соседние повторы убираем
        so = Cmd( s\" sort -T. -t\* -k1,1 \", env=\"LANG=POSIX\" )  # -(не уникалим)
        gz = `gzip`
        to = \"$plan.TMP\"
        pipeline( hl, u1, murls, u2, so, gz, stdout=to )|>run
        mv( to, \"$plan\")
        
    end""") |> compile
    
    



#job_history_log -c ./history.conf "$f" "uid!=0,typenum=0,ref" -true=ref -cut="typenum,uid" |
# uniq |
# ./09-match_urls.pl "$urlsfile" |
# uniq | # соседние повторы убираем
# LANG=POSIX sort -T. -t\* -k1,1  | # не уникалим
# viatmp -gz "$f.gz"
