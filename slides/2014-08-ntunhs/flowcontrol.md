# 流程控制


## if ... else ... end
```ruby
x = rand 10
if x > 5
  puts "喔喔！！好大！"
else
  puts "喔喔！！好小！"
end
```
- rand 10 會從 0 到 9 中隨機選一個數字
- 在 Ruby，只有 nil 與 false 為假，其餘為真


## if ... elsif ... else ... end
```
x = rand 10
if x > 7
  puts "大於七"
elsif x > 5
  puts "大於五"
else
  puts "好小"
end
```


## 真假值
```ruby
true  && true  # => true
true  && false # => false
true  || false # => true
false || false # => false
```


# 練習
```ruby
x = 1 < 2  # => true
y = 1 >= 3 # => false
x && y # => ?
x || y # => ? 
```


## 跟使用者互動
```ruby
x = gets.to_i
y = gets.to_i
if x > 5 && y == 5
  puts "喔喔！！好大！"
else
  puts "喔喔！！好小！"
end
```


# 練習
### 用 `gets` 做猜數字遊戲

```ruby
answer = 20
puts "請猜："
# ...
puts "答對了"
# ...
puts "打錯了"
```

```no-highlight
> ruby guess.rb
請猜：1
打錯了
```


## while ... end

```ruby
while true
  puts "無窮迴圈"
end
```
- Ctrl + C 可中斷程式


```ruby
while true
  if gets.to_i == 100
    puts "答對了"
    break
  else
    puts "打錯了"
  end
end
```
- break 可以跳出迴圈


```ruby
while gets.to_i != 100
  puts "答錯了"
end
puts "答對了"
```


# 練習
### 猜數字遊戲
隨機出題，給使用者不斷猜，直到答對
```ruby
answer = 1 + rand(10) # 先將解答存好
puts "請猜 1 ~ 10 其中一個數字"
# ...
```


## 練習
### 猜數字遊戲
將範圍調整到 1 ~ 100，提示使用者猜大猜小
```ruby
answer = 1 + rand(100)
# ...
puts "再猜大一點"
# ...
puts "再猜小一點"
# ...
```


## 練習
### 猜數字遊戲
給使用者 7 次機會
```ruby
answer = 1 + rand(100)
chance = 7
# ...
```
提示：exit 方法可以直接中途離開程式