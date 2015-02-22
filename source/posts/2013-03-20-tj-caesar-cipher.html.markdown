---
title: "凱薩密碼中文版"
date: 2013-03-20 16:33 +0800
category: 程式
tags: Ruby
---

靈感是受到凱薩密碼的影響，且英文論壇中為了避免髒話或敏感詞彙被擋，有 rot13 的出現（其實就是凱薩加密，key 設定成 13，所以 rot13 兩次會等於原來的句子）。想說中文也可這樣玩，所以決定寫一個全世界最沒用的玩具。

## 安裝

    gem install tj_caesar_cipher

## 使用

``` ruby
    require 'tj_caesar_cipher'
    s1 = TJCaesarCipher.new("tonytonyjan")
    # => "tonytonyjan" 
    s1.rot_en! # 預設就是 rot13
    # => "gbalgbalwna" 
    s1.rot_en! # 再執行一次就會恢復原狀
    # => "tonytonyjan" 
    s1.rot_en(12) # 也可以給不同的 key
    # => "gbalgbalwna" 

    s2 = TJCaesarCipher.new("我是厲鬼，不是大神")
    # => "我是厲鬼，不是大神" 
    s2.rot_cjk!
    # => "諸輖粙牕，直輖舎偷" 
    s2.rot_cjk!
    # => "我是厲鬼，不是大神" 
    s2.rot_cjk(1)
    # => "戒昰厳鬽，与昰夨祟"
```

如果你好奇中文版的 rot13 到底怎麼作到的……

    ...
    def rot_cjk! key = nil
      [
        (0x3040..0x309F),   # Hiragana
        (0x30A0..0x30FF),   # Katakana
        (0x3400..0x4DB5),   # CJKUI Ext A block
        (0x4E00..0x9FCC),   # CJK Unified Ideographs block
        (0x20000..0x2A6D6), # CJKUI Ext B block
        (0x2A700..0x2B734), # CJKUI Ext C block.
        (0x2B740..0x2B81D)  # CJKUI Ext D block.
      ].each{|range|
        range = (range.min..range.max+1) if range.count.odd?
        self.rot_unicode!(key || range.count/2, range)
      }
      self
    end
    ...

以上XD
