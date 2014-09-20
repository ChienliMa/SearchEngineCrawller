# -*-coding:utf-8-*-
require 'nokogiri'
require './request'

def GetRelevantResult( html )
    """
    : Param html : HTML Doc of the page you want to parse,
    currently we can only parse the result of baidu
    : Type html : String

    @Return:
    Array of relecant results
    """
    page = Nokogiri::HTML( html )
    rs = []
    # each page has 9 relevant result
    (0..8).each{
        |index|
        has_rs = page.css("div#rs").css("table").css("a")[index]        
        # in case there is no relevant result
        if has_rs
            rs += [ has_rs.text ]
        end
    }
    return rs
end

def GetSearchResult( html )
    """
    : Param html : HTML Doc of the page you want to parse,
    currently we can only parse the result of baidu
    : Type html : String

    @Return : 
    Two arrays of strings : titles and urls 两边是对应的，恩
    """
    page = Nokogiri::HTML( html)
    titles = [ ]
    urls = [ ]
    # each page has no more than10 result, usually
    ( 1 .. 10 ).each{ 
        |index|
        # only take the 1st part so we will exclude the little
        # blue button link to the offcial website
        begin
            a_tag =  page.css("div#wrapper_wrapper").css("div#container")\
                                    .css("div#content_left").css( "div#" + index.to_s )\
                                    .css("h3").css("a")[0]
            
            title = a_tag.text
            url = a_tag[ 'href' ]
            # cut the str "//" or "http://" at the beginning
            url_cut_length = /([http:]{5}?\/\/)/.match( url )[ 0 ].length
            url =  url[ url_cut_length, url.length ]
            if title != nil && url != nil
                titles += [ title ]
                urls += [ url ]
            end
        rescue  Exception
            p "miss one result" 
        end
    }

    return titles, urls
end
