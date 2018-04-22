---
title: Ruby SSE Server 動手做
image: /images/push_server.jpg
thumb: /images/thumbs/push_server.jpg
date: 2015-11-05 01:10 +0800

tags: [Ruby, SSE, eventmachine]
description: 最近要蓋個 SSE 服務，筆者因貪一時方便就暫時使用 puma 在 Rails 上實現，但畢竟用執行緒解決長請求是很不妙的行為，這幾天就用 Ruby 開始徒手寫了 I/O multiplexing 伺服器，有種回到學生時代的感覺，只是 Ruby 只有 select()，少了 epoll()、kqueue() 很不方便，好在 eventmachine 背後使用的是 libev 和 libevent，有用到上述兩個系統調用，但筆者其實是最希望使用 libuv 呢（一副要逼人貢獻的節奏啊），另外一個方案是用 celluloid 替代 eventmachine，但前者在 I/O 的處理上[仍然使用 Kernel.select()，筆者也就作罷。
---

[SSE]: http://www.wikiwand.com/en/Server-sent_events
[puma]: https://github.com/puma/puma
[Hybrid Concurrency Patterns]: http://www.slideshare.net/KyleDrake/hybrid-concurrency-patterns
[使用异步 I/O 大大提高应用程序的性能]: http://www.ibm.com/developerworks/cn/linux/l-async
[Is it live?]: http://tenderlovemaking.com/2012/07/30/is-it-live.html
[Stream Updates with Server-Sent Events]: http://www.html5rocks.com/en/tutorials/eventsource/basics
[eventmachine]: https://github.com/eventmachine/eventmachine
[celluloid]: https://github.com/celluloid/celluloid
[libev]: http://software.schmorp.de/pkg/libev.html
[libevent]: https://github.com/libevent/libevent
[libuv]: https://github.com/libuv/libuv
[The C10K Problem]: http://www.kegel.com/c10k.html
[celluloid-io]: https://github.com/celluloid/celluloid-io
[actioncable]: https://github.com/rails/actioncable

**本篇文章同時也發表於 [CodeTengu](http://weekly.codetengu.com/)**

![](/images/push_server.jpg)

> 照片是日本硬體製造商 Speedlink 在東京舉辦的 server 投擲大賽，誰能把 server 推得最遠，可以得到最高的分數，圖片中的機器值 50 萬日幣，這也是名符其實的 push server，[影片在此](https://www.youtube.com/watch?v=A_j_iBH6wTI)。

最近要蓋個 [SSE] 服務，筆者因貪一時方便就暫時使用 [puma] 在 Rails 上實現，但畢竟用執行緒解決長請求是很不妙的行為，這幾天就用 Ruby 開始徒手寫了 I/O multiplexing 伺服器，有種回到學生時代的感覺，只是 Ruby 只有 `select()`，少了 `epoll()`、`kqueue()` 很不方便，好在 [eventmachine] 背後使用的是 [libev] 和 [libevent]，有用到上述兩個系統調用，但筆者其實是最希望使用 [libuv] 呢（一副要逼人貢獻的節奏啊），另外一個方案是用 [celluloid] 替代 [eventmachine]，但前者在 I/O 的處理上[仍然使用 `Kernel.select()`](https://github.com/celluloid/celluloid-io/blob/5e96845e68fdcd406717e3ab543b0099168a1c15/lib/celluloid/io.rb)，筆者也就作罷。

# Rails 即時串流

雖然以 Rails 時下的 HTTP server 方案，要做串流服務有點吃力，但要做也是可行的，串流功能在 Rails 4 後才開始支援，controller 需要 mix `ActionController::Live` 才可以使用 `response.stream`，建議可以參考 tenderlove 在 2012 寫的 [Is it live?]。

```ruby
class MyController < ActionController::Base
  include ActionController::Live

  def stream
    response.headers['Content-Type'] = 'text/event-stream'
    100.times {
      response.stream.write "hello world\n"
      sleep 1
    }
  ensure
    response.stream.close
  end
end
```

上述程式碼不至於難以理解，頂多注意要記得關掉 stream，否則打開的 socket 會一直開著直到海枯石爛，導致最系統上的檔案描述符被一堆死掉的 socket 佔用。

大家要更關注的應該是 HTML5 支援的 SSE 功能要怎麼在 Rails 上實現，當然我們可直接徒手寫：


```ruby
class MyController < ActionController::Base
  include ActionController::Live

  def index
    response.headers['Content-Type'] = 'text/event-stream'
    3.times {
      response.stream.write "event: time\ndata: #{Time.now}\n\n"
    }
  ensure
    sse.close
  end
end
```

在 `data` 部分是任意的字串，不過大部分的案例我們會使用 JSON，好讓 client 端可以更輕易取得資料，但這樣新版本的寫法會用到許多 `Hash#to_json` 或 `Array#to_json`，且徒手送出符合 SSE 規格的字串也很不方便，好在 Rails 也有 `ActionController::Live::SSE` 可以用：

```ruby
class MyController < ActionController::Base
  include ActionController::Live

  def index
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream, retry: 300, event: "event-name")
    sse.write({ name: 'John'})
    sse.write({ name: 'John'}, id: 10)
    sse.write({ name: 'John'}, id: 10, event: "other-event")
    sse.write({ name: 'John'}, id: 10, event: "other-event", retry: 500)
  ensure
    sse.close
  end
end
```

`ActionController::Live::SSE` 跟 tenderlove 在 2012 寫的版本大同小異，即便是在 Rails 4 上，也是一段不到 40 行的類別，目的是將 `#write` 方法包裝，讓本來只能寫入字串的 `#write`，變得可以傳入物件（大多情況下是 Hash 或是 Array 物件），片段程式碼：

```ruby
def write(object, options = {})
  case object
  when String
    perform_write(object, options)
  else
    perform_write(ActiveSupport::JSON.encode(object), options)
  end
end
```

## 別用 Rails 做 HTTP 推送服務

從以前工程師就在苦思如何在有限的運算單位與記憶體之下服務更多的訪客，Rails 的並行性目前已有許多方案，做法不外乎是用執行緒（puma）、行程（unicorn）或者兩者並行（rainbows、puma clustered mode），無論何者，每個連線都會佔用至少一個行程或是執行緒，直到 action 方法執行結束才會釋放資源。

這種架構適合運算密集的服務，通常一份 HTML 可以在 300ms 內傳輸完畢，I/O 佔用的時間很短，行程或執行緒可以很快被釋放；但如果是 I/O 密集的服務（例如串流服務），由於 I/O 佔用時間長，所以我們通常不會一些像是影片的大檔案放在 Rails 的 action 中去傳輸，而是丟到 public 目錄下或是 S3。

舉例如果有個影片需要 1 分鐘的下載時間，我們交給 Rails 去處理，且 puma 設定支援 32 個執行緒，那麼同一分鐘內只能有最多 32 人可以看影片，如果你要蓋一個 YouTube 或 RedTube，同一時間只能服務最多 32 人，會很不方便。

> 把執行緒限制調高到十萬？

調高到十萬並不是什麼好事，想像一下，一台機器有上萬個執行緒在跑，但是只有 4 顆處理器是個怎樣的情形，光是上下文交換就可以耗盡資源了，何況好不容易交換到某個執行緒，結果 I/O 太忙，連一個位元組也沒傳到就又被交換走了。

所以即便在 Rails 做 SSE 是如此容易，筆者也不會建議用 Rails 做 SSE，理由是支援 Rails 的 HTTP 伺服器，無論是 unicorn 或 puma 等皆然，它們每服務一個連線會佔用一個行程或是執行緒造成阻塞，此架構下不適合實作提供長久連線的服務（例如 push server 網路遊戲、聊天室等）。

# I/O Multiplexing 動手做

Ruby 內建相關的系統調用只有 `select()`，沒有 `epoll()`、沒有 `kqueue`，在阻塞方面也只有提供 `IO#read_nonblock` 和 `IO#write_nonblock`，沒有支援 AIO，在這樣的資源下，選用非同步阻塞的策略也是很合理的，筆者先後用原生 Ruby 做了第一個版本，再用 eventmachine 做了另外一個，程式碼如下：

## Kernel.select()

Ruby 有內建 `select()` 系統調用可以使用，但 `select()` 最大的弱點是受到 `FD_SETSIZE` 的限制，除非重新編譯內核，否則在許多 Linux 發行下預設是 1024，扣掉 server socket，只能服務 1023 個訪客，所以這段程式碼可用於學習，不建議用在產品中：

```ruby
require 'socket'

SERVER_SOCKET = TCPServer.new 'localhost', 3310
SOCKETS = [SERVER_SOCKET]

Thread.new do
  loop do
    clients = SOCKETS - [SERVER_SOCKET]
    clients.each do |socket|
      socket.send "event: time\ndata: #{Time.now}\n\n", 0
    end
    sleep 1
  end
end

# I/O loop
loop do
  # 這行是阻塞的，直到有任何一個檔案描述符狀態變成可讀或可寫，內核會主動通知
  ready_to_read, ready_to_write, in_error = select(SOCKETS, [], [])
  ready_to_read.each do |socket|
    case socket
    when SERVER_SOCKET
      client_socket, client_addrinfo = SERVER_SOCKET.accept
      SOCKETS << client_socket
      puts "connect: #{client_socket}"
    else # 若非 server 即 client socket
      begin
        socket.recv(1024)
        socket.send "HTTP/1.1 200 OK
Server: Ziltag Push Server
Content-Type: text/event-stream
Connection: keep-alive
Access-Control-Allow-Origin: *\n\n", 0
      rescue
        $stderr.puts $!, $@
        SOCKETS.delete(socket)
        puts "disconnect: #{socket}"
      end
    end
  end
end
```

如果你願意重編內核調高 `FD_SET_SIZE`，這個做法是滿足 C10K 的。

# eventmachine

可惜 `select()` 有諸多問題讓人們漸漸放棄使用，好在 eventmachine 使用 libevent，會根據作業系統去支援相對的系統調用，在 Linux 選用 `epoll()`，在 FreeBSD 選用 `kqueue()`，且提供了抽象的介面讓使用者可以輕易實作出 I/O 事件驅動的程式：

```ruby
require 'eventmachine'

class PushServer < EM::Connection
  @@clients = []

  def self.clients
    @@clients
  end

  def broadcast msg, slugs
    @@clients.each do |client|
      client.send_data msg
    end
  end

  def post_init
    @@clients << self
    puts "#{self} connected"
  end

  def receive_data data
    send_data "HTTP/1.1 200 OK
Server: Ziltag Push Server
Content-Type: text/event-stream
Connection: keep-alive
Access-Control-Allow-Origin: *\n\n"
  end

  def unbind
    @@clients.delete(self)
    puts "#{self} disconnected"
  end
end

EventMachine.run do
  EventMachine.add_periodic_timer(1) do
    PushServer.clients.each do |client|
      client.send_data "event: time\ndata: #{Time.now}\n\n"
    end
  end
  EventMachine.start_server '0.0.0.0', 3310, PushServer
end
```

eventmachine 在連線產生時，會去監聽該 socket 描述符，收到資料時會觸發 `#receive_data`，比起剛剛的 `select()` 實作，使用 eventmachine 會更容易維護，且可以輕易在 I/O 策略上做切換（例如在 `EventMachine.run` 之前先執行 `EventMachine.epoll`），很方便。

> 為何不用 celluloid？

celluloid 是為了解決 concurrent 問題而存在的，比起 eventmachine，他的應用層面更廣泛，因為在真實世界中遇到的問題不會只有 I/O 要處理，有些計算密集的程式用 thread 也許更有效率，所以 celluloid 的作者決定同時用了執行緒和 I/O multiplexing 兩種技巧去解決所有並行的問題，而 eventmachine 只是 celluloid 的其中一個擴展而已（[celluloid-io]）。

但筆者只是單純寫個 SSE 服務，用 eventmachine 就綽綽有餘了，即便 eventmachine 只用到一顆處理器，但多開幾個伺服器然後反向代理也是可以做到橫向擴展。

# 結論

Rails 不是萬靈丹，即便支援了串流功能，仍不適合做 I/O 密集的應用，不過 Rails 5 的 Action Cable 是可以期待一下，因為這東西使用的是 eventmachine 和執行緒，很適合用來維持大量的連線，不過這是為了 websocket 而寫，如果是要做 comet 的應用（長請求），最好另尋方法，使用 Rails 恐怕是繞遠路，以 Ruby 的方案來看，著名的專案就屬 eventmachine 與 celluloid。

<del>或者叛逃到 node 或 go 也行啦</del>

# 本文出現的連結

## 好文

- [SSE](http://www.wikiwand.com/en/Server-sent_events)
- [Hybrid Concurrency Patterns](http://www.slideshare.net/KyleDrake/hybrid-concurrency-patterns)
- [使用异步 I/O 大大提高应用程序的性能](http://www.ibm.com/developerworks/cn/linux/l-async)
- [Is it live?](http://tenderlovemaking.com/2012/07/30/is-it-live.html)
- [Stream Updates with Server-Sent Events](http://www.html5rocks.com/en/tutorials/eventsource/basics)

## 開原專案

- [puma](https://github.com/puma/puma)
- [The C10K Problem](http://www.kegel.com/c10k.html)
- [libev](http://software.schmorp.de/pkg/libev.html)
- [eventmachine](https://github.com/eventmachine/eventmachine)
- [celluloid](https://github.com/celluloid/celluloid)
- [libevent](https://github.com/libevent/libevent)
- [libuv](https://github.com/libuv/libuv)
- [celluloid-io](https://github.com/celluloid/celluloid-io)
- [actioncable](https://github.com/rails/actioncable)