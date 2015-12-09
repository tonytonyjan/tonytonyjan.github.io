---
title: PTT 每天自動登入小程式
image: /images/ptt.png
thumb: /images/thumbs/ptt.png
date: 2015-12-08 23:45 +0800
category: 程式
---

![](/images/ptt.png)

最近大選近了，八卦版似乎將發文門檻調高到了 1000 次，帶風向的黨工少了，頓時清新了許多（不過仍然影響不到筆者）。其實養 PTT 帳號不容易，因為同一天只算登入一次，我們得每天記得登入一次 PTT，否則就平白損失了24 小時，如果沒有 PTT 成癮症，其實很容易忘記。

而身為工程師如筆者，為了遵守 DRY 原則，就應該寫個小程式去自動化這份工作才是。當然自己徒手寫程式建立 socket 與 PTT 做溝通是最直覺的想法，只不過 TCP 牽線容易，後續的 IO 處理則頗麻煩，為了模擬真實的操作，必須根據 socket 送來的字串判斷現在是要我們寫入帳號密碼還是按下回車。

所幸這個問題在 1994 年就已經有人做出了專門的工具 `expect`，用來將互動式的 IO 介面自動化。例如 `apt-get install` 有時會被詢問一些是否覆蓋檔案或是安裝額外套件的問題，進而卡住，如果不用 `-y` 之類的旗標，也可以透過 `expect` 來實現。

寫腳本之前先確認 `expect` 的路徑：

```
$ which expect
/usr/local/bin/expect
```

`expect` 是基於 Tcl 的工具，意即 `expect` 腳本就是 Tcl 腳本，以下是用 `expect` 寫的 PTT 自動登入程式：

```tcl
#!/usr/local/bin/expect -f
set timeout 60
log_file -noappend $env(HOME)/log/ptt.log
spawn telnet ptt.cc
expect "new"
send "$env(PTT_ID)\r"
expect ":"
send "$env(PTT_PWD)\r"
expect {
  "您想刪除其他重複登入的連線嗎" {
    send "n\r"
    exp_continue
  }
  "請按任意鍵繼續" {
    send "\r"
    exp_continue
  }
  "批踢踢實業坊" {
    exit
  }
}
```

這裡要注意的是編碼問題，因為 PTT 是 BIG-5 編碼，直接在原始碼中放 UTF-8 的中文字串會導致誤判，筆者是先透過 `iconv -f UTF-8 -t BIG-5` 處理原始碼。

假設腳本命名為 ptt，使用方式為：

```
PTT_ID=PTT_帳號 PTT_PWD=PTT_密碼 ptt
```

至於每天都執行一次的任務，就交給 `crontab` 即可：


```
PATH=/path/to/ptt/bin
6 6 * * * LC_ALL=zh_TW.Big5 PTT_ID=帳號 PTT_PWD=密碼 ptt
```

大功告成！