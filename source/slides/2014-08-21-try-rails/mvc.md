# MVC 
## Model, View, Controller


![](img/browsers.jpg)


## HTTP
### Request-response Pattern
### 一問一答


![](img/client_server.png)


## URL
### Uniform Resource Locator
![](img/url.png)


![](img/client_server_2.png)


![](img/mvc_simple.png)

---

# 目錄結構 


## $ tree hello -L 1
```no-highlight
hello/
├── Gemfile # 網站需要的 gem
├── app     # 網站主要的程式碼
├── config  # 網站的設定
├── db      # 資料庫遷移相關
├── lib     # 放置獨立於網站的程式
├── log     # 網站記錄
├── public  # 網站根目錄
└── vendor  # 同 app ，但放第三方的程式
```


## $ tree app -L 1
```no-highlight
app/
├── assets
├── controllers <-
├── helpers
├── mailers
├── models      <-
└── views       <-
```


## $ tree app -L 2
```no-highlight
app/
├── controllers
│   ├── application_controller.rb
│   └── posts_controller.rb
└── models
    └── post.rb
```


## $ tree app/views -L 2
```no-highlight
app/views/
├── layouts
│   └── application.html.erb
└── posts
    ├── _form.html.erb
    ├── edit.html.erb
    ├── index.html.erb
    ├── new.html.erb
    └── show.html.erb
```

---

# Controller  


## $ rake routes
全站網址路由
```no-highlight
$ rake routes
Verb URI Pattern     Controller#Action
GET  /posts          posts#index
POST /posts          posts#create
GET  /posts/new      posts#new
GET  /posts/:id/edit posts#edit
GET  /posts/:id      posts#show
```
由 `config/routes.rb` 定義


## $ rails generate controller
```no-highlight
$ rails g controller pages about
```
```ruby
# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def about
  end
end
```
<!-- .element: style="font-size: 0.9em;" -->

```no-highlight
$ rake routes
       Prefix Verb URI Pattern  Controller#Action
  pages_about GET  /pages/about pages#about
```
<!-- .element: style="font-size: 0.8em;" -->


## config/routes.rb

```ruby
get 'pages/about' # 預設：pages#about
get 'xxx', to: 'posts#index' # 特別指定
```
<!-- .element: style="font-size: 0.9em;" -->

```no-highlight
$ rake routes
      Prefix Verb   URI Pattern  Controller#Action
 pages_about GET    /pages/about pages#about
         xxx GET    /xxx         posts#index
```
<!-- .element: style="font-size: 0.8em;" -->

---

# View 


## ERB

```html
<%= %> <!-- 執行、顯示最後回傳值 -->
<%  %> <!-- 僅執行 -->
```


```html
<%
  a = 123 + 456 + 789
  b = 123 * 456 * 789
  c = a + b
%>

Answer: <%= c %>
```


```html
<% if true %>
  True
<% else %>
  False
<% end %>
```


```html
<ul>
  <% @posts.each do |std| %>
    <li><%= std.name %></li>
  <% end %>
</ul>
```


## 實體變數傳遞
Passing Instance Variable
```ruby
# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def about
    @a = 123
  end
end
```
<!-- .element: style="font-size: 0.9em;" -->

```html
<!-- app/views/pages/about.html.erb -->
<%= @a %>
```


```ruby
# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def about
    @std = post.last
  end
end
```
<!-- .element: style="font-size: 0.9em;" -->

```html
<!-- app/views/pages/about.html.erb -->
<%= @std.name %>
<%= debug @std %>
```


## Layouts
Server Log
```no-highlight
Started GET "/pages/about" for 127.0.0.1 at 2014-06-25 01:25:08 +0800
Processing by PagesController#about as HTML
  Rendered pages/about.html.erb within layouts/application (0.4ms)
Completed 200 OK in 6ms (Views: 4.7ms | ActiveRecord: 0.0ms)
```
<!-- .element: style="font-size: 0.6em;" -->

- `pages/about.html.erb`
- `layouts/application`


```html
<!-- app/views/layouts/application.html.erb -->
<body>
  <%= yield %>
</body>
```
<!-- .element: style="font-size: 0.9em;" -->

---

# Model 


```ruby
# app/models/post.rb
class Post < ActiveRecord::Base
end
```


```ruby
@post.title   # => "今天"
@post.content # => "天氣不錯"
```


## $ rails console
irb for Rails
```ruby
# 新增到資料庫
post = Post.new
post.title = "標題"
post.save
```

```ruby
# 讀資料庫
post = Post.first
post.title
```


![](img/mvc.png)