# my Julia implementation of rake 

module Rake

lookas_num(s::AbstractString) = ismatch(r"^\d*[\.\,]?\d*$",s)

export readwords
"Return's list of words of file"
readwords( file::AbstractString) =
    [w for l in file|>eachline for w in split(l) if !ismatch(r"^\s*#",l) ]

export separate_words
"Return's words list of text, where word size > min"
separate_words(txt::AbstractString, word_size::Int) =
    [ w for w in split(txt) if length(w) > word_size && !lookas_num(w) ]    
# py:        if len(current_word) > min_word_return_size and current_word != '' and not is_number(current_word):

export split_sentences
"List of sentences"
split_sentences(txt::AbstractString) = 
    split( txt, r"[\[\]\n\.\!\?\,\;\:\t\-\"\(\)\'\u2019\u2013]" )

export stop_word_regex
stop_word_regex(stop_word_list::Array) = 
    map( w->"\\b$w\\b", stop_word_list) |> _->join(_,"|") |> 
        _->Regex(_,"i")
        
export generate_candidate_keywords        
function generate_candidate_keywords( 
    sentence_list, stopword_pattern; min_char_length=1, max_words=5)
    rv = []
    for s in sentence_list
        prases = map(_->lowercase(strip(_)), split(s, stopword_pattern))
        filter!(prases) do prase
            !isempty(prase) && is_acceptable( prase, min_char_length, max_words)
        end
        append!(rv, prases)
    end
    rv
end

function is_acceptable(prase, min_char_length, max_words)
    length(prase) < min_char_length && return false
    prase|>split|>length > max_words && return false
    (dig_cnt, alf_cnt) = 
        reduce( (_,x)->isdigit(x)?
            (_[1]+1,_[2]): (_[1],_[2]+1), (0,0), prase)
    
    alf_cnt==0 && return false
    dig_cnt>alf_cnt && return false
    true
end            

export calculate_word_scores
function calculate_word_scores(phraseList)
    word_frequency = Dict()
    word_degree = Dict()
    for phrase in phraseList
        word_list = separate_words(phrase, 0)
        word_list_length = length(word_list)
        word_list_degree = word_list_length - 1
        for word in word_list
            word_frequency[word] = get(word_frequency,word,0)+1
            word_degree[word] = get(word_degree,word,0) + word_list_degree
        end
    end
    for (w,fr) in word_frequency
        word_degree[w] = word_degree[w] + fr
    end
    word_score = Dict()
    for (w,fr) in word_frequency
        word_score[w] = word_degree[w] / word_frequency[w]
    end
    word_score
end

export generate_candidate_keyword_scores
function generate_candidate_keyword_scores(
        prase_list, word_score; min_keyword_frequency=1)
    keyword_candidates = Dict()
    for prase in prase_list
        if min_keyword_frequency > 1 &&
            count( _->_==prase, prase_list) < min_keyword_frequency
                continue
        end
        word_list = separate_words(prase, 0)
        candidate_score = 0
        for word in word_list
            candidate_score += word_score[word]
        end
        keyword_candidates[prase] = candidate_score
    end
    keyword_candidates
end

export init_rake
"Create function for apply on text"
function init_rake( stop_words_path::AbstractString; min_char_length=1, 
                                        max_words=5, min_keyword_frequency=1)
        
    stop_words_pattern = stop_word_regex( readwords( stop_words_path))
    
    function(txt)
        sentence_list = split_sentences(txt)
        prase_list = generate_candidate_keywords(
            sentence_list, stop_words_pattern, min_char_length=min_char_length, max_words=max_words)

        word_scores = calculate_word_scores(prase_list)
        keyword_candidates = generate_candidate_keyword_scores( prase_list, word_scores, min_keyword_frequency=min_keyword_frequency)
        rv = sort( [ (k,v) for (k,v) in keyword_candidates ], by=_->_[2], rev=true)
    end
end        
    
end # of module


