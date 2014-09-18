require './request'
require './parser'
require "thread"  

def FormatWrite(  key, titles, urls, file )
    """
    Write sth. into some file.
    This is rubbish
    """
    file.puts( "KEY:"+key+"\n")

    (0 .. titles.length-1 ).each{
        | i |
        line = "TITLE:"+ titles[ i ] + "\n" + "URL:" + urls[ i ] + "\n"
        file.puts( line )
    }
end


def FetchResult( key, file )
    """
    As you can see
    """
    html = RequestHTML( key, 1 )
    titles, urls = GetSearchResult( html )
    FormatWrite( key, titles, urls, file )
end

def WriteOneResult( file_out, lock_out, key, titles, urls )
    """
    As you can see. ( with lock here )
    """
    lock_out.lock()
    FormatWrite( key, titles, urls, file_out )  
    lock_out.unlock()
end

def FetchOneKey( file_in, lock_in)
    """
    As you can see.
    """
    lock_in.lock()
    key = file_in.gets()
    lock_in.unlock()
    if key == nil
        return key
    else
        return key.strip()
    end
end


def SingleThreadSearcher( file_in, file_out, lock_in, lock_out )
    """
    : Auxilary method : 
    Fetch one key from file and write relevant key 
    to another file.  Execute until we reach the end of input file.
    """
    key = FetchOneKey( file_in, lock_in )

    while key
        html = RequestHTML( key, 1 )
        titles, urls = GetSearchResult( html )
    
        WriteOneResult( file_out, lock_out, key, titles, urls )
        key = FetchOneKey( file_in, lock_in )
    end # while
end # SingleThreadSearch

def SearchCocurrently( name_in, name_out, thread_num )
    """
    Cocurrently fetch search result from baidu.
    : Param name_in : Name of file which contains keys
    : Param name_out : Name of file to whom this method write
    : Param thead_num : number of thread work corruently
    """
    file_in = open( name_in )
    file_out = open( name_out, "w" )
    lock_in = Mutex.new()
    lock_out = Mutex.new()

    thread_pool = []
    thread_num.times{
        |i|
        p "start " + ( i + 1 ).to_s + "th thread"
        # next 3 lines are very awful
         t =  Thread.new(file_in, file_out, lock_in, lock_out){
            |file_in, file_out, lock_in, lock_out|
            SingleThreadSearcher( file_in, file_out, lock_in, lock_out )
            } #
        thread_pool+=[t]
    } #
    thread_pool.each{ |i| i.join()  }

end

=begin
Example of how to use this:
SearchCocurrently( "elong_relevance.txt", "elongsearchresult.txt", 10)
=end
