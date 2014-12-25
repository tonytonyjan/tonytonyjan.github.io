---
title: "Ruby 2.0 重點介紹"
date: 2013-02-18 22:46 +0800
comments: true
category: Ruby
---

![](/images/ruby.jpg)

終於也等到了 [Ruby 2.0 RC 釋出的消息](http://www.ruby-lang.org/en/news/2013/02/08/ruby-2-0-0-rc2-is-released/)，看來正式版本也不遠了。而 Ruby 2.0 是什麼？又到底都參了啥好處？這裡整理一些我的筆記。

**首先 Ruby 2.0 完全向下兼容**，這是個好消息，意味之著你不用更改你的程式碼便可以從任何版本無痛升級 2.0（python 迷表示羨慕？），不用擔心你的 Ruby 專案（例如 Rails 等）升級後跑不動。故 Ruby 2.0 可看做是 Ruby 1.9 再加點料，而這些料可炫，且聽我道來。

## Refinements

### Module#refine

你過去擴展一個 class 可能會這樣做：

``` ruby
    "tonytonyjan".double
    # => NoMethodError: undefined method `double' for "tonytonyjan":String

    class String
      def double
        self*2
      end
    end

    "tonytonyjan".double # => "tonytonyjantonytonyjan"
```

Ruby 在團隊開發時，其中一項令人頭痛的問題是，當我們擴展某些 class 時，由於影響的是全局，萬一 method 撞名則會難以 debug。而現在 refinements 則可以將 class 擴展包在 namespace 裡面：

``` ruby
    module Foo
      refine String do
        def double
          self*2
        end
      end
      "tonytonyjan".double # => "tonytonyjantonytonyjan"
    end

    "tonytonyjan".double
    # => NoMethodError: undefined method `double' for "tonytonyjan":String
```

### Kernel#using

寫好的擴展也可以拿出來給別人用：

``` ruby
    module Bar
      using Foo
      "test".double # => "testtest"
    end

    # in proc/lambda
    -> {
      using Foo
      "test".double # => "testtest"
    }.call
```

## Keyword Arguments

寫過 python 大概對這不陌生，Ruby 2.0 也引進了一樣的功能，過去我們可能會在 method 參數中餵一個 Hash 當作 option 使用，通常會長這樣：

``` ruby
    def foo options = {}
      options = {a: "A", b: "B"}.merge options # given default value
      puts options[:a], options[:b]
    end
```

但在 Ruby 2.0，可以簡化如下：

``` ruby
    def foo a: "A", b: "B"
      puts a, b
    end
```

如果想拿到所有的 keys，就放兩顆星星：

``` ruby
    def foo(**options)
      p options
    end
    foo(a: "A", b: "B") # => {:a=>"A", :b=>"B"}
    foo(:a=>"A", :b=>"B") # => {:a=>"A", :b=>"B"}
```

## Enumerator#lazy

以往我們可能要設個 timeout 或 counter 去列舉無窮 enumerator，但 `Enumerator::Lazy` 讓迭代過程這變的更為簡單：

``` ruby
    (1..Float::INFINATY).select(&:even?).take(3)      # 這會跑到海枯石爛
    (1..Float::INFINATY).lazy.select(&:even?).take(3) # 迭代每回合都會執行 `#event?`，而非數完所有元素
```

但不要看到新功能就高潮了，然後套用在每個地方，這方法通常不會比較有效率，除非真的有需要，否則少用為妙。

有興趣可以看看[大師是怎麼用的](http://shugomaeda.blogspot.tw/2012/03/enumerablelazy-and-its-benefits.html)。

## Module#prepend

談到擴展 class，新增 method 很容易，若想 override method 又想保留 origin 的功能卻很麻煩。

``` ruby
    class A
      def foo
        puts "A#foo"
        super
      end
    end
```

這時我們想要幫他的 `#foo` 加點料，又不想動到原來的程式（monkey patch），多會這麼做：

``` ruby
    module B
      def foo
        puts "B#foo"
      end
    end

    class A
      include B
    end

    A.new.foo

    # A#foo
    # B#foo
```

這是利用 `A#foo` 裡頭的 `super` 來完成，但寫 `super` 不應該是被擴展的方的責任，可以話，我們希望把 super 給拿掉。因此 Rails 曾在 `active_support` 下擴展 `Module#alias_method_chian`，但因為被[報出問題](https://rails.lighthouseapp.com/projects/8994/tickets/285-alias_method_chain-limits-extensibility#ticket-285-20)不被建議使用，Rails 3 之後建議利用 Ruby 本身的 `module` 和 `super` 特性解決問題：

``` ruby
    class A
      module Base
        def foo
          puts "Base"
        end
      end

      module Ext
        def foo
          puts "Ext"
          super
        end
      end

      include Base
      include Ext
    end

    A.new.foo

    # => Ext
    # Base
```

理論上一個 module 透過 inclusion 不可能 override class method，因為 module inclusion 的運作是對 class 做 subclassing，這意謂著 class A 若 include module B，則 B 會變成 A 的爸爸，superclass 無法 override subclass method（總之爸爸無法改變女兒的行為，嘛，至少程式裡面是這樣）。這也是為什麼當初 Rails 會有 `Module#alias_method_chian` 的原因。

Ruby 2.0 中的 `Module#prepend` 就是為了解決此問題而生，取代 `Module#alias_method_chian`：

``` ruby
    class A
      def foo
        puts "A"
      end
    end

    module Ext
      def foo
        super
        puts "Ext"
      end
    end

    class A
      prepend Ext
    end

    A.new.foo

    # => A
    # Ext
```

## %i：Array of Symbol

``` ruby
p %w{hurray huzzah whoop}   # => ["hurray", "huzzah", "whoop"]
p %i{hurray huzzah whoop}   # => [:hurray, :huzzah, :whoop]
```
