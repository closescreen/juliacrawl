#!/usr/bin/env julia
using Cmdl
using File

opts = Cmdl.dict(ARGS) |>
 opt("download-dir", musthave=1, msg="download-dir!") |>
 opt("with-head", to=Bool) |>
 opt("silent-not-a-dir", to=Bool) |>
 unexpected()

#downdir = Cmdl.first("download-dir=s") # папка где искать файлы напр. --download-dir=./DOWNLOAD/2016-08-22/
downdir = opts["download-dir"][1] # папка где искать файлы напр. --download-dir=./DOWNLOAD/2016-08-22/
#if downdir==nothing error("--download-dir !") end

#withhead = Cmdl.first("with-head") # печатать заголовок если указано --with-head
withhead = opts["with-head"] # печатать заголовок если указано --with-head

#silent_not_a_dir = Cmdl.first("silent-not-a-dir") # не шуметь если нет такой директории
silent_not_a_dir = opts["silent-not-a-dir"]

if silent_not_a_dir==nothing silent_not_a_dir=false end
if !isdir(downdir)
    if silent_not_a_dir
	exit(0)
    else
	error("$downdir not a dir!")
    end		
end

# --- st ---
function stdict(downdir::AbstractString)
 st=Dict{AbstractString,Int}()
 for f in File.files(downdir,f->true)
    let m = match(r"(ROOT)?\.(saved|tags.L2-completed|tags|bugs|descr\.text|main\.text)(.TMP)?$", f)
	if m!=nothing
	    st[m.match]=get(st, m.match, 0)+1 # <-- st[m.match]++
	end
    end
 end
 st::Dict{AbstractString,Int}
end

# -- main ---------
st=stdict(downdir)

#>! .descr.text не делаются, можно убрать колонку
kk=["ROOT.saved.TMP", ".saved.TMP", "ROOT.saved", ".saved","ROOT.tags",".tags","ROOT.tags.L2-completed","ROOT.bugs",".bugs",".main.text"]

dt=Dates.format(now(),"yyyy-mm-ddTHH:MM")

if withhead # если указан ключ --with-head
    join(["head"; "datetime"; kk],"; ")|>println 
end 

bn=basename(replace(downdir,r"/$",""))*"/"

join([bn;dt; map(k->get(st,k,0), kk) ], "; ")|>println



