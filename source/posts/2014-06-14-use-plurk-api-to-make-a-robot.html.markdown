---
title: "噗浪機器人製作"
date: 2014-06-14 14:58:31 +0800
comments: true
tags: [Works, Ruby]
category: 程式
---

## 回聲蟲示範

以下這段程式碼的功能即是在自己河道上只要聽到有人發新噗，立即回應一模一樣的內容給噗主。

```ruby
require 'tjplurk'

api = Tjplurk::API.new CONSUMER_KEY, CONSUMER_SECRET, TOKEN_KEY, TOKEN_SECRET
api.real_time do |plurk|
  if plurk['type'] == 'new_plurk'
    params = {
      plurk_id: plurk['plurk_id'],
      content: plurk['content_raw'],
      qualifier: ':'
    }
    api.request '/APP/Responses/responseAdd', params
  end
end
```

且聽筆者逐行解釋：

```ruby
require 'tjplurk'
```

這是一個最近才出現的 Ruby Gem，被實際應用在一隻叫[小兜蟲](http://dodo.brainana.com/)的噗浪機器人上，是 [Plurk API](http://www.plurk.com/API) 的包裝，也提供指令式的方式使用（稍後會提到），輸入 `gem install tjplurk` 即可安裝。

Github：https://github.com/tonytonyjan/tjplurk

文件：https://github.com/tonytonyjan/tjplurk/blob/master/README.zh-TW.md

```ruby
api = Tjplurk::API.new CONSUMER_KEY, CONSUMER_SECRET, TOKEN_KEY, TOKEN_SECRET
```

![](/images/plurk_app.png)

初始化，後面四個參數看起來嚇人，但也不至太難取得，請到[這裡](http://www.plurk.com/PlurkApp/)申請噗浪應用，隨即可以取得 consumer key 與 concumer secret。

至於 token key、token secret，可以透過噗浪的「測試工具」或是 tjplurk 內建的指令取得。

```ruby
params = {
  plurk_id: plurk['plurk_id'],
  content: plurk['content_raw'],
  qualifier: ':'
}
api.request '/APP/Responses/responseAdd', params
```

鑑於這行比較簡明，先跳來解釋，`Tjjplurk::API#request` 會送出一個 `POST` 請求到噗浪，第一個參數是 API 路徑，第二個則是該 API 需要的參數。

可以參考噗浪官方的 [API 文件](http://www.plurk.com/API#/APP/Responses/responseAdd)，以此為例 `/APP/Responses/responseAdd` 需要三個必填的參數：`plurk_id`、`content`、`qualifier`。

```ruby
api.real_time do |plurk|
...
end
```

這段是噗浪[河道實況](http://www.plurk.com/API#realtime)的 API 包裝，利用 comet 技巧來實現，回傳的東西會長得像這樣：

```json
{"new_offset": 27, "data": [...]} 
```

其中 `data` 裡面放的是「噗」陣列，也就是 `Tjplurk::API#real_time` 所迭代的內容。有兩種類型，分別是 `new_plurk` 和 `new_response`（格式請見文末附錄，因為噗浪並沒有詳細的官方文件）。

之所以會有 `if plurk['type'] == 'new_plurk'`，是為了避免回聲蟲暴走，見到新的回應也回。

## 指令

```bash
$ tjplurk help
Commands:
  tjplurk api PATH ["FOO=BAR" ...]           # 發送 API 請求
  tjplurk auth CONSUMER_KEY CONSUMER_SECRET  # 互動的方式取得 Access Token
  tjplurk help [COMMAND]                     # 說明
```

第一步先用 `tjplurk auth` 取得授權

```bash
$ tjplurk auth CONSUMER_KEY CONSUMER_SECRET
Authorize URL: http://www.plurk.com/OAuth/authorize?oauth_token=Reqj6s1zowzn
Enter Verification Number: 405603
Key & secret successfully saved to "/Users/tonytonyjan/.tjplurk".
```

注意這裡有個檔案叫 `.tjplurk` 被存在家目錄下，裡面只放了 4 筆資料：`CONSUMER_KEY`、`CONSUMER_SECRET`、`TOKEN_KEY` 和 `TOKEN_SECRET`。而 `Tjplurk::API.new` 如果不傳參數，預設也會去找這個檔案。若有特別指定檔案位置，可以設定環境變數 `TJPLURK_FILE`：

```bash
$ export TJPLURK_FILE=/path/to/file
```

接下來就可以盡情的使用了：

```bash
$ tjplurk api /APP/Users/me
$ tjplurk api /APP/Timeline/plurkAdd "content=hello world" qualifier=says
```

這個指令都會回傳 JSON 格式，需要的話也可以 pipe 到別的工具做使用。例如下面的例子是印出漂亮的 JSON：

```bash
$ tjplurk api /APP/Users/me | ruby -rjson -e 'jj JSON.parse ARGF.read'
```

## 附錄

### new_plurk

```json
{
  "replurkers": [

  ],
  "responses_seen": 0,
  "qualifier": ":",
  "replurkers_count": 0,
  "replurker_id": null,
  "response_count": 0,
  "anonymous": false,
  "replurkable": false,
  "limited_to": "|7910597||5874158|",
  "id": 1216516571,
  "favorite_count": 0,
  "is_unread": 0,
  "lang": "tr_ch",
  "favorers": [

  ],
  "content_raw": "test",
  "user_id": 5874158,
  "plurk_type": 1,
  "replurked": false,
  "favorite": false,
  "no_comments": 2,
  "content": "test",
  "plurk_id": 1216516571,
  "posted": "Sat, 14 Jun 2014 04:21:29 GMT",
  "type": "new_plurk",
  "owner_id": 5874158
}
```

### new_response

```json
{
  "plurk_id": 1216516326,
  "response_count": 1,
  "response": {
    "lang": "tr_ch",
    "content_raw": "TEST",
    "user_id": 5874158,
    "qualifier": ":",
    "plurk_id": 1216516326,
    "content": "TEST",
    "id": 5993521307,
    "posted": "Sat, 14 Jun 2014 04:19:52 GMT"
  },
  "user": {
    "5874158": {
      "verified_account": true,
      "default_lang": "tr_ch",
      "display_name": "大兜:職業學生",
      "uid": 5874158,
      "dateformat": 0,
      "nick_name": "tonytonyjan",
      "has_profile_image": 1,
      "date_of_birth": "Thu, 23 Nov 1989 00:01:00 GMT",
      "karma": 124.39,
      "gender": 1,
      "name_color": "2264D6",
      "recruited": 5,
      "id": 5874158,
      "avatar": 82
    }
  },
  "type": "new_response",
  "plurk": {
    "replurkers": [

    ],
    "responses_seen": 0,
    "qualifier": ":",
    "replurkers_count": 0,
    "replurker_id": "",
    "response_count": 1,
    "replurkable": false,
    "limited_to": "|7910597||5874158|",
    "id": 1216516326,
    "favorite_count": 0,
    "is_unread": 0,
    "lang": "tr_ch",
    "favorers": [

    ],
    "content_raw": "TEST",
    "user_id": 5874158,
    "plurk_type": 1,
    "replurked": false,
    "favorite": false,
    "no_comments": 2,
    "content": "TEST",
    "plurk_id": 1216516326,
    "posted": "Sat, 14 Jun 2014 04:19:21 GMT",
    "owner_id": 5874158
  }
}
```