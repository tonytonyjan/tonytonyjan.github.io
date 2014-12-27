<!-- .slide: data-background="../img/5xruby_bg_chapter.png" -->
![](../img/devise.png)
### 使用者驗證工具
https://github.com/plataformatec/devise


## 最簡單的會員系統
### 註冊、登入、登出


## devise 內建

- 一般註冊、登入、登出
- 社群網站整合（FB、G+ 等）
- 註冊驗證信
- 忘記密碼
- 歷史記錄（登入次數、上次登入、IP）
- 信箱、密碼驗證
- 封鎖功能


## 安裝

```ruby
# Gemfile
gem 'devise'
```

```no-highlight
$ bundle install
$ rails g devise:install
$ rails g devise user
$ rake db:migrate
```

安裝新 gem 要重啟 server


## Flash Message

```no-highlight
<!-- app/views/application.html.erb -->
<div><%= notice %></div>
<div><%= alert %></div>
```


## Generated Methods

```ruby
authenticate_NAME! # 用在 controller
NAME_signed_in?
current_NAME
```

如果 `rails g devise user`，則：

```ruby
authenticate_user!
user_signed_in?
current_user
```


## 限制訪客
```ruby
class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_user!, only: [:create, :update]
  before_action :authenticate_user!, except: :index
end
```
<!-- .element: style="font-size: .65em;" -->


## jquery_ujs

```html
<a href="/users/sign_up"></a>
<a href="/users/sign_in"></a>
<a href="/users/sign_out" data-method="delete"></a>
```
<!-- .element: style="font-size: .8em;" -->


## 辨識登入者

```ruby
user_signed_in?
current_user # => User object
```