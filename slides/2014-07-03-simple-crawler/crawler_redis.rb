=begin
watch -n 0.1 redis-cli lrange my_queue 0 -1
redis-cli del my_queue
redis-cli rpush my_queue "http://tonytonyjan.net"
=end
require 'open-uri'
require 'nokogiri'
require 'redis'

REDIS = Redis.new
loop do
  uri = URI(REDIS.lpop(:my_queue)).normalize
  puts "POP: #{uri}"
  doc = Nokogiri::HTML(open(uri))
  a_tags = doc.css('a')
  a_tags.each do |a_tag|
    REDIS.rpush :my_queue, uri.merge(a_tag['href'])
    puts "PUSH: #{uri.merge(a_tag['href'])}"
  end
end