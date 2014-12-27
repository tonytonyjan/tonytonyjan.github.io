# HTML
### 網頁排版語言

---

## HTML
- 一種標記格式
- 由標籤組成
- 副檔名為 html


## 標籤寫法
- `<標籤名稱 屬性="值">內文</標籤名稱>`
- `<標籤名稱 屬性="值">`

## 範例

```xml
<a href="http://www.google.com">Google</a>
<img src="http://xxx.yyy.zzz.jpg" width="100">
```


## 最短的 HTML
```xml
<html>
  <head></head>
  <body></body>
</html>
```


## 頁籤標題
```xml
<title>網頁標題</title>
```


# 練習
### 把 title 標籤放進 head 標籤裡


## 標頭
```xml
<h1>標題</h1>
<h2>標題</h2>
<h3>標題</h3>
```
- h 代表 heading
- 共有 6 個：h1 ~ h6


## 文章段落
```xml
<p>這是第一段</p>
<p>這是第二段</p>
```


# 練習
### 利用 h1 與 p 標籤寫文章介紹自己，至少兩個段落，放在 body 標籤裡


## 超連結
```xml
<a href="http://5xruby.tw">五倍紅寶石</a>
```
- a - anchor：錨點
- href - hyperlink reference：超連結


## 圖片
```xml
<img src="http://i.imgur.com/2Av06oX.jpg">
```
- img - image：圖片
- src - source：圖片網址
- width - 寬度
- height - 高度


# 練習
### 在你的文章中加上圖片與超連結


## 有序清單
```xml
<ol>
  <li>項目一</li>
  <li>項目二</li>
  <li>項目三</li>
</ol>
```
- ol - ordered list


## 無序清單
```xml
<ul>
  <li>項目一</li>
  <li>項目二</li>
  <li>項目三</li>
</ul>
```
- ul - unordered list
- li - list item


# 練習
### 介紹你的興趣或是喜歡的事物，用 li 或 ul 完成


## 表單
```xml
<table>
  <tbody>
    <tr>
      <td>項目</td><td>項目</td>
    </tr>
  </tbody>
</table>
```
- thead 與 tbody 裡面只能放 tr
- tr - table row：行
- td - table description：項目敘述


## 表單標頭
```xml
<table>
  <thead>
    <tr>
      <th>標題</th><th>標題</th>
    </tr>
  </thead>
</table>
```
- th - table header：表單標頭


# 練習
### 製作一個表格，第一欄是日期，第二欄是姓名，放 5 個人的生日（5 列）

---

# CSS
### Cascading Style Sheets
### 層疊樣式表


## CSS 可以寫在哪裡

- style 屬性裡
- style 標籤裡
- 分離成檔案


## style 屬性
```xml
<h1 style="color: red"></h1>
<h1 style="color: 0xff00ff"></h1>
<h1 style="color: blue;font-size: 20px"></h1>
```
- 用冒號區隔樣式屬性與屬性值
- 用分號區隔不同樣式設定


# 練習
### 將 h1 系列標題全部改為藍色，段落全部改為綠色，同時且改變大小


## style 標籤

```xml
<style>
  h1{
    color: blue;
  }
  p,h2{
    color: green;
    font-size: 10px;
  }
</style>
```
- 通常放在 head 標籤裡面
- 大括號前面的內容為「選擇器」
- 選擇器可用逗號指定多個套用標籤
- 大括號內的內容是樣式定義


# 練習
### 用 style 標籤，將樣式分離到 head 標籤裡面，避免寫太多重複的文字


## id 屬性
```xml
<p id="main"></p>
```

```xml
<style>
  #main{
    color: red;
  }
</style>
```


## class 屬性
```xml
<p class="color"></p>
<p class="color big"></p>
```

```xml
<style>
  .color{
    color: yellow;
    background-color: black;
  }
  .big{
    font-size: 200%;
  }
</style>
```


## 選擇器格式

```xml
<style>
  h1#xxx.yyy.zzz{
    ...
  }
</style>
```
- 開頭是標籤名稱
- 接著井字是 id 名稱
- 句點後面是 class 名稱，可以多個


## 分離檔案

```xml
<!-- index.html -->
<link rel="stylesheet" href="main.css">
```

```css
/* main.css */
.color{
  color: yellow;
  background-color: black;
}
.big{
  font-size: 200%;
}
```
- link 標籤要放在 head 裡面


# 練習
### 分離 CSS 檔與 HTML 檔


# 練習
```css
body{
  -webkit-transform: scaleX(-1);
}
```

---

# Bootstrap


- http://getbootstrap.com/
- http://www.bootcss.com/


## 使用
```xml
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
```
<!-- .element: style="font-size: .5em" -->

- 放在 head 標籤裡


## 基本架構

```xml
<head>
</head>
<body>
  <div class="container">網站內容放此</div>
</body>
</html>
```
- div 標籤是一個容器，標籤本身沒有特別用途


# 練習
### 把之前寫的 HTML 內容放進 div.container 標籤裡面


## 表格
```xml
<table class="table table-striped">
  ...
</table>
```
參考：http://v3.bootcss.com/css/#tables


## 按鈕
```xml
<a href="" class="btn btn-default"></a>
```
參考：http://v3.bootcss.com/css/#buttons


## 巨幕
```xml
<div class="jumbotron">
  <h1>Hello, world!</h1>
  <p>...</p>
  <p><a class="btn btn-primary btn-lg">Learn more</a></p>
</div>
```


## 導覽列
```xml
<nav class="navbar navbar-default" role="navigation">
  <div class="container-fluid">
    <ul class="nav navbar-nav">
      <li><a href="#">Link</a></li>
      <li><a href="#">Link</a></li>
    </ul>
  </div>
</nav>
```
<!-- .element: style="font-size: .9em" -->

參考：http://v3.bootcss.com/components/#navbar


## 欄格系統
```xml
<div class="row">
  <div class="col-sm-6"></div>
  <div class="col-sm-6"></div>
</div>
```
- row 表示行
- col 表示列（column）
- bootstrap 一行有 12 列