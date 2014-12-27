## Ruby 4 大類別

- String - 字串
- Fixnum - 數字
- Array - 陣列
- Hash - 雜湊

---

## Array 陣列
```ruby
x = [1, 2, 3]
y = ["Tony", "Jason", "John"]
x.class   # => Array
x.reverse # => [3, 2, 1]
x.length  # => 3
x.sample
x.sample 12 # 12 是 sample 的參數
```
- 陣列就是有序的清單
- 用中括號與逗號宣告


## 陣列提值
```ruby
x = ["Tony", "Jason", "Mary", "Kate"]
x.first # => "Tony"
x.last  # => "Kate"
x[0]    # => "Tony"
x[1]    # => "Jason"
x[-1]   # => "Kate"
x[1..2] # => ["Jason", "Mary"]
x[1, 3] # => ["Jason", "Mary", "Kate"]
```


## 陣列與字串互動

```ruby
x = ["Apple", "Banana", "Orange"]
x.join     # => "AppleBananaOrange"
x.join "=" # => "Apple=Banana=Orange"

y = "This is a sentance"
y.split     # => ["This", "is", "a", "sentance"]
y.split "a" #=> ["This is ", " sent", "nce"]
```
- join 回傳字串
- split 回傳陣列


# 練習
### 用 1 行 Ruby 解下列題目：
```ruby
"This is a sentance"...... # => "sentance a is This"
```
提示：利用 `join`、`split`、`reverse`

---

## 陣列三大迭代方法

- each - 迭代（迴圈）
- map - 替換
- select - 篩選

這三個方法的參數都需要傳入 block


## each - 迭代（迴圈）
```ruby
x = [1, 2, 3]
x.each{ |number|  puts number * 2 }
```
- 大括號內的程式碼會被執行 3 次
- 每次 number 變數會變，第一次是 1，第二次是 2，類推


## 利用 each 算出加總

```ruby
total = 0
a = [1, 2, 3, 4, 5, 6, 7]
a.each{ |number| total += number }
puts total # => 28
```


# 練習
### 實作一個方法，傳入 1 個陣列參數，最後回傳加總

```ruby
def get_sum input
  # ...
end
get_sum [1,2,3,4,5] # => 15
```


# 練習
### 姓名速配程式
1. 觀察 String 的 `codepoints` 方法會回傳什麼
2. 將 `long_name` 的 codepoints 加總，並取得平均值
3. 將平均取 100 的餘數即為速配指數
```ruby
def match name1, name2
  long_name = name1 + name2
  # ...
  puts "#{ name1 } 與 #{ name2 } 的速配指數: #{  }"
end
puts match "南海大兜蟲", "北海小英雄"
# 南海大兜蟲 與 北海小英雄 的速配指數: 78.90000000000146
```

 
- 除法若要保留小數，記得 `to_f` 將整數轉成浮點數
- 挑戰寫成互動程式


## map - 替換
```ruby
x = [1, 2, 3]
x.map{ |number| number * 2 } # => [2, 4, 6]
x.map{ |number| number + 1 } # => [2, 3, 4]
```
- block 裡面的回傳結果會取代原本的物件
- `map` 是產生一個新的陣列，x 不會變


## 破壞性方法（驚嘆號方法）

```ruby
x = [1, 2, 3]
y = x.map{ |n| n * 2 }
y # => [2, 4, 6]
x # => [1, 2, 3]

z = x.map!{ |n| n + 1 }
z # => [2, 3, 4]
x # => [2, 3, 4]
```
- 驚嘆號是 Ruby 的命名習慣，不是加了驚嘆號就會自動變成破壞性方法
- `map` 與 `map!` 其實是 2 個獨立的方法


# 練習
### 練習以下的破壞性方法
- String#reverse!
- String#chop!
- String#upcase!
- Array#reverse!


## 練習
### 對字串陣列操作
```ruby
x = ["香蕉", "蘋果", "芭樂"]
y = x.map{ ||
  # ...
}
y # => ["我愛吃香蕉", "我愛吃蘋果", "我愛吃芭樂"]
```


## select - 篩選
```ruby
x = ["apple", "banana", "orange"]
y = x.select{ |word| word.length > 5 }
# => ["banana", "orange"]
```
- block 必須回傳真假值


## 真假值（真假物件）
```ruby
2 > 1              # => true
1 <= 2             # => false
"Tony".length > 30 # => false
"hello" == "hello" # => true
"hello" != "hello" # => false
```
- 在 Ruby，「真」與「假」是 2 個特別的物件


# 練習
### 觀察字串怎麼比大小的判定方式
```ruby
"tonytonyjan" > "tony" # => ?
"abcd" > "efgh"        # => ?
```


# 練習
### 從下列陣列取出大於 1 勝文的數字
```ruby
x = [123456, 100, 5000, 9527, 88888888]
x.select{ |n|
  # ...
}
# => ?
```
提示：1 勝文 = 10 萬

---

## Hash 雜湊

```ruby
x = {"name" => "Tony", "age" => 24}
puts x["name"]
puts x["age"]
```

- 陣列只能用數字當索引，例 x[0]
- 雜湊則可用任何物件當索引，但最常用字串，例 x["name"]
- 陣列用中括號與逗號宣告
- 雜湊用大括號宣告


# 練習
### 用 Hash 自我介紹
```ruby
me = {
  "name" => "大兜",
  "age" => 24,
  "about" => "小人我本住在蘇州小城邊⋯⋯",
  "height" => 1.78,
  "weight" => 62,
  "語言" => ["中文", "台語", "英文"]
}
bmi = me["weight"] / me["height"] ** 2
puts bmi
puts "我叫#{ me["name"] }我會說#{ me["語言"].join "和" }"
```


## 各種宣告方式

```ruby
x = {"name" => "Tony"}
x = {:name => "Tony"}
x = {name: "Tony"}
```
- 工程師是懶惰的


## Symbol 與 String

```ruby
"name".class # => String
:name.class  # => Symbol
```

- Symbol 物件用冒號開頭來宣告
- Symbol 是有更有效率的 String，適合當 Hash 的索引


## Hash 的方法

```ruby
person = {name: "Tony", age: 24}
person.each do |key, value|
  puts "#{key}: #{value}"
end
person[:name] # => "Tony"
pserson[:age] # => 24
person.keys   # => [:name, :age]
person.values # => ["Tony", 24]
```


# 練習
### 用 `students` 算出總成績、平均

```ruby
std1 = {name: "Tony", score: 44}
std2 = {name: "Jason", score: 55}
std3 = {name: "Mary", score: 66}
students = [std1, std2, std3] # 陣列什麼資料類型都可以放
total = 0
students.each do |std|
  # ...
end
puts total
```