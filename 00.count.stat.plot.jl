using UnicodePlots
using Cmdl
import It

#d=Cmdl.first("download-dir=s")
#d==nothing && error("download-dir!")
opts = Cmdl.dict(ARGS) |>
 opt("t") |> 
 unexpected(warning=true)

#cmdl_titles=Cmdl.get("t=s")
cmdl_titles=opts["t"] # all array as is

isempty(cmdl_titles) && info("use -t=NAME1 -t=NAME2 ... for custom lines")


# f="$d/00.count.stat.txt" # like "./DOWNLOAD/2016-09-26/00.count.stat.txt"
# !isfile(f) && error("file $f not found!") 

let ll = eachline(STDIN),
    tt = ll|>first|>chomp,
    fields(l) = split(chomp(l), r"\;\s*"),
    titles = fields(tt),
    parseint(s::AbstractString) = parse(Int,s),
    dd=ll|>collect|>dd->map(fields,dd),
    wcl=length(dd),
    nn=1:wcl,
    ttdict = Dict(t=>n for (n,t) in enumerate(titles)),
    mycol(t::AbstractString) = map(l->l[ttdict[t]], dd),
    mycolint(t::AbstractString)=parseint.(mycol(t)),
    plottt=!isempty(cmdl_titles)? cmdl_titles : titles[5:end]
    firstplot = lineplot( nn, plottt[1]|>mycolint, name=plottt[1], width=min(120,wcl*3), height=min(40,wcl))
    for title_i in plottt[2:end]
    
        lineplot!(firstplot, nn, mycolint(title_i), name=title_i)
    end
    print(firstplot)
end
