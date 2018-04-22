---
title: "N-Gram 斷詞法實做"
date: 2012-06-06 17:59 +0800

tags: [Ruby]
---

今天心血來潮在 RubyGems 搜尋了一下看有沒有可用的 N-Grams library，確實也給我找到幾個，但可惜的是他們只有針對英文做斷詞，沒有針對中日韓。我們可想像的到英文的斷詞和中文的斷詞是截然不同的，但現在許多文章卻又中英日混雜，面對這種文章，那些 library 起不了什麼作用。

於是用下午的時間我就自己寫了一個來解決這類的問題：

<!-- more -->

``` ruby
module TJNGram
  def self.process n, content
    # matche Chinese, English, Japanes and Korean words
    pattern = %r((\w+)|([\u3041-\u9FFF]))
    # record if the token is an English word
    is_english = {}
    
    # tokenize
    tokens = []
    content.scan(pattern){|e,c|
      is_english[e || c] = e ? true : false
      tokens << (e || c)
    }
    
    resault = Hash.new(0)
    n.times{|i|
      tokens.each_slice(n){|slice|
        key = ""
        pre_state = nil
        slice.each{|token|
          key << " " if !pre_state.nil? && (pre_state || is_english[token])
          key << token
          pre_state = is_english[token]
        }
        resault[key] += 1
      }
      tokens.shift
    }
    resault
  end
end
```

*   [說明文件](/blog/tjngram)

演算法簡單，程式碼相當短，比較麻煩的地方在 pattern 裡頭，對於 unicode 範圍的定義花了點功夫去做調整，可濾掉標點符號（大部分，仍有落網之魚），只取出中日韓的單字和英文單字。

這段程式碼已經放在 [Github](https://github.com/tonytonyjan/TJNGram) 和 [RugyGems](https://rubygems.org/gems/TJNGram) 上面。