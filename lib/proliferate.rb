#-*- coding:utf-8 -*-
require './request'
require './parser/'

def ProliLoop( key, file, searched, not_searched, num )
    """
    =Auxiliary method , you should never use this
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

    # 递归。我对递归学的不好，
    # 这样递归的话是不是每次递归都会把两张哈系表压栈？
    # 如果是的话可以考虑这两个用全局变量吧。
    ProliLoop( key, file, searched, not_searched, num )
end

def Prolifer( key, num, file_name )
    """
    : Param Key : Keyword used as seed 
    : Type Key : String

    : Param num : The number of relevant result you want
    : Type num : Integer

    : Param file_name : Name of output File( Or with abs path )
    : Type file_name : String
    """
    file = open( file_name, "w")
    searched = { }
    not_searched = { }

    ProliLoop( key, file, searched, not_searched, num )

    file.close()
    searched = nul
    not_searched = nil
end

=begin
Example of how to use:
{
    key = "克林顿"
    num = 100000
    file_name = "Bill Clinton.txt"
    Prolifer( key, num, file_name )
}
=Current Problem:
    1.运行一段时间后会出现连续几十个key找不到结果，程序会自动忽略。
        目前不知道为什么，有空再改进，自动retry。
        
    2.运行一段时间后无法获得相应，不知道是不是百度的问题，
        或者是程序问题（毕竟是递归）。目前最多一次获得了3000多关键词
=end

key = "克顿"
    num = 100
    file_name = "Bill Clinton.txt"
    Prolifer( key, num, file_name )
