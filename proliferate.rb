#-*- coding:utf-8 -*-
require './request'
require './parser/'

def ProliLoop( key, file, searched, not_searched, num )
    """
    Iteratly? proliferate keys
    """
    html = RequestHTML( key, 1 )
    relevant_result = GetRelevantResult( html )
    # release space
    html = nil
    searched.merge!( { key=>true })

    p "get relevant result:"
    p relevant_result

    relevant_result.each{
        |key|
        if !searched.has_key?( key )
            if !not_searched.has_key?( key )
                not_searched.merge!( { key=>true } )
                file.puts( key+"\n" )
                num -= 1

                if num == 0
                    return
                end
            end
        end
    }
    # pop one key that has not been searched
    key =  not_searched.shift()[0]
    p "Results left:" + num.to_s()
    p "next search: " + key

    # iteration( not recurse )
    ProliLoop( key, file, searched, not_searched, num )
end

def Prolifer( key, num, file_name )
    """
    only for a simpler API
    """
    file = open( file_name, "w")
    searched = { }
    not_searched = { }

    ProliLoop( key, file, searched, not_searched, num )

    file.close()
    searched = nul
    not_searched = nil
end

key = "克林顿"
num = 100000
file_name = "Bill Clinton.txt"
Prolifer( key, num, file_name )
