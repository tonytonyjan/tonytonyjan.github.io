---
title: "|=(2 影片下載器"
date: 2014-06-28 01:04:26 +0800
comments: true
category: Ruby
image: xxx-4.png
thumb: thumbs/fc2.png
---


標題已用 1337 低調處理XD，筆者很喜歡到某站看影片，由於篩選、排序功能需要付費，筆者甚至為此製作了一些工具達到一樣的目的，例如依照收藏次數、評價排序等。不過這次是要分享如何從網站下載一部影片。

## 瀏覽器下載法

其實有一招不用寫程式就可以下載影片，而且適用在所有影音網站。首先在點選播放影片以前，先把瀏覽器的開發者工具打開，接著點下播放，同時觀看 HTTP 的封包狀況，找到一個下載時間最長的請求，就是影片網址。

![](/images/xxx-1.png)

如圖所示，影片下載網址是：

```
http://vip.video54000.fc2.com/up/flv/201405/28/b/20140528bpRKSJWR.flv?mid=023358550acbb0cadcf93f50edcfaf5a
```

## 大量下載

但如果要大量下載影片的話，瀏覽器這招還是得徒手一個一個把影片點開，這是一件很累的事情，要是有個爬蟲可以幫我做這件事情豈不是很方便嗎？再回顧一下剛剛的網址，可以知道前半段並不難產生，而下載影片的最大重點就在後面的 `mid` 到底怎麼來。

只是這段 `023358550acbb0cadcf93f50edcfaf5a` 並沒有在頁面原始碼出現，所以我猜應該是透過網路取得的，幸運的是，沿著影片網址的請求往上找，確實給我找到了一個用來取得網址資訊的請求：

![](/images/xxx-2.png)

```
http://video.fc2.com/ginfo.php?from=28&otag=0&fversion=MAC%2014%2C0%2C0%2C125&mimi=c5e51ed4de1f4e6246b851bef4a210de&lang=tw&gk=uMuxgWhewb&tk=TlRBeU1qUTNNREE9&href=http%3A%2F%2Fvideo%2Efc2%2Ecom%2Ftw%2Fcontent%2F20140528bpRKSJWR&v=20140528bpRKSJWR&upid=20140528bpRKSJWR
```

得到的回應：

![](/images/xxx-3.png)

```
filepath=http://vip.video54000.fc2.com/up/flv/201405/28/b/20140528bpRKSJWR.flv&mid=023358550acbb0cadcf93f50edcfaf5a&sec=71&oref=0&charger=0&charge_second=&err_code=&isadult=0&count=&adreopen=600&cm=1&payment=0&mb_id=60283252&chk_ns=60_256&ci=&play_min=1&play_query=i:0;c:5;f:28;o:0;p:0;u:20140528bpRKSJWR;m:60283252;l:11&test=&ad=1
```

其中我要的東西就在這個回應裡面，只要把 `filepath` 和 `mid` 組起來就可以取得影片網址了。

## 分析變數

眼看就要成功了，接下來只要分析出 `/ginfo.php` 的變數怎麼製造即可。筆者是用 `curl` 做測試，發現上述的請求可以簡化，只保留 `mimi` 與 `upid` 這兩個變數：

```
$ curl "http://video.fc2.com/ginfo.php?mimi=c5e51ed4de1f4e6246b851bef4a210de&upid=20140528bpRKSJWR"
filepath=http://vip.video54000.fc2.com/up/flv/201405/28/b/20140528bpRKSJWR.flv&mid=bd8bf22fae4cba798ae0b028dabc4784&sec=71&oref=1&charger=0&charge_second=&err_code=&isadult=0&count=&adreopen=600&cm=0&payment=0&mb_id=&chk_ns=60_256&title=ブラッシングされたいの？&seek_image=3&play_min=1&play_query=i:0;c:5;f:;o:;p:0;u:20140528bpRKSJWR;m:;l:0&test=&ad=1
```

但這回用 `curl` 得到的 `mid` 不太一樣，且 `filepath` 與 `mid` 組起來的網址也無法丟到瀏覽器，
但是直接用 `curl` 是可以下載的，所以猜測 `mid` 的產生有用到 `User-Agent` 去做雜湊，於是筆者實驗性用了自己瀏覽器的 `User-Agent` 丟進 `curl`：

```
$ curl "http://video.fc2.com/ginfo.php?mimi=c5e51ed4de1f4e6246b851bef4a210de&upid=20140528bpRKSJWR" -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36'
filepath=http://vip.video54000.fc2.com/up/flv/201405/28/b/20140528bpRKSJWR.flv&mid=023358550acbb0cadcf93f50edcfaf5a&sec=71&oref=1&charger=0&charge_second=&err_code=&isadult=0&count=&adreopen=600&cm=0&payment=0&mb_id=&chk_ns=60_256&title=ブラッシングされたいの？&seek_image=3&play_min=1&play_query=i:0;c:5;f:;o:;p:0;u:20140528bpRKSJWR;m:;l:0&test=&ad=1
```

賓果，這下 `mid` 變數已經一樣了（`mid=023358550acbb0cadcf93f50edcfaf5a`），所以由此更可以確定，`mid` 的產生完全只有用到，`User-Agent` 而已，只要確保下載影片時候送出去的請求，其 `User-Agent` 保持一致就沒問題，至此可先鬆一口氣。

## Hacking

回到剛剛化簡的網址：

```
http://video.fc2.com/ginfo.php?mimi=c5e51ed4de1f4e6246b851bef4a210de&upid=20140528bpRKSJWR
```

`upid` 是很好產生的，不過 `mimi` 並沒有在網站原始碼出現過，且筆者也沒有在任何 HTTP 封包上找到線索。猜測剩下一種可能：這段變數是由 Flash 產生的。然後我翻翻，找到這個：

```as
public static function makeMimiLocal(_arg1:String):String{
  var _local2:String = "dEgEGrrGeegfe";
  var _local3:String = "gGddgPfeaf_gzyr";
  var _local4:String = "e_egeDEgggEfe";
  return (MD5(((_arg1 + "_") + _local3)));
}
```

看來這就是製造變數「咪咪」的配方了，試寫一下 Ruby 版本：

```ruby
def make_mimi(movie_id) # ex. 20140528bpRKSJWR
  # local2 = 'dEgEGrrGeegfe'
  local3 = 'gGddgPfeaf_gzyr'
  # local4 = 'e_egeDEgggEfe'
  Digest::MD5.hexdigest movie_id + '_' + local3
end
```

其中有兩個區域變數不知道要幹嘛，順手註解掉了。如果這段程式正確，那麼輸入 `20140528bpRKSJWR` 應該會得到一個 `c5e51ed4de1f4e6246b851bef4a210de` 才對：

```ruby
make_mimi '20140528bpRKSJWR' # => c5e51ed4de1f4e6246b851bef4a210de
```

做了一個下載器：

```
$ ruby mimi.rb 20140528bpRKSJWR
$ ls
20140528bpRKSJWR.flv mimi.rb
$ open 20140528bpRKSJWR.flv
```

![](/images/xxx-4.png)

收工，以後可以不用瀏覽器下載這個網站的影片了XD