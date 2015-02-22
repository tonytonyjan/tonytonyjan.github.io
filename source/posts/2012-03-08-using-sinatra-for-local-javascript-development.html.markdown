---
title: "使用 Sinatra、HFS 在本地開發 Javascript"
date: 2012-03-08 14:16 +0800
category: 程式
tags: JavaScript
---

[HFS]: http://www.rejetto.com/hfs/
[Sinatra]: http://www.sinatrarb.com/
[EaselJS]: http://easeljs.com/

寫 Javascript 的時候難免會用到 AJAX 抑或讀檔，尤其現在 HTML5 正熱，常常需要讀取圖片並顯示在 canvas，但麻煩是，瀏覽器會為了安全考量，禁止所有對本地檔案系統的資料的存取（Chrome 自從版本 5 之後，擋住了所有對 `http://` 以外協定的 AJAX request，其中當然包括 `file://`）。

這個問題有個很直覺的解法，那就是自己開一個 HTTP server。但只是為了做前端網頁開發，搞個像 Apache 這種重量級的 server 豈不是用大砲打鳥蛋。所以介紹一下我個人在使用的兩個工具，一個是 [HTTP File Server][HFS] ，另一個則是 [Sinatra]。

<!-- more -->

## HFS（HTTP File Server）

[HFS] 是一套免費、開原的輕量級 HTTP server，顧名思義他可以讓你透過瀏覽器存取你電腦上的檔案，上傳、下載、而且有簡單的驗證與帳號控管。對共享檔案來說，遠比開一個 FTP server 來得更方便。且 [HFS] 不用安裝，方便攜帶，是出門在外、居家旅行的好夥伴。

說了這麼多廢話，當然，用來開發 Javascript 是很簡單的事，只要將程式碼所在的資料夾加入即可。附圖是我將 [EaselJS] 的範例程式碼所在資料夾放上去的結果。

![](/images/HFS.png)

## Sinatra

[Sinatra] 是一個為快速架設 web 應用而生的 DSL，他需要安裝 Ruby 才可以執行。簡言之我們其實可以把它和 Rails 歸在同一類，只是 [Sinatra] 是遠比 Rails 顯得更輕量級的 framwork。

1. 將你的網頁檔案丟到 `./public` 裡面

2. 建立並編輯檔案 `./serve.rb`（名字可以依自己喜好），加上一行 `require 'sinatra'`

3. 執行 `ruby serve.rb`（或者可寫成 batch 檔）

之所以要把東西放在 `./public`，是因為 [Sinatra] 的靜態網頁預設是對照 `./public`，你可以透過修改 `serve.rb` 來改變預設路徑，下面這個範例是將預設的靜態網頁目錄改為當前目錄：

``` ruby serve.rb
require 'sinatra'
set :public_folder, File.dirname(__FILE__) + '/.'
```

![](/images/sinatra.png)