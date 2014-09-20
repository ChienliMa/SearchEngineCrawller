require './request'
require './parser'
require "thread"  

def FormatWrite( file, key, titles, urls )
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

def WriteOneResult( file_out, result )
    """
    As you can see. ( with lock here )
    """
    key, titles, urls = result
    FormatWrite(  file_out, key, titles, urls )  
end

def WriteResults( file_out, results )
    """
    New veision of write one result
    as you can see
    """
    results.each{
        |result|
        WriteOneResult( file_out, result )
    }
end

def FetchOneKey( file_in )
    """
    As you can see.
    """
    # file.gets() seems to be an atomic operation
    # so we don't need to lock here
    key = file_in.gets()

    if key == nil
        return key
    else
        return key.strip()
    end
end


class Searcher
    @file
    @cache
    
    @num_of_result
    @capability

    @full_flag = false
    @clean_flag  = false
    @work_finished_flag = false

    def initialize( file_in, capability)
        @cache = []
        @file = file_in
        @capability = capability
        @num_of_result = 0
    end

    def mission( )
        key = FetchOneKey( @file )
        while key
            # if data in cache has been tooken away, clear the cache
            if @clean_flag
                @full_flag = false
                @num_of_result = 0
                @cache = []
            end

            html = RequestHTML( key, 1 )
            this_titles, this_urls = GetSearchResult( html )
            @cache += [ [ key, this_titles, this_urls] ]
            @num_of_result += 1
            # if cache is full, set flat
            if @num_of_result >= @capability
                @full_flag = true
            end

            key = FetchOneKey( @file )
        end # while
        @work_finished_flag = true
    end # mission

    def HandinResult()
        """
        """
        cache_clone  = @cache.clone()
        @clean_flag = true  
        return cache_clone
    end  # HandinResult

    def isFull()
        return @full_flag
    end

    def isFinished()
        return @work_finished_flag
    end

end # SingleThreadSearch

class GroupSearch
    @file_in 
    @file_out 
    @num_of_searcher 
    @worker_capacity 
    @group_of_worker 
    @group_of_mission
    @leader 

    def initialize( name_in, name_out, num_of_searcher , worker_capacity )
        """
        """
        @file_in = open( name_in, "r" )
        @file_out  = open( name_out, "w")
        @num_of_searcher = num_of_searcher
        @worker_capacity = worker_capacity
        @group_of_worker = []
        @group_of_mission = []
    end

    def leader_mission( scan_frequency = 0.5 )
        """
        Periodly check if workers' cache is full.
        If full, copy the cache and write into the file
        """
        finish_flag = false
        while 1
            @group_of_worker.each{ | worker |                
                if worker.isFull()
                    WriteResults( @file_out, worker.HandinResult() )
                end

                if worker.isFinished()
                    finish_flag = true
                    break
                end
            } # @group_of_worker.each
            sleep( scan_frequency )

            if finish_flag
                break
            end
        end # while

        # work are finished, clear workers' cache
        @group_of_worker.each{ |worker| 
                titles, urls = worker.HandinResult() }
    end # leader_mission

    def start_working()
        """
        start the oprk
        """
        @num_of_searcher.times{  | i |
            # add worker
            w = Searcher.new( @file_in, @worker_capacity )
            @group_of_worker += [ w ]

            # start mission
            t =  Thread.new(){  w.mission() } 
            @group_of_mission += [ t ]

            p  ( i + 1 ).to_s + "th worker start woking"
        } #
        @group_of_mission.each{ |i| i.join()  }

        # start supervioniong mission
        @leader  = Thread.new(){ ||  leader_mission() }
        @leader.join()

    end # start_working

    def terminate_work()
        """
        Terminate the work. Once stop you can not restart it again
        un implenmented
        """
    end

end # GroupofWorker

=begin
Example of how to use 
group = GroupSearch.new( "Bill Clinton.txt", "Result.txt", 5, 5)
group.start_working()
=end