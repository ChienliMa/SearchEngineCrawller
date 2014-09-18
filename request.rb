require 'socket'

def RequestHTML( keyword, page )
    """
    @Params: keyword, page(start from 1)
    """
    p "Searching: "+ keyword
    # construct a http request
    http_request = "GET /s?wd=" + keyword +
                "&pn=" +(( page - 1) * 10).to_s + 
                " HTTP/1.0\r\nHost:www.baidu.com\r\n"+
                "is_xhr: 1\r\n"+
                "Connection:keep-alive\r\n\r\n"

    socket = TCPSocket.open( 'www.baidu.com', 80)
    socket.puts( http_request)

    html = ""
    while line = socket.gets
        html += line
    end
    
    socket.close
    return html
end