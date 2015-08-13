# Return Front-end back to Front-end Developers
## 還給前端一片天空

---

# [fit] Who am I?
# [fit] 先生不知何許人

---

![](tony.png)

---

![](tony.png)

# [fit] 簡煒航
# [fit] Jian Weihang

---

![right](taiwan.jpg)

# [fit] Taiwan


---

![right](tony.png)

# 大兜 @tonytonyjan

- CTO, Ziltag Inc.
- Co-founder, 5xRuby
- Author, Ruby on Rails 自習手冊
- Author, xdite gem
- Speaker, ConFoo 2015
- Speaker, Ruby Kaigi 2014
- ~~Student, NTUST~~

---

![right](tony.png)

# My Expertise

- C/C++
  - Qt
- Ruby
  - Rails
  - C Extension
- ~~JavaScript~~
- ~~CSS~~

---

# [fit] 意思就是⋯⋯

---

# [fit] 身為前端麻瓜

---

# [fit] 投了一個前端主題

---

# [fit] 結果上了

---

![right](yao-ming.png)

# [fit] 怪我囉

---

# Outline

- Why sprockets
- Why not sprockets
- Why gulp

---

# [fit] Long Time Ago...

---

# In The Dark Age... (1/4)

```html
<head>
  <link rel="stylesheet" href="aaa.css">
  <link rel="stylesheet" href="bbb.css">
  <link rel="stylesheet" href="ccc.css">
  <script src="aaa.js"></script>
  <script src="bbb.js"></script>
  <script src="ccc.js"></script>
</head>
```

- It sends too many requests.

---

# In The Dark Age... (2/4)
## Concatination

```html
<head>
  <link rel="stylesheet" href="all.css">
  <script src="all.js"></script>
</head>
```

- File Size Too Big

---

# In The Dark Age... (3/4)
## Compression

ex. YUI Compressor & CSS Minifier

```html
<head>
  <link rel="stylesheet" href="all.min.css">
  <script src="all.min.js"></script>
</head>
```

- Hard to debug (Source Map)
- Client Cache Problem

---

# In The Dark Age... (4/4)

```html
<head>
  <link rel="stylesheet" href="all.min.css?v2">
  <script src="all.min.js?v3"></script>
</head>
```

- Tedious

---

# [fit] Rails 3.1
# [fit] Inception of Assets Pipeline

---

# What Sprockets does (1/4)
## Transform

![inline](transform.png)

---

# What Sprockets does (2/4)
## Concat & Compress

![inline](concat_compress.png)


---

# What Sprockets does (3/4)
## Digest

![inline](digest.png)

---

# What Sprockets does (4/4)
## Javascript Templating

```html
<!-- templates/hello.jst.ejs -->
<div>Hello, <span><%= name %></span>!</div>
```

```js
// application.js
//= require templates/hello
$("#hello").html(JST["templates/hello"]({ name: "Sam" }));
```

---

![](thumbs_up.jpg)

---

# [fit] What if

---

# I Want...

- integrate front-end frameworks like React, Polymer, etc.
- add some 3rd-party libraries.

---

# My Front-end Developer

- What is ERB?
- What is JST?
- require system
- How should I install a another 3rd party library?
- Why should I edit Gemfile to add assets libries?

---

# History of Tools

![inline](timeline_2.png)

---

# [fit] gulp.js
