---
title: "Ruby Block, Proc and Lambda"
date: 2011-08-12 16:44
comments: true
categories: Ruby
---

Ruby 可將程式碼當參數傳遞，被參數化的程式碼稱為 Block。也就是呼叫方法時後面的 `{|| }`  符號，其中的 `||` 之間放置參數列宣告，若無參數則可省略。

Ruby 的 Proc 類似 ECMAScript 的 function。在 ECMAScript 中使用關鍵字 function 即可配置一個 Function 實例。Ruby 則使用 Kernel::proc、Kernel::lambda 方法（但兩者有些微差異），或是直接建構一個 Proc 實例（Proc.new）。

## Block and Proc
Ruby 會主動將 Block 參數化成 Proc，Block 無法單獨存在，只能作為 Ruby 指令或呼叫方法時的引數。程序員僅需利用流程指令 yield 即可將流程轉移到被參數化的 Block 中運行。我們可以用 Kernel::block_given? 判斷使用者有無傳遞 Block。

<!-- more -->

``` ruby Compare with Block way and Proc way
# Block way
def f1(n)
  if block_given?
      yield n # yield to black
  else
      puts 'no block'
  end
end

# Proc way
def f2(n, &p)
  if block_given?
    p[n] # call proc p
    # 'p[n]' can be alternated with 'p.call(n)'
    # 'yield n' also works
  else
    puts 'no block'
  end
end

# Usage
f1('Hello'){|s| puts s}
f2(10){|n| n.times{puts 'a'}}
```

## More about Proc
Block Way 無法得知被參數化的 Block，其 Proc 的指標。如果要取得該 Proc 的指標，需要在最後一個參數前面加上 ’&’，這東西只能有一個，且必須放在最後面，否則都會跳出 syntax error。

``` ruby Don't do this!
def f3(&p, n) #syntax error
  # ...
end
 
def f4(n, &p1, &p2) #syntax error
  # ...
end
```

### Blockless
如果在呼叫方法時不想加上 Block，卻又想傳入一段程式碼區塊。

``` ruby
def f3(n, p)
  p[n] # call proc p
  # 'p[n]' is equivalent to 'p.call(n)'
  # 'yield n' will not work unless a block was given, but notice that the block has nothing to do with parameter 'p'
end
f3('Tony', Proc.new{|name| puts name}) # 'Proc.new' is equivalent to 'Kernel::proc'
```

建立一個 Proc 實體，並當參數傳入即可，但還是得在建立同時寫 Block 給 Proc.new 方法。這種寫法對於熟悉 ECMAScript 的人應該不陌生。

``` js
function f(n, p) { return p(n); }
f(10, function(n){print(n)});
```

上面介紹的方法乍看下很冗長又不好看，的確，如果只希望傳遞僅一個程式碼區塊作為參數，上述方法稍嫌麻煩，用 Proc Way 可以簡化很多，如果對取得 Proc 的指標不感興趣，用 Block Way 更加簡潔。

### Passing More Than One Proc

但這種將 Proc 實體當參數傳遞的方法也不盡然無用武之地，因為 Ruby 在呼叫方法時止允許傳入一個Block，當想要傳入多的程式碼區段作為參數時，適用此技。

``` ruby
def f4(n, p1, p2)
  p1[n]
  p2.call n
end
f4('Hi', Proc.new{|s| puts "p1: #{s}"}, proc{|s| puts "p2: #{s1}"})
```

### The Ampersand
剛才介紹 & 的其中一個用法，那就是在方法宣告同時，指定從 Block 轉成 Proc 的變數名，除此 & 隨著使用地點不同，還可以把 Proc 轉成 Block：

``` ruby
f1("Hahaha", &proc{|s| puts s})
```

proc 會回傳一個 Proc 實體，當 Proc 碰到 & 之後，會轉換成 Block，所以以上的示範意義與下相同：

``` ruby
f1("Hahaha"){|s| puts s}
```

另外還有一個妙用，如果我們想把一串單字轉換成大寫，如下：

``` ruby
words = %w(Jane, aara, multiko)
upcase_words = words.map {|x| x.upcase} 
p upcase_words
```

這看起來相當簡潔，但其實可以更簡潔：

``` ruby
words = %w(Jane, aara, multiko)
upcase_words = words.map(&:upcase) # alternate this line
p upcase_words
```

原理是因為 Ruby 可以用物件的方法名去參考到該方法（反射），舉個例子：

``` ruby This two lines are equivalent
“tonytonyjan”.upcase
“tonytonyjan”.send(:upcase)
```

所以當我們寫出 `map(&:upcase)` 這樣的語法時，他會將傳出的物件的方法化為 Proc 並執行，所以與 `map{|x| x.upcase}` 意義相同。

如果想調用的方法需要參數的話，則在宣告方法的同時要動點手腳，舉個例子：

``` ruby
def f5(n, m)
  yield n,m # yield to black
end
 
class A
  def f7 s
    puts "A.f7 says #{s}"
  end
end
 
f5(A.new,"The World!", &:f7)
```

&:f7 會去找第一個接到的參數，並呼叫 f7，及 f5 中的 n，而在那之後所有擲出的參數，都被當成 f7 的參數。所以 `f5(A.new,"The World!", &:f7)` 的真正意思是「呼叫物件 A 的 f7 方法，並傳入 "The World!" 當參數」。

## Proc and Lambda

在 Wiki 中找到 [Closure] 的資料，其中有的一段 Ruby 程式碼清楚闡述了 Proc 和 Lambda的差別：

``` ruby Compare Proc with Lambda
def foo
  f = Proc.new { return "return from foo from inside proc" }
  f.call # control leaves foo here
  return "return from foo"
end
 
def bar
  f = lambda { return "return from lambda" }
  f.call # control does not leave bar here
  return "return from bar"
end
 
puts foo # prints "return from foo from inside proc" 
puts bar # prints "return from bar"
```

除此之外，他們一樣。

## Reference

* [Wiki][Closure]
* [WikiBooks]
* [Ruby Doc]

[Closure]: http://en.wikipedia.org/wiki/Closure_(computer_science)
[WikiBooks]: http://www.google.com/url?q=http%3A%2F%2Fzh.wikibooks.org%2Fwiki%2FRuby_Programming%2FSyntax%2FMethod_Calls&sa=D&sntz=1&usg=AFQjCNFXj4QvZXjDZVQIPhrl99JDBPCmKQ
[Ruby Doc]: http://www.google.com/url?q=http%3A%2F%2Fzh.wikibooks.org%2Fwiki%2FRuby_Programming%2FSyntax%2FMethod_Calls&sa=D&sntz=1&usg=AFQjCNFXj4QvZXjDZVQIPhrl99JDBPCmKQ