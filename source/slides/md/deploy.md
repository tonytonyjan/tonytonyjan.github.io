# 部署 <!-- .slide: data-background="../img/5xruby_bg_title.png" -->
### 使用 Heroku


## 事前準備
1. 註冊 Heroku 帳號：https://www.heroku.com/
2. 下載指令工具：https://toolbelt.heroku.com/


## 修改 Gemfile

```ruby
# Gemfile
gem 'sqlite3', group: :development
group :production do
  gem 'rails_12factor'
  gem 'pg'
end
```

1. Heroku 使用 PostgreSQL，不給安裝 sqlite
2. `rails_12factor` 指的是 http://12factor.net/，是 Heroku 團隊在建制 Heroku 的時候，將一些設計方法整理成的文件。


## 開始部署

```bash
$ heroku create # 新增專案
$ git push heroku master # 自動部署
$ heroku open # 開啓瀏覽器
```


## 遠端指令
```ruby
$ heroku run rake db:migrate
$ heroku run rake fake:categories \
fake:products fake:carts
```