# Ruby

---

# 為什麼用 Ruby?


## 松本行弘
![](../img/matz.jpg)

> Ruby is designed to make programmers happy


## 開發環境

- 安裝 Ruby
- 安裝編輯器
- 一些餅乾 <!-- .element: class="fragment" -->
- 一瓶可樂 <!-- .element: class="fragment" -->
- 輕鬆的音樂 <!-- .element: class="fragment" -->

---

# 第一支 Ruby 程式


### 新增一個 `hello.rb` 檔案，寫上：
```ruby
puts "Hello，Ruby"
```

### 在指令模式，執行 Ruby 檔案：
```no-highlight
C:\你的當前目錄> ruby hello.rb
```

### 注意事項

1. 下指令之前，先確認檔案確實在當前目錄下（可用 dir 指令）
2. 記得存檔


## 執行一百次

```ruby
100.times{ puts "Hello" }
```


# 練習
### 把 `puts` 換成 `print`

---

# > irb
### Interactive Ruby
### 互動式 Ruby


## 進入 irb

```no-highlight
> irb
irb(main):001:0> 
```


# 練習
### 試著在 irb 上直接寫程式

```ruby
irb(main):001:0> puts "hello"
hello
=> nil
```

---

# 基本語法

---

## 數字

```ruby
1  +   2   # => 3
10 -  11   # => -1
2  *   3   # => 6
3  /   2   # => 1
3  %   2   # => 1
2 **  10   # => 1024
```
先乘除後加減，次方最優先


## 變數

```bash
x = 1
y = 2
x + y     # => 3
y * 2     # => 4
x = 10    # 重新定義變數
x * 2 + y # => 22
```


# 練習
### 計算自己的 BMI
### 計算自己的幸運數字


## 運算子組合

```ruby
x  = 1
x  = x + 1 # => 2
x += 1     # => 3
```

---

## 字串

```ruby
"Hello"
"Hello" + ", Ruby" # => "Hello, Ruby"
"ruby" * 5 # => "rubyrubyrubyrubyruby"
name = "Tony"
puts name
```
雙引號或單引號中的文字，謂之字串


# 練習
### 將自己的英文名字分別存在兩個變數 `first_name` 和 `last_name`
### 用 `puts` 印出 "Hello, 你的名字"


## 字串內嵌程式碼

```ruby
puts "1 + 1 = 2"
puts "1 + 1 = #{ 1 + 1 }"
puts "Hello, #{ first_name }"
```

`#{ }` 裡面的內容是程式碼片段


# 練習
### 把雙引號換成單引號，用 `puts` 或 `print` 印出結果觀察


## 跳脫字元（反斜線 + 字元）

```ruby
puts "Hello, \"Tony\"" # \" 為雙引號
puts "line 1\nline2"   # \n 為換行
```

---

## 數字與字串轉換

```ruby
"123"      + 456.to_s
"123".to_i + 456
```

`to_i` 是 to integer 的意思，`to_s` 則是 to string

---

## 賦值

```ruby
name = "Tony"
age  = 24
say  = "#{name} is #{age} years old"
puts say

name = "Jason"
age  = 21
puts say
```

等於會將右值賦予左邊變數


## 平行賦值

```ruby
name, age = "Jason", 21
```

---

## `puts` 與 `gets`

```ruby
puts "輸入你的名字："
name = gets # 輸入
puts name   # 輸出
```


## 與使用者互動
```ruby
puts "輸入名字"
name = gets
puts "輸入年齡"
age  = gets.to_i
puts "嗨, #{name}，你 #{age} 歲了"
puts "再過 #{age} 年就是 #{age * 2} 歲了"
```


# 練習
### 寫一個可以算 BMI 的互動程式

---

# 方法


## 基本寫法

```ruby
def say_hello
  puts "Hello, Tony"
end

say_hello
```
- 以後輸入 say_hello，`def`、`end` 之間的程式碼幾被執行


## 方法參數

```ruby
def say_hello name, age
  puts "Hello, #{name}, you are #{age} years old."
end

say_hello "Tony", 24
```

- 外部變數在方法中是看不到的
- 參數是一種變數
- `name` 和 `age` 是 `say_hello` 的參數
- 先定義方法才能呼叫


## 回傳值

```ruby
def say_hello name, age
  "Hello, #{name}, you are #{age} years old."
end

result = say_hello "Tony", 24
puts result
```

- 最後一個被執行的結果會成為方法的回傳值


# 練習
### 試寫一個可回傳 BMI 的方法
### 試寫一個可回傳三角形的第 3 邊的方法

```ruby
def bmi weight, height
  # ...
end

def third_line line_1, line_2
  # ...
end
```

---

# 註解


## 單行註解

```ruby
# 我是第一行註解
# 我是第二行註解
```
`#` 右方的文字 Ruby 不會看到


## 多行註解

```ruby
=begin
這裡你的以隨意輸入多行，
只要沒有看到，直到出現 =end
這裡的文字 Ruby 不會看到
=end
```


# 練習
### 幫你的方法加上註解

```
# 介紹一下這個方法、傳入什麼、回傳什麼
def bmi weight, height
  # ...
end
```

---

# 物件導向程式設計


## 物件導向概念簡介
- 類別（Class）
  - 繼承（Inheritance）
- 物件（Object）/ 實體（Instance）
  - 方法（Method）
  - 屬性（Attribute）

類別封裝了方法與屬性，讓程式碼有秩序


## 現實生活中的例子

- 類別 - 人類
- 物件 - 某個體
  - 屬性 - 髮色、身高、名字
  - 方法 - 吃飯、睡覺、說話


## 在 Ruby 中的例子

- 類別 - String
- 物件 - "Hello, Ruby"
  - 方法 - length、to_s、reverse

Ruby 中，屬性與方法是同一個概念


## 萬事萬物皆物件
```ruby
"Tony".class # => String
123.class    # => Fixnum
```


## 物件皆有方法
```
"123".to_i # => 123
123.to_s   # => "123"
```
物件與方法之間由 `.` 連接


## 屬於 `String` 的方法
```ruby
"123".to_i
name = "Tony"
name.reverse # => "ynoT"
```

其中 `to_i` 與 `reverse` 都是 `String` 的方法，而 `name` 是一個 `String` 物件，所以可以呼叫這些方法


# 練習
### 試試其他字串的方法
- chop
- upcase
- downcase
- length


## 屬於數字的方法
```ruby
x = -123
x.to_s # => "-123"
x.abs  # => 123
```


## block
```ruby
10.times{ puts "hello" }
10.times do |i|
  puts i
end
```
- block 是將程式碼片段送入方法的「一種參數」
- 有的方法會在 block 中會附帶一個變數（名字自己取）
- 可用大括號或是 `do`、`end` 定義


# 練習
## 金字塔程式
```ruby
def tower n
  n.times{ |i|
    # 用 puts 印東西
  }
end
tower 3
```
印出
```no-highlight
*
***
*****
```
挑戰：對齊金字塔


## 方法的鏈接
```ruby
"123456-".reverse.to_i # => -654321
        "-654321".to_i
                654321
```
只要知道最後回傳的物件是什麼，就可以呼叫該物件的方法