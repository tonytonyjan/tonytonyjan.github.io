---
title: "漫畫下載器"
date: 2014-06-26 16:50:00 +0800
category: 程式
tags: Ruby
thumb: thumbs/comic.jpg
download: http://rubygems.org/gems/sfacg
github: https://github.com/tonytonyjan/sfacg_downloader
---

[Github 傳送門](https://github.com/tonytonyjan/sfacg_downloader)

筆者是個漫畫迷，其中最喜歡拜訪的網站莫過於[這家](http://comic.sfacg.com/)，但因為是網頁，在離線狀態就無法看了，加上最近的 Ruby 課程常放網頁爬蟲程式給學生當練習，於是這個 gem 就誕生了。

## 安裝

```bash
$ gem install sfacg
```

## 使用

下載海賊王 751 話

```
$ sfacg chapter http://comic.sfacg.com/HTML/OnePiece/751/
```

下載整部海賊王

```
$ sfacg comic http://comic.sfacg.com/HTML/OnePiece/
```

![](/images/sfacg.png)
![](/images/sfacg-2.png)