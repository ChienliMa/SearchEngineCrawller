SearchEngineCrawler
==================
##parser.rb: 
    利用nokogiri进行html分析提取搜索结果和相关结果
##request.rb:
    使用socket发送http请求获得百度搜索结果
##xmlwriter.rb:
    实验中，将结果以html的方式写进文件，结构没想好
##proliferate.rb:
    给定种子关键词，自动以递归方式爬取相关搜索结果（百度最下面那一栏）
##multithread.rb:
    给定关键词，自动爬取第一页搜索结果的Title和URL，写入文件。可设定并发数目。


很水的一个东西，但是全都子功能写成了函数的形式（线程池除外），看得起就拿去用吧
##是的，说明文档目前烂的不行！
    等我看看Ruby说明文档是怎样的我加上去。