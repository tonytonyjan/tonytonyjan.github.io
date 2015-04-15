---
title: 台灣身份證字號驗證器
date: 2015-04-15 18:30 +0800
tags: Ruby
category: 程式
---

今天在 Ruby Taiwan 的 [FB 社團上](https://www.facebook.com/groups/142197385837507/permalink/888110727912832/)看到 adz 大大在問是否有身份證字號驗證的 gem 可以用。

這東西記得在大一時用 C、Java 各寫過一次，程式碼已遺失，反正今天寫了一天程式也累了，只好寫別的程式來放鬆一下（啥？），不過這次會用 Ruby 來寫，同樣的程式碼我也放在 [Gist](https://gist.github.com/tonytonyjan/361282d5b6771660b88c) 上面：

```ruby
MAP = {
  'A' => [1, 0], 'B' => [1, 1], 'C' => [1, 2], 'D' => [1, 3], 'E' => [1, 4], 'F' => [1, 5], 'G' => [1, 6], 'H' => [1, 7], 'I' => [3, 4],
  'J' => [1, 8], 'K' => [1, 9], 'L' => [2, 0], 'M' => [2, 1], 'N' => [2, 2], 'O' => [3, 5], 'P' => [2, 3], 'Q' => [2, 4], 'R' => [2, 5],
  'S' => [2, 6], 'T' => [2, 7], 'U' => [2, 8], 'V' => [2, 9], 'W' => [3, 2], 'X' => [3, 0], 'Y' => [3, 1], 'Z' => [3, 3]
}
 
MULTIPLIER = [1, 9, 8, 7, 6, 5, 4, 3, 2, 1, 1]
 
def id_check id
  return false unless id =~ /\A[A-Z]\d{9}\z/
  chars = id.chars
  numbers = MAP[chars.shift] + chars.map!(&:to_i)
 
  sum, i = 0, 0
  while i < 11
    sum += numbers[i] * MULTIPLIER[i]
    i += 1
  end
  sum % 10 == 0
end
```

寫完後還不免想要比較一下別人的 code，不料也能意外的比網路上僅存的兩個 gem 快兩倍以上：

```ruby
require 'benchmark'
require 'id_check'
require 'taiwanese_id_builder'
require 'TaiwanUserID'
 
n = 100000
Benchmark.bmbm do |x|
  x.report('wayne5540  '){ n.times{ TaiwaneseIdBuilder.valid?('A123456789') } }
  dummy = Object.new.extend(TaiwanUserID)
  x.report('kaochenlong'){ n.times{ dummy.is_valid?('A123456789') } }
  x.report('tonytonyjan'){ n.times{ id_check('A123456789') } }
end
 
# wayne5540     1.080000   0.230000   1.310000 (  1.319509)
# kaochenlong   1.860000   0.010000   1.870000 (  1.879476)
# tonytonyjan   0.550000   0.000000   0.550000 (  0.557314)
```

## while 無敵

筆者只知道 Ruby 中的迭代方法，無論用 `#each` 還是 `#times`，沒有一個比 `while` 還要快的，所以果斷用了 `while` 來解題，但這題其實要幾兩個陣列相乘再做加總，其實可以用 `#zip` 甚至是 Ruby 內建的 `Matrix` 來做。

正想做 benchmark 時就搜尋到[這篇文章](http://stackoverflow.com/questions/7372489/whats-the-efficient-way-to-multiply-two-arrays-and-get-sum-of-multiplied-values)，所以果然還是 `while` 無敵啊XD。

對高效能的 Ruby 有興趣的人可以參考 Juanito Fatas 的 [fast-ruby](https://github.com/JuanitoFatas/fast-ruby)。

## 其他人怎麼寫

在[這裡](https://github.com/wayne5540/taiwanese_id_builder/blob/master/lib/taiwanese_id_builder.rb)可以找到 wayne5540 的程式碼，其中最令人糾結的是有一個 `puts` 沒有拿掉，所以在執行 `#valid?` 時會把結果印到螢幕上。所以要是像筆者一樣寫了 benchmark，自然是噴的整個螢幕都是。

有趣的是筆者意外在 rubygems.org 找到高見龍的 [gem](https://rubygems.org/gems/TaiwanUserID)，從時間上看是 2013 年 2 月推上來的，且 GitHub 上面找不到，也許是用在教學時寫的。

裡面只有一個 32 行的檔案，比起 wayne5540 的 gem 要輕巧許多，但也不難看出是效能是怎麼被影響的：

```ruby
require "TaiwanUserID/version"

module TaiwanUserID
  def is_valid?(id)
    cities = {
      :A => '10', :B => '11', :C => '12', :D => '13',
      :E => '14', :F => '15', :G => '16', :H => '17',
      :I => '34', :J => '18', :K => '19', :L => '20',
      :M => '21', :N => '22', :O => '35', :P => '23',
      :Q => '24', :R => '25', :S => '26', :T => '27',
      :U => '28', :V => '29', :W => '32', :X => '30',
      :Y => '31', :Z => '33',
    }

    id_array = id.upcase.split('')

    special = cities[id_array.first.to_sym][0].to_i * 1 + cities[id_array.first.to_sym][1].to_i * 9
    sum =
      special +
      id_array[1].to_i * 8 +
      id_array[2].to_i * 7 +
      id_array[3].to_i * 6 +
      id_array[4].to_i * 5 +
      id_array[5].to_i * 4 +
      id_array[6].to_i * 3 +
      id_array[7].to_i * 2 +
      id_array[8].to_i * 1 +
      id_array[9].to_i

    return sum % 10 == 0
  end
end
```
