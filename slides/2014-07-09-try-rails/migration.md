# Migration <!-- .slide: data-background="../img/5xruby_bg_chapter.png" -->
## 資料庫遷移


```bash
$ rails g scaffold post title content:text
```


## $ tree db/migrate/

```no-highlight
db/migrate/
└── 20140624153657_create_posts.rb
```
```ruby
class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.timestamps
    end
  end
end
```
<!-- .element: style="font-size: 0.9em;" -->


## $ rake db:migrate:status
資料庫遷移資訊
```bash
$ rake db:migrate:status

database: hello_development

 Status   Migration ID    Migration Name
--------------------------------------------------
   up     20140624153657  Create posts
```
<!-- .element: style="font-size: 0.8em;" -->


## $ rake db:migrate
執行資料庫遷移檔到最新版


## $ rake db:rollback
退回上一個資料庫遷移版本
```bash
$ rake db:migrate:status

database: hello_development

 Status   Migration ID    Migration Name
--------------------------------------------------
  down    20140624153657  Create posts
```
<!-- .element: style="font-size: 0.8em;" -->


## 資料形態

```bash
$ rails g ACTION NAME [field[:type]...]
```
<!-- .element: style="font-size: 0.8em;" -->

資料形態       | 說明
-------------- | ----
string（預設） | 字串（255）
text           | 長字串（65536）
integer        | 整數
float          | 浮點數
decimal        | 高精浮點數
datetime       | 日期 + 時間（YYYY-MM-DD HH:MM:SS）
timestamp      | 時間戳記（Unix Time）
time           | 時間（HH:MM:SS）
date           | 日期（YYYY-MM-DD）
binary         | 二進制內容
boolean        | 布林值