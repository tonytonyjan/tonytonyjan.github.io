---
title: Ruby 自動載入器
date: 2018-04-22 16:23 +08:00
category: Ruby
tags: [Ruby]
description: 本文介紹如何使用自製的 Module.autoload 取代 ActiveSupport 的 autoload 功能，並且將效能提升至 10 倍。
---

軟體在載入模組的方式，可大致分為兩種：消極載入（lazy loading） 與積極載入（eager loading）[^1]。顧名思義，消極載入是指軟體在啟動時僅載入少數需要的模組，而在執行過程如果有需要其他模組時，再載入該需要的模組；反之積極載入則是在軟體啟動時，積極地將所有的模組載入。

<!-- more -->

兩者各有優缺點，一般會在消極載入由於啟動速度快，常用在開發環境（development environment）中，缺點則是軟體運作過程中，對於首次執行的任務，因得加上載入的時間導致效率較差，這在生產環境（production environment）不見得是好事。所以在消極載入的設計下，有些人會在部署時加上一道暖身（warn up）的步驟，以部署一台網頁伺服器為例，可能會在部署後送出各種超文本傳輸協定的請求到上線伺服器，以被動的方式使其可以預先載入所需的模組。積極載入的優缺點則相反：運行快但啟動慢，所以一般會用在生產環境。

一個比較現代的開發方式是針對載入模組的工作額外設計一個載入器，這個載入器可以在積極或消極兩者間做切換，以在開發環境中使用消極載入，生產環境中使用積極載入。

# const_missing v.s. Module.autoload

[Rails Guide 有一個篇章](http://guides.rubyonrails.org/autoloading_and_reloading_constants.html)詳細介紹了 Rails 內部載入的方法。內文提到 Rails 在消極載入的實作並沒有使用到 Ruby 內建的 `Module.autoload`，取而代之則是用 `const_missing` 來實作。

雖然使用 ActiveSupport 的載入器可以省不少麻煩，但筆者沒有需要用到像是熱重載這類進接功能，加上覺得 `const_missing` 效能上並沒有比用 `Module.autoload` 實作來的好，只是到底會慢多少？筆者寫了一個基準測試（benchmark test）：

```ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'benchmark'
require 'fileutils'
require 'active_support' # v5.2.0
require_relative 'autoloader'

n = 10000
words = (?a..?z).to_a.permutation(5).lazy.map(&:join).first(n)
class_names = words.map(&:capitalize)
FileUtils.rm_rf %w[as al]
FileUtils.mkdir_p 'as/foo'
FileUtils.mkdir_p 'al/bar'
words.each do |word|
  IO.write "as/foo/#{word}.rb", "module Foo; module #{word.capitalize} end end"
  IO.write "al/bar/#{word}.rb", "module Bar; module #{word.capitalize} end end"
end

Benchmark.bm(13) do |x|
  ActiveSupport::Dependencies.autoload_paths = ['as']
  x.report('ActiveSupport') do
    class_names.each do |class_name|
      eval "Foo::#{class_name}"
    end
  end

  IO.write 'al/bar.rb', 'module Bar; include Autoloader end'
  require_relative 'al/bar'
  x.report('Autoloader') do
    class_names.each do |class_name|
      eval "Bar::#{class_name}"
    end
  end
end
```

其中 `autoloader` 是筆者另外寫的載入器，載入的檔案是動態產生的，分別放在 `as` 和 `al` 資料夾，`as` 裡的檔案給 ActiveSupport 載入，`al` 裡的則以筆者的自製的載入器載入。

再來看看結果：

```
user     system      total        real
ActiveSupport  16.810000   1.320000  18.130000 ( 18.128572)
Autoloader      1.170000   0.630000   1.800000 (  1.804112)
```

看起來 Autoloader 大約比 ActiveSupport 的版本要快上 10 倍。以下是 `autoloader.rb` 的原始碼：

```ruby
module Autoloader
  def self.included(mod)
    caller_path, = caller(1..1).first.partition(':')
    pattern = "#{File.dirname(caller_path)}/#{File.basename(caller_path, '.rb')}/*.rb"
    Dir.glob(pattern).each do |path|
      class_name = File.basename(path, '.rb').split('_').map(&:capitalize).join.to_sym
      mod.autoload class_name, path
    end
  end
end
```

# 筆者的 Autoloader 的慣例

筆者的 Autoloader 雖然以效能為出發點，但使用上有些限制。由於它沒有像是 ActiveSupport 會自動將資料夾轉為 module 的<del>魔法</del>功能（例如有個空的資料夾 `foo/bar`，當引用 `Foo::Bar` 時，即便沒有 `foo/bar.rb`，`module Bar; end` 也會自動產生），所以針對每個層級的資料夾，都需要有一個同級同名的檔案來定義名稱空間，例如以下的檔案結構為例：

```
lib
├── myapp
│   ├── adapters
│   │   ├── foo.rb
│   │   ├── bar.rb
│   │   └── buz.rb
│   ├── adapters.rb
│   ├── entities
│   │   ├── foo.rb
│   │   ├── bar.rb
│   │   └── buz.rb
│   ├── entities.rb
│   ├── interactors
│   │   ├── foo.rb
│   │   ├── bar.rb
│   │   └── buz.rb
│   └── interactors.rb
└── myapp.rb
```

而其中 `adapters` 資料夾相對應 `adapters.rb` 原始碼：

```ruby
module Myapp
  module Adapters
    include Autoloader
  end
end
```

等同於：

```ruby
module Myapp
  module Adapters
    autoload :Foo, "#{__dir__}/foo.rb"
    autoload :Bar, "#{__dir__}/bar.rb"
    autoload :Buz, "#{__dir__}/buz.rb"
  end
end
```

# 積極載入

筆者尚未對 Autoloader 於生產環境做過優化，但理論上不至於太困難，一個作法是在 `autoloader.rb` 裡面可以加入環境變數來判斷如何載入：

```ruby
if ENV['MYAPP_ENV'] == 'production'
  Kernel.require path
else
  mod.autoload class_name, path
end
```

或者在 `Autoloader` 模組裡面提供載入方法的介面：

```ruby
class Foo
  include Autoloader
  ENV['MYAPP_ENV'] == 'production' ? eager_load! : lazy_load!
end
```

[^1]: 也有翻譯叫「惰性載入」、「懶載入」，另一邊則稱「熱情載入」等，但筆者認為兩者概念應該透過「消極」與「積極」這樣的翻譯最能融入當地的用語且能一目了然。
