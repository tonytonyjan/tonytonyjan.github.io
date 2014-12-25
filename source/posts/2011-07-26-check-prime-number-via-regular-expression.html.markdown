---
title: "正規表達式檢查質數"
date: 2011-07-26 17:57 +0800
comments: true
category: 程式
tags: 正規表達式, Regex, 質數, Regular Expression
---

``` plain The regex that can check if a number is prime
/^1?$|^(11+?)\1+?$/
```

Regular Expession 真的很強大，但是我還不曉得可以強大到用來檢查質數。

這是我在網路上看到[這一頁][1]，他竟然簡短的用 Regular Expression來檢查一個數字是否為質數，我覺得很有意思，於是放上來與大家分享。

<!-- more -->

``` perl Using perl
perl -wle 'print "Prime" if (1 x shift) !~ /^1?$|^(11+?)\1+$/' [number]
```

這個正規表達式的使用必須先把欲檢查的數字n，轉換成n個1，例如3換成111，5換成11111，再進行比對。

### 解析

```
/
^1?$  # ?表示"1"可以是0個或1個，所以對""以及"1"都可以比對成功
|     # 正規表達式的Or
^
 (
  1   # 1個"1"
  1+? # 1或更多個"1"，在"+"後的"?"表示取最短比對(non-greedy)，是關鍵所在
 )
 \1+  # "\1"表示第一個group，也就是前面括號裡的字串，並且這個group重複1到多次
$
/x
```

以下是我寫的兩個指令，可以不斷印出質數：

```
$ ruby -e 'i=0;("1"*i)=~/^1?$|^(11+?)\1+?$/ || print("#{i} ") while i+=1'
$ perl -e '$|++;(1 x$_)!~/^1?$|^(11+?)\1+$/&&print"$_ "while ++$_'
```
另外[這裡也有一篇][2]關於用正規表達式判斷一元二次方程式是否有解的文章。


[1]: http://montreal.pm.org/tech/neil_kandalgaonkar.shtml
[2]: http://blog.stevenlevithan.com/archives/algebra-with-regexes