#!/usr/bin/env rdmd
module prog1;
import std.stdio;
import std.file;

void main(){
 auto r = ph();
 writefln("Result: %s", r);
}


auto ph(){
 auto f = File("patterns-host.ghostery.txt");
 import std.algorithm, std.string;
 import std.array;
 string[][string] d1;
 foreach( ff; f.byLineCopy.map!(s=>split(s,'*')) ){
    d1[ ff[0] ] = ff[2..$];
 }
 return d1;
}

/*"Returns patterns-host dictionary"
function ph()
    rv = Dict{AbstractString,Array{AbstractString,1}}()
#    for l in open(`cat "patterns-host.ghostery.txt"`) |> t->t[1] |> eachline
    # используются все файлы в текущей директории с именем по шаблону:
    for l in open(`bash -c "cat patterns-host.*.txt"`) |> t->t[1] |> eachline

        rec = split(chomp(l),'\*')
        get!(rv, rec[1], rec[3:end])
    end
    rv
end
//susnet.nu**Blog Rating Tracker*tracker
//tru.am**trueAnthem*widget
*/