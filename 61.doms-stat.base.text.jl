#!/usr/bin/env julia
#> Статистика по сайтам: 
#> ( весь - чистый / чистый )*100 - "отношение грязного к чистому в процентах".

#> Usage sample: cat "$domains" | ./61.doms-stat.base.text.jl --download="$download_dir" 

# На STDIN подать строки с сайтами
# На STDOUT печатает отчет

"""По каждому *.saved файлу - такая строка отчета
Предполагается что saved-файл - представляет сайт по которому будет отчет.
Сайт содержит несколько страниц. Это все .saved-файлы в тойже папке.
По сайту нужно среднее отношение размеров .main.text/.saved"""
function report_line( dom_n_savedfile::Tuple)
    
    (dom, savedfile) = dom_n_savedfile

    # папка:
    dir = dirname(savedfile)
    
    # медиана отношений размеров:
    (medi, rates) = if isdir(dir)
        
	# saved - относится к сохраненной странице - весь текст (*.saved) - он же "весь текст"
	# main - относится к основному тексту (*.main.text) - он же "чистый текст"

        #saved_n_main_iter = ( ("$root/$saved", "$root/"*replace(saved, r".saved$",".main.text") ) for 
        #                    (root, _, ff) in walkdir(dir) for 
        #                        saved in ff if ismatch(r"\.saved$", saved) )
        
        saved_n_main_iter = []
        for (root, _, files) in walkdir(dir)
            for file in files
                ismatch(r"\.saved$", file) && push!(saved_n_main_iter, ("$root/$file", "$root/"*replace(file, r"\.saved$",".main.text")))
            end
        end
                                                    

        # (весь-чистый/чистый)
        local rates = [ round(Int, ( fs(savedf) -  fs(mainf) )/ fs(mainf) )  for # div - целочисленное деление
    			(savedf, mainf) in saved_n_main_iter if 
    				fs(mainf)>10 && fs(savedf)>0 ]

        length(rates)>0 ? 
    	    let medi = median(rates) |> _->_>=65535 ? 65535 : _ # ограничение итогового значения 65535
    		(medi, rates)
    	    end:
    	    ("NA",rates)       
                                
    else
        ("NA",[])
    end      
    
    # на выходе:
    # join([ dom, fmt(medi), rates ],"*") # вариант с debug инфой
    join([ dom, fmt(medi) ],"*")
end

"Как форматировать"
fs(f::AbstractString) = filesize(f)
fmt(n::Number) = @sprintf("%.i",n)
fmt(s) = s


"печать каждой строки отчета"
main( rio::IO, download_dir::AbstractString) = 
    foreach( println, report_line( tupl_dom_n_file::Tuple ) for 
	tupl_dom_n_file in savedfiles( rio, download_dir))

#"Вот что будет если скрипту не передать параметр"
#main( rio::IO, ::Void) = error("Param --download=<download_dir> must be defined!") 

"Из списка сайтов (STDIN) и имени папки (download_dir) -> список тюплов (домен, saved-файл)  в download_dir"
savedfiles( rio::IO, download_dir::AbstractString) = 
    (#generator: 
        dom_n_file|>chomp|>split|>_->(_[1],_[2]) for
            dom_n_file in eachline( pipeline( rio, `./9110.site-place "$download_dir/"`)))

"Из имени *saved файла -> имя *.main.text файла"
textfile( savedfile) = replace( savedfile, ".saved", ".main.text")


# ----------- start here: -------
using Cmdl
opts = Cmdl.dict(ARGS) |>
 opt("download", mustbe=isdir, musthave=1, msg="Must be a dir") |>
 unexpected()

download_dir = opts["download"][1]

main( STDIN, download_dir )




