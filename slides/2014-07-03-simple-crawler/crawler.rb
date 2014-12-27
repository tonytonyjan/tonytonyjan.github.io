=begin
watch -n 0.1 redis-cli lrange url_queue 0 -1
redis-cli del url_queue
立法院會議預報
redis-cli rpush url_queue "http://www.ly.gov.tw/01_lyinfo/0109_meeting/meetingList.action"
卡提諾小說
redis-cli rpush url_queue "http://ck101.com/forum.php?mod=forumdisplay&fid=855&filter=typeid&typeid=1073"
=end
require 'nokogiri'
require 'open-uri'
require 'redis'

QUEUE_NAME = :url_queue
CSS = '#item > tbody > tr > td:nth-child(4) > a,.pagelinks > a:nth-last-of-type(2)'
# CSS = 'tr > th.subject > a,#fd_page_top > div > a.nxt'
REDIS = Redis.new

Signal.trap('INT') { $exit = true}
Signal.trap('TERM'){ $exit = true}
loop do
  sleep 1 until url = REDIS.lpop(QUEUE_NAME) || $exit
  exit if $exit
  uri = URI(url).tap(&:normalize!)
  puts "POP:  #{uri}"
  begin
    doc = Nokogiri::HTML(open(uri))
    REDIS.set "page:#{uri}", doc
    links = doc.css(CSS).map{|anchor| uri.merge(anchor['href']) }
    links.each{|link| REDIS.rpush QUEUE_NAME, link; puts "PUSH: #{link}" }
  rescue
    puts $!.inspect, $@
    REDIS.rpush QUEUE_NAME, url
  end
end