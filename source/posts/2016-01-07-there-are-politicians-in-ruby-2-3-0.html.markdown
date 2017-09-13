---
title: 對不起，我把馬英九放進 Ruby 2.3 了
date: 2016-01-07 23:27 +0800
category: 程式
tags: [馬英九, 連勝文, Ruby]
image: /images/ma.png
thumb: /images/thumbs/ma.png
description: 身為一個 Ruby 語言的教徒，這個聖誕節最令人興奮的莫過於 Ruby 2.3 的發表了，不過這次由於筆者的緣故，意外讓台灣的政治人物們走進了 Ruby 原始碼中，究竟是怎麼回事呢XD
---

![](/images/ma.png)

> 這世界所有升級到 Ruby 2.3 的伺服器，皆可以得到英九的庇佑。

身為一個 Ruby 語言的教徒，這個聖誕節最令人興奮的莫過於 [Ruby 2.3] 的發表了，不過這次由於筆者的緣故，意外讓台灣的政治人物們走進了 Ruby 原始碼中，究竟是怎麼回事呢XD

百聞不如一見，各位不妨可以先自己找看看：

```
$ curl -s https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.0.tar.gz | tar -xz
$ grep -hr -C 3 馬英九 ruby-2.3.0
def test_jarowinkler_distance_with_utf8_strings
  assert_distance 0.9818, '變形金剛4:絕跡重生', '變形金剛4: 絕跡重生'
  assert_distance 0.8222, '連勝文',             '連勝丼'
  assert_distance 0.8222, '馬英九',             '馬英丸'
  assert_distance 0.6667, '良い',               'いい'
end
```

# Did You Mean?

Ruby 2.3 新增了錯字校正功能，會在我們打錯字的時候提醒我們，例如將 `#byebug` 誤寫成 `#buybug`。在過去 Ruby 只會擲出 `NameError` 異常，並夾帶一串文字訊息，現在則除了擲出異常外，也會猜測你原本想輸入的文字：

```ruby
require 'byebug'
buybug
# NameError: undefined local variable or method `buybug' for main:Object
# Did you mean?  byebug
```

簡（煒航）言之這就是 Ruby 的 spell check 功能，是來自 [@yuki24] 製作的 Ruby gem [did_you_mean]，當 `NameError` 發生時，該 gem  會嘗試找出其他相似的字。


# Jaro-Winkler 距離

對於兩個字串之間的相似度的比對有許多相關的演算法，諸如 [Hamming]、[Levenshtein]、[Jaro-Winkler] 等，而對於短字串的比較尤以 Jaro-Winkler 普遍被認為較為精準。該演算法當初在醫療機構內，為了確認病患姓名而被發明出來的，如今卻已經在諸多領域中得到廣泛的使用，這也是 did_you_mean 所使用的核心算法。[在 Gemfile 中](https://github.com/yuki24/did_you_mean/commit/15f8b049ce2a04957d0975027f2cbf8e93b0ad59)能找到一段 [jaro_winkler] 的引用，這即是筆者的貢獻。

只是不料當 did_you_mean 被移植到 Ruby 時，連筆者寫下的支援 UTF-8 的測試也都[一併被移植過去了](https://github.com/yuki24/did_you_mean/blob/b2e4b3c590a2fd1b08f37a9d976e4dfe97533c68/test/edit_distance/jaro_winkler_test.rb)。

# 大選近矣

話說最近正逢總統大選，也發生一些趣事，有些國民黨的支持者在國民黨候選人的廣告上貼上馬英九的貼紙，聽說[就被移送法辦了](https://www.ptt.cc/bbs/Gossiping/M.1451986445.A.CF1.html)，後續如何筆者不是很清楚。但現在因為筆者的關係，讓世界上的許多人的伺服器硬碟的某處存著一個馬英九，希望筆者不會有什麼遭遇才是。萬一，哪天筆者再也沒有出現在臉書上，傳訊也沒回，請幫筆者轉達家母「我愛她」。另外不自殺聲明已經放在 Github 上了，萬一有不測，請幫筆者討回公道，萬分感謝！

話說回來，就算歐巴馬會寫程式好了，但不見得名字會在原始碼裡面呢，台灣是不是很厲害呢www

[Ruby 2.3]: https://www.ruby-lang.org/en/news/2015/12/25/ruby-2-3-0-released/
[did_you_mean]: https://github.com/yuki24/did_you_mean
[jaro_winkler]: https://github.com/tonytonyjan/jaro_winkler
[@yuki24]: https://twitter.com/yuki24
[Levenshtein]: https://www.wikiwand.com/en/Levenshtein_distance
[Jaro-Winkler]: https://www.wikiwand.com/en/Jaro%E2%80%93Winkler_distance
[Hamming]: https://www.wikiwand.com/en/Hamming_distance