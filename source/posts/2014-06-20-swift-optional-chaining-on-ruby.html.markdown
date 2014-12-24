---
title: "Swift Optional Chaining in Ruby"
date: 2014-06-20 15:49:35 +0800
comments: true
categories: [Ruby,Swift]
---

上次參加了 [Ruby Tuesday #29](http://rubytaiwan.kktix.cc/events/ruby-tuesday-29)，由 Ruby 圈的 JoJo，[Joseph Ku](https://twitter.com/josephku)（<del>范范范瑋琪的概念</del>），分享 WWDC 參加心得與 Swift 的簡介。

其中 Swift 的問號用法（[Optional Chaining](https://developer.apple.com/library/prerelease/ios/documentation/swift/conceptual/swift_programming_language/OptionalChaining.html#//apple_ref/doc/uid/TP40014097-CH21-XID_312)）引起了我的好奇：

```
if let johnsStreet = john.residence?.address?.street {
  println("John's street name is \(johnsStreet).")
} else {
  println("Unable to retrieve the address.")
}
```

身為一個 Rubist，看到問號結尾的方法名想必是不陌生的。依照 Ruby 方法命名的慣例，問號結尾的方法只會回傳 `true` 或 `false`。但在 Swift 就不太一樣了，`john.residence?.address?.street` 的意思和 `john.residence.address.street` 一樣，可是萬一 `john.residence` 是 `nil`，後者會出錯。

再看一次上面優雅的寫法，只要印出 `Unable to retrieve the address.`，我們就知道 `john.residence?.address?.street` 在 chainging 的時候被其中一個回傳值 `nil` 斷法，可能是 `residence`，或是 `address`。

## Ruby 也可以嗎？

乍看覺得這好像也可以在魔法 Ruby 中實現，於是我開始了我的實驗：

```
.
├── lib
│   └── taylor_swift.rb
└── spec
    ├── taylor_swift_spec.rb
    └── spec_helper.rb
```

先寫測試是好習慣，我希望我的 Ruby 以後可以這樣寫：

```ruby
require 'taylor_swift'
name = 'tonytonyjan'
name.length?            # => 11
name.length?.gcd?(1331) # => 11
name.length?.asdf?      # => nil
name.asdf?              # => nil
name.asdf               # => NoMethodError
```

變成 Rspec 後：

```ruby
require 'taylor_swift'

describe '"tonytonyjan"' do
  before(:all){ @name = 'tonytonyjan' }
  it('.length?')             { expect(@name.length?).to             eql(11) }
  it('.length?.gcd?(1331)')  { expect(@name.length?.gcd?(1331)).to  eql(11) }
  it('.length?.asdf?(1331)') { expect(@name.length?.asdf?(1331)).to be_nil }
  it('.asdf?')               { expect(@name.asdf?).to               be_nil }
  it('.asdf')                { expect{@name.asdf}.to                raise_error(NoMethodError) }
end
```

接下來就是 `taylor_swift.rb`：

```ruby
def method_missing name, *args
  name_to_s = name.to_s
  if name_to_s.end_with?('?')
    method = name_to_s.chop
    respond_to?(method) ? send(method, *args) : nil
  else
    super
  end
end
```

乍看好像可以 work，讓我們測測看：

```bash
$ rspec
.....

Finished in 0.00393 seconds (files took 0.19131 seconds to load)
5 examples, 0 failures
```

喔喔！不錯，看起來確實可以運作，可以收工了呢XD（Ruby 真的是很好惡搞的語言）

## 注意

看起來很酷，但是已經違反了 Ruby 設計問號的初衷，正如上述所提，問號結尾的方法名在 Ruby 的功用就是回傳 `true` 或 `false`，同樣的慣例還有驚嘆號（bang method），用於會產生副作用的方法。

鑑於此若真要應用在實務上，建議不要用 `?`，改用像是 `??` 或是其他符號來代替，但 `??` 其實有點醜陋，應該有更漂亮的符號，因為這不是 Ruby 官方的慣例，所以依照個人喜好而定就好。當然最後也可以自己打一個 Gem 給自己用。但若還是堅持希望用 `?` 怎麼辦？

學 Swift XD