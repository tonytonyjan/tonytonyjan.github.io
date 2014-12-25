---
title: "將文章從 Wordpress 搬到 Octopress"
date: 2012-02-25 01:36 +0800
comments: true
tags: [Octopress, Wordpress]
category: 程式
---

[1]: http://cssula.twgg.org

今天心血來潮的，把以前在 [CSsula 機房][1]寫的文章全部搬到現在的 Octopress 了。我覺得比較麻煩的地方在於文章標題出現中文的時候，又沒有設定 post_name 時，就會以 `yyyy-mm-dd-中文字.markdown` 的格式儲存。而這個當然無解，只好手動一個一個改檔名了Orz

Wordpress 的的文章全部存在 wp_posts table 裡，如果要對應到，Octopress 的 yaml 設定的話，需要用到 post_title、post_date、post_content 這三個 column。其中 post_date 的資料型態是 datetime，我原本以為是字串導致運作時出了一點差錯:P

我寫了一個程式完成這項工作，他可以作到三件事情：

<!-- more -->

1. 把所有在資料庫中屬於我的文章，轉成檔案存至 _posts 資料夾
2. 在轉換過程中 wordpress 用到的圖片，下載下來，存至 images/cssula-blog 資料夾
3. 在轉換過程中將所有的 `<img src="">` 轉成 `![](/images/cssula-blog)`

這是我粗糙的程式碼，程式碼中大寫的部份可以改成別的資料，這東西可以寫得更完善，達到無痛搬家。我想如果網路上沒有開源項目，也許考慮奉獻看看（總之得先看看其他人怎麼寫吧）。

```ruby
# Ruby code to migrate from Wordpress to Octopress.
require 'mysql2'
require 'open-uri'

def create_post datetime, title, content
  date = datetime.strftime("%Y-%m-%d")
  time = datetime.strftime("%H:%M:%S")
  File.open("YOUR_OCTOPRESS_ROOT/source/_posts/#{date}-#{title}.markdown", "w"){|f|
    yaml = <<eos
---
title: "#{title}"
date: #{date} #{time}
comments: true
categories:
---

eos
    content.gsub!(/<img[^>]*src="([^"]*)"[^>]*>/i){|match|
      # open the image
      filename = nil
      open($1){|ff|
        filename = $1[/\/([^\/]*)$/, 1]
        # save image
        File.open("YOUR_OCTOPRESS_ROOT/source/images/cssula-blog/#{filename}", "wb"){|fff|
          fff.write(ff.read)
        }
      }
      # replace image tag into plugin style
      "![](/images/cssula-blog/#{filename})"
    }
    f.write(yaml+content)
  }
end

client = Mysql2::Client.new(
  :host => "YOUR_HOST",
  :username => "YOUR_USERNAME",
  :password=>"YOUR_PASSWORD",
  :database=>"YOUR_DATABASE_NAME"
)

client.query("select * from wp_posts where post_type='post' && post_author=3 && post_status='publish';").each do |row|
  begin
    create_post row["post_date"], row["post_title"], row["post_content"]
  rescue
    create_post row["post_date"], "Unknown title", row["post_content"]
  end
end
```

我在這邊提示一下我下的 query：

``` sql
select * from wp_posts where post_type='post' && post_author=3 && post_status='publish';
```

* `post_type='post'`一定要加上去，否則 page 和 revision 都會被挖出來
* `post_status='publish'` 則表示已發布的文章，如果你的草稿也想一起導入，就把這個拿掉，如果只想導入草稿則改成 `draft`
* `post_author=3` 表示只導出某個作者的文章。

