require './request'
require './parser'
require 'builder'

key = "elong"

html = RequestHTML( key, 1 )
titles, urls = GetSearchResult( html )




    xml = Builder::XmlMarkup.new( :indent => 2 )
    xml.instruct! :xml, :encoding => "ASCII"

    xml.result( "key"=>key )
 p xml