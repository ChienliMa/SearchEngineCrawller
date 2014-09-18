require './request'
require './parser'
require "thread"  

def FormatWrite(  key, titles, urls, file )
    """
    """
    file.puts( "KEY:"+key+"\n")

    (0 .. titles.length-1 ).each{
        | i |
        line = "TITLE:"+ titles[ i ] + "\n" + "URL:" + urls[ i ] + "\n"
        file.puts( line )
    }
end


def FetchResult( key, file)
    html = RequestHTML( key, 1 )
    titles, urls = GetSearchResult( html )
    FormatWrite( key, titles, urls, file )
end

def WriteOneResult( file_out, lock_out, key, titles, urls )
    """
    """
    lock_out.lock()
    FormatWrite( key, titles, urls, file_out )  
    lock_out.unlock()
end

def FetchOneKey( file_in, lock_in)
    """
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
    not used as a function
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
    note: here,file is filename
    work as its name
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

SearchCocurrently( "elong_relevance.txt", "elongsearchresult.txt", 10)