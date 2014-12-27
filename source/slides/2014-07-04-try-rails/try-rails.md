# Ruby on Rails <!-- .slide: data-background="../img/5xruby_bg_chapter.png" -->


![](img/rails.png)

# Rails != Ruby


![](img/dhh.jpg)

## David Heinemeier Hansson


![](img/dhh-race-car.jpg)


# 誰用 Rails？
twitter, icook, goodlife, shopify, github, heroku, etc


# Full Stack
## 前端 + 後端 = 全端


# MVC
## Model, View, Controller


# DRY
## Don't Repeat Yourself
## 不要重複自己


# COC
### Convension Over Configuration
### 慣例優於設定

---

# 1 分鐘 Rails <!-- .slide: data-background="../img/5xruby_bg_chapter.png" -->


## 開始前⋯⋯

1. 終端機
2. 瀏覽器
3. 編輯器


## $ rails new
建立新專案
```bash
$ rails new hello # 建立 Rails 專案資料夾
$ cd hello
$ rails server    # 開啓 server
```
預設網址：http://localhost:3000


## $ rails generate
Rails 產生器
```bash
$ rails g scaffold post title content:text
$ rake db:migrate # 資料庫遷移
```

http://localhost:3000/posts

---

## 前置觀念

- HTTP（Hypertext Transfer Protocol）
- REST（Representational State Transfer）
- MVC（Model, View, Controller）
- ERM（Entity Relation Model）