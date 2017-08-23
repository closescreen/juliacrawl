#!/usr/bin/env julia


"read STDIN and return iter with [dom, rootsaved] for eachline"
input() = (split(chomp(l)) for l in STDIN|>eachline)

"получает список тюплов (saved,maintext)-файлов  из имени ROOT.saved"
function saved_n_maintext_files(rootsaved)
 dir = dirname(rootsaved)
 rv = []
 !isdir(dir) && return rv
 for (r,_,ff) in walkdir(dir)
  for f in ff
   if ismatch(r"\.main\.text$",f)
    maintextf = joinpath(r,f)
    savedf = replace( maintextf, r"\.main\.text$", ".saved")
    push!(rv, (savedf, maintextf))
   end
  end
 end
 rv
end

"зная имя файла грепает из него html title"
function gettitle(savedfile)
 for l in savedfile|>eachline
    m = match(r"<title>(.+?)</title>", l)
    m!=nothing && return Nullable(m[1])
 end
 return Nullable{AbstractString}()
end

"Вычисляет idf фразы prase в корпусе corpus. corpus - массив массивов фраз."
idf(prase, corpus::Array) = log10( length(corpus)/sum([ 1 for prases in corpus if in(prase,prases)]))


# ----------- START script: ----------------------------------------
push!( LOAD_PATH, dirname(PROGRAM_FILE) ) # where Rake placed
using Rake

stoplist="./SmartStoplist.txt"

min_char_length = 3

max_words = 5

min_keyword_frequency = 1

minIDF = 0.35   


run_rake = init_rake("./SmartStoplist.txt", min_char_length=min_char_length, max_words=max_words, min_keyword_frequency=min_keyword_frequency)

for (dom, rootsaved) in input()
    site_pages = [ Dict(:url => readchomp(savedf*".url"), 
                        :title => get( gettitle(savedf), "NF"),
                        :prases => readlines( pipeline( `cut -d* -f2 $maintextf`, `./textract.py`))  
                    ) for (savedf, maintextf) in saved_n_maintext_files(rootsaved) if filesize(maintextf)>10 ]
    
    site_prases = []

    for page in site_pages 
        append!(site_prases, page[:prases]) 
    end

    site_prases = unique(site_prases)
    
    corpus = [ page[:prases] for page in site_pages ] # массив массивов-документов
    
    prases_idf = Dict( prase=>idf(prase,corpus) for prase in site_prases )
    
    for page in site_pages
        
        prases = [ prase for prase in page[:prases] if prases_idf[prase] > minIDF ] # <-- IDF value filter here   
        
        joined_prases = join(map(chomp,prases), "|") # for debug
        
        keywords = map(first, run_rake(join(prases,"")))
        
        join(STDOUT, [ dom, page[:url], page[:title], joined_prases, keywords ,"\n" ],"*","" )
    end
end    



