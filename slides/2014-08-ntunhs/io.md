## 用 new 產生物件

```ruby
str = Stirng.new          # => ""
str = Stirng.new("Hello") # => "Hello"
ary = Array.new           # => []
ary = Array.new(3)        # => [nil, nil, nil] 
hhs = Hash.new            # => {}
```
- `String` 類別的 `new` 方法會產生並回傳 `String` 物件
- `new` 是初始化方法，在別的程式語言又叫建構子
- 在 Ruby，產生新物件都要用 `new`
- 中括號、大括號、雙引號是語法糖衣


# 練習
### 在 irb 下實驗 `h[:name]` 最後回傳的結果
```ruby
h = Hash.new
h[:name] # => nil
h = Hash.new(9527)
h[:name] # => ?
```

---

# IO
## 讀/寫檔


## File 物件
讀檔
```ruby
f = File.new "helle.txt", "r"
content = f.read # => 會回傳字串
puts content
f.close
```
寫檔
```ruby
f = File.new "hello.txt", "w"
f.puts "Hello"
f.close
```
- `File.new` 的第二個參數：
  - r - read
  - w - write
- 最後要關檔，以免資源占用


# 練習
### 將以下內容存成 `names.csv`，用 Ruby 讀出並名字拆成字串陣列
```csv
Tony,Jason,Annie
```
```ruby
f = File.new "names.csv"
str = f.read
# ...
# => ["Tony", "Jason", "Annie"]
f.close
```
提示：使用 `String#split`


## File.read 與 File.write
```ruby
File.write "haha.txt", "ha ha ha!"
File.read "haha.txt" # => "ha ha ha!"
```
- File 是一個類別
- File 有 `write` 與 `read` 方法
- 屬於類別可用的方法，稱之類別方法
- 屬於物件可用的方法，稱之實體方法


## 類別方法與實體方法
```ruby
"Hello".reverse
Stirng.reverse # 錯誤
String.methods
"Hello".methods
```
- `String` 是類別
- `"Hello"` 是 `String` 物件
- `reverse` 屬於 `String` 的實體方法


# 練習
### 試試 `String` 的 `[]` 方法
```ruby
s = "Hello"
s["e"]  # => ?
s["lo"] # => ?
s["H"]  # => ?
s["z"]  # => ?
```

---

## 聊天機器人實作

1. 接收使用者輸入的文字
2. 輸出回應
3. 反覆動作


## 聊天機器人雛形
```ruby
while true
  # 輸入
  print "> "
  input = gets.chop
  # 輸出
  print "<小兜蟲>："
  puts ["你好", "嗨", "什麼事嗎"].sample
end
```


# 練習
### 試著在剛剛的程式碼某處加上判斷
```ruby
if input['餓']
  puts ["你想吃什麼？", "不要吃我> <"].sample
else
  puts ["你好", "嗨", "什麼事嗎"].sample
end
```


## 加入指令
```ruby
if input == "/擲骰子"
  puts "投出了 #{ 1 + rand(6) } 點！"
end
```


# 練習
### 增加開樂透功能
```ruby
if input == "/樂透"
  # ...
end
```
提示：利用 `(1..48).to_a` 取得一個陣列


## 用讀檔案的方式取出詞庫
```ruby
hi_ary      = File.read("hi.txt").lines.to_a
hungry_ary  = File.read("hungry.txt").lines.to_a
while true
  # ...
  if input['餓']
    puts hungry_ary.sample
  else
    puts hi_ary.sample
  end
end
```
- 如此未來新增語句就不用再改程式碼

---

# JSON
### JavaScript Object Notation


## JSON
- 一種輕量級的資料標記語言
- 易讀易寫
- 廣泛用於 Web 2.0
- 大多 API 皆提供 JSON 格式
  - 例：http://graph.facebook.com/tonytonyjan


## JSON 格式
```json
{
  "name": "Tony",
  "age": 24
}
```
跟 Ruby Hash 長得很像，但冒號右方只支援 3 種資料：

- 字串：只能用雙引號，例：`"tony"`
- 數值：整數或實數，例：`123`
- 布林：`true`、`false`


## 表達一個學生

```json
{
  "姓名": "簡煒航",
  "生日": "1989-11-23",
  "學號": "9717175",
  "科系": "資工"
}
```


## 表達一個班級
```json
{
  "年級": 1,
  "名稱": "甲班",
  "學生": [
    {"姓名": "簡煒航", "學號": "9717175"},
    {"姓名": "金山找", "學號": "9717176"},
    ...
  ]
}
```


## 表達一個學校
```json
{
  "名稱": "國立臺北護理健康大學",
  "創校時間": 1954,
  "班級": [
    {"年級": 1, "名稱": "甲班", "學生": [...]}
  ]
}
```


# 練習
### 假設要製作一個班級通訊錄，請用 JSON 來表達該結構，並將檔案存成 `contacts.json`
```ruby
[
  {"name": "大兜", "email": "tonytonyjan@gmail.com"},
  ...
]
```

通訊錄的資料欄位自由發揮


## Ruby and JSON
```ruby
require "json" # Ruby 內建的方法庫
JSON.parse '{"name": "Tony"}'
JSON.parse '[{"name": "Tony"}, {"name", "Jason"}]'
```
- JSON 字串可以透過 `JSON.parse` 轉成 Hash 或 Array 物件


# 練習
將剛剛儲存的 `contacts.json` 讀出來，並用 `JSON.parse` 轉成 `Hash`，並逐條印出下列格式：
```ruby
require "json"
s = File.read "contacts.json"
# ...
```
最後印出：
```no-highlight
Tony Jian <tonytonyjan@gmail.com>
Jason <jason@gmail.com>
...
```


# 練習 1/2
### 改良聊天機器人，利用 JSON 格式儲放聊天詞庫
```json
{
  "嗨": ["你想吃什麼？", "不要吃我> <"],
  "餓": ["你好", "嗨", "什麼事嗎"],
  ...
}
```
接下頁


# 練習 2/2
```ruby
require 'json'
robot = JSON.parse(File.read("robot.json"))
while true
  # ...
  if input['餓']
    puts robot["餓"].sample
  else
    puts robot["嗨"].sample
  end
end
```

---

# 用網址開檔
```ruby
require 'open-uri'
f = open "http://5xruby.tw/robots.txt"
content = f.read
```
- `open-uri` 是 Ruby 內建的其中一個方法庫
- open 可以把網址當成一個檔案打開，即回傳一個 `File` 物件


# 練習
### 下載一個網頁，觀察內容
```
require 'open-uri'
f = open "http://5xruby.tw"
content = f.read
puts content
```


# 練習
### 下載一張圖片，並且存檔

```ruby
require 'open-uri'
f = open "http://...........[png|jpg|gif]"
File.write # ...
```
提示：可利用 `File.write` 方法


# 練習
### 漫畫下載器
下載死神 591 話前 9 頁：http://comic.sfacg.com/HTML/bleach/591/

```ruby
require 'open-uri'
# ...
open "http://...00#{  }.jpg"
# ...
```
提示：可利用 `times` 方法


## 格式化字串
利用 `%` 方法

```ruby
x = 3
"number is #{x}"   # => "number is 3"
"number is %d" % x # => "number is 3"
"number is %3d"    # => "number is   3"
"number is %03d"    # => ?
```
- `%` 用在數字是取餘數
- `%` 用在字串則是用於格式化
- d 是 digit 的縮寫，表示整數
- `%3d` 表示會佔用三個字的長度


# 練習
### 下載整套死神 591 話