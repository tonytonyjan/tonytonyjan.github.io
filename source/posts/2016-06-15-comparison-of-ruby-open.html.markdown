---
title: Ruby#open 知多少？
date: 2016-06-15 00:12 +0800

tags: [Ruby]
description: 使用 Ruby 光是開個檔案描述符就有數幾種方法，令人眼花撩亂，常看到的是有人用同一招打天下，卻一直沒有去了解其他的方法與其是用情境，有些可惜，而這篇文章將透過由下而上的方式，一一介紹、示範它們的差別和使用。
image: /images/io.jpg
thumb: /images/thumbs/io.jpg
---

**本文同步發表於 [alphacamp](https://blog.alphacamp.co/2016/06/30/ruby-open/)**

![](/images/io.jpg)

先來個快問快答吧：

> 如果現在要你使用 Ruby 去開檔，你會想到怎麼做？

直覺是使用 `File.open`，但想想 `File.new` 似乎也可行，然後又發現不使用 `File` 類別，直接用 `open` 也能做到一樣的事。去查了 Ruby 文件結果發現 `IO.open` 和 `IO.new` 也能做到同樣的操作。

如你所見，使用 Ruby 光是開個[檔案描述符]（以下簡稱 FD）就有數幾種方法，令人眼花撩亂，常看到的是有人用同一招打天下，卻一直沒有去了解其他的方法與其是用情境，有些可惜，而這篇文章將透過由下而上的方式，一一介紹、示範它們的差別和使用。

# IO.new

`IO` 類別是 Ruby 對 FD 進行讀寫操作的一切基礎，我們可以用 `File` 來操作是因為 `File` 繼承自 `IO`，只是稍嫌麻煩些。

`IO.new` 的第一個參數必須是 FD，或在 Windows 下則稱 [句柄]，無論何者都只是一個數字。

如果你已知標準輸入與標準輸出的檔案描述符分別為 `0` 和 `1`，不妨實驗一下：

```ruby
stdin = IO.new(0)
stdout = IO.new(1)
stdout.puts "what's your name?"
name = stdin.gets.chomp!
stdout.puts "hello, #{name}!"

# what's your name?
# tony
# hello, tony!
```

另外可用 `IO.sysopen` 來取得檔案的 FD，這其實就是 `File` 類別的做法，`File` 只是隱藏此細節罷了：

```ruby
fd = IO.sysopen('file.txt', 'w') #=> 3
io = IO.new(fd)
io.puts 'hello!'
io.close
```

另一個例子是透過 `/dev/tty` 寫到終端：

```ruby
fd = IO.sysopen('/dev/tty', 'w')
io = IO.new(fd,'w')
puts 'Hello'
io.puts 'World'
io.close

# Hello
# World
```

筆者在這裡提醒要小心選擇正確的 tty 檔案，萬一不慎選到其他使用者的，執行上述程式碼就會在他人的終端畫面上印出一堆垃圾。

如果對 tty 的概念不熟悉，可以參考[這篇文章][tty]，在 UN*X 的世界裡面，所有裝置都是一個檔案，終端也是一個檔案，自然可以像檔案一樣對其進行讀寫。

# IO.open

`IO.open` 沒什麼新奇之處，它只是 `IO.new` 加上 block 的擴充版本，若無使用 block 時，與 `IO.new` 無異，最後會回傳 `IO` 物件；但若與 block 使用，有兩個特點：

1. `IO` 物件會在 block 結束時被自動關閉（意即不需要寫 `IO#close`）。
2. `IO.open` 最後回傳的不再是 `IO` 物件，而是 block 的最後執行結果。

# IO.popen

有曾好奇過市面上的 CI 是怎麼做到即時顯示終端上的文字嗎？以 Travis CI 為例，下圖那塊黑色區塊中的內容是即時輸出的：

![](/images/travis.png)

或者曾想過在自己的網站上執行外部的指令，並且即時呈現給使用者呢？若你有在 Ruby 中呼叫其他系統指令的經驗（例如 `ls`、`cat`、`bundle install` 等等），那應該對 `system`、`%x{}` 或是 ``` `` ``` 不陌生：

```ruby
system 'date' # => true, false or nil
%x{date}      # => the standard output of the running cmd
`date`        # => as above
```

然而 `system` 只根據指令執行結果成功與否回傳布林值，無法直接存取子程序輸出的結果；`%x{}` 會以字串形式回傳結果，但必須等到子程序執行結束後才會回傳整個字串，無法即時監控子程序的標準輸出。

相較於 `%x{}` 回傳完整的字串，`IO.popen` 則是回傳 `IO` 物件。為了比較出差異，這裡就拿 `ping` 指令為例，因為該指令會不斷在終端畫面上輸出訊息，直到使用者手動停止，如果使用 `%x{}` 的話，Ruby 程式將會卡在該處，且因準備要回傳的字串越來越長，最後導致記憶體不夠用或程式會卡到海枯石爛。

相較下操作 `IO` 物件就可以一次讀一行：

```ruby
# puts %x{ping www.alphacamp.co} # don't do this
io = IO.popen('ping www.alphacamp.co')
while line = io.gets
  print line
end
# PING www.alphacamp.co (198.41.206.122): 56 data bytes
# 64 bytes from 198.41.206.122: icmp_seq=0 ttl=58 time=2.794 ms
# 64 bytes from 198.41.206.122: icmp_seq=1 ttl=58 time=4.876 ms
# 64 bytes from 198.41.206.122: icmp_seq=2 ttl=58 time=7.081 ms
# ...
```

當然這還離真正做出一個在網頁上呈現終端執行畫面的功能還很遠，例如上述的程式碼卡在一個無窮迴圈裡面，
你可能會想針對 IO 阻塞問題做出一些改善，像是配合 `IO.select` 或是 `IO#read_nonblock` 等，但純屬延伸議題，不在本章範圍，有機會筆者會在另一篇章中分享怎麼做到 :)

# File.new 與 File.open

這兩個方方法就是大家耳熟能詳的開檔方案了，它們和 `IO.new` 與 `IO.open` 幾乎一樣，只差在覆寫了 `initialize` 方法，使其接受的參數不再是 FD 而是檔案的路徑字串。`File.new` 回傳值也和 `IO.new` 一樣是 `IO` 物件；在 `File.open` 與 block 同時使用的情況下也和 `IO.open` 一樣，會自動關檔，且回傳 block 的最後執行結果。

# Kernel.open

`Kernel.open` 大概是最萬用的方法了，留在最後講是因為它是 `IO.popen` 與 `File.open` 的合體，除此也接受擁有 `#to_open` 方法的物件。

當傳入一個物件給 `Kernel.open` 時，處理的優先續如下：

1. 檢查該物件是否有 `#to_open` 方法，有則直接呼叫以取得 `IO` 物件。
2. 如果物件是字串且開頭是 `|`，則去掉 `|`，剩下丟給 `IO.popen` 處理。
3. 最後交給 `File.open` 處理

## to_open

關於 `#to_open` Ruby 文件上沒有一處提及，只記載在 Ruby 原始碼中。實作的時候必要回傳 `IO` 物件即可：

```ruby
class Foo
  def to_open
    puts 'Foo#to_open is here'
    File.open('test.txt') # => IO instance
  end
end

open Foo.new do |io|
  # ...
  # io will be closed automatically
end
```

# 該用哪個？

這沒有什麼強制的規範，畢竟 Ruby 是一個自由的程式語言，比較接近 Perl，和一板一眼的 Python 不太一樣（Only one way to do it）。不過筆者建議大原則是盡量使用易讀易寫的 API 來完成工作，如果有細節需要處理再用其他的方法。例如一般開檔就使用 `File.open` 或是 `Kernel.open` 即可，需要存取 FD 則改用 `IO.open`，若要手動關檔再考慮 `File.new` 或 `IO.new`。另外也不要特別使用 `Kernel.open` 調用 `IO.popen` 的奇怪語法（`|`），這會降低程式碼的可讀性，不符合易讀易寫。像 `IO.popen('date')` 就比 `Kernel.open('|date')` 好懂多了。

另一個原則是程式碼的一致性，如果團隊開檔案都使用 `File.open`，那就盡量避免特立獨行使用 `Kernel.open`，反之亦然。

[檔案描述符]: https://zh.wikipedia.org/zh-tw/%E6%96%87%E4%BB%B6%E6%8F%8F%E8%BF%B0%E7%AC%A6
[句柄]: https://zh.wikipedia.org/zh-hant/%E5%8F%A5%E6%9F%84
[tty]: http://tldp.org/HOWTO/Text-Terminal-HOWTO-7.html
