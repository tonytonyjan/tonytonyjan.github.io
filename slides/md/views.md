<!-- .slide: data-background="../img/5xruby_bg_chapter.png" -->
# Rails Views
### Layout, Rendering, Form Helper


## 3 種製造 Response 的方法

- render：泛用方法
- redirect_to：302 重導
- head：空 body，只有 HTTP head

---

# Render


## 相同 controller
```ruby
render :edit
render action: :edit
render 'edit'
render 'edit.html.erb'
render action: 'edit'
render action: 'edit.html.erb'
```
若在 `PostsController` 下 render，檔案為 `app/views/posts/edit.html.erb`


## 不同 controller
```ruby
render 'products/edit'
render 'products/edit.html.erb'
render template: 'products/edit'
render template: 'products/edit.html.erb'
```
無論在哪個 controller 下 render，檔案為 `app/views/products/edit.html.erb`


## 絕對路徑
```ruby
render '/path/to/your/file'
render '/path/to/your/file.html.erb'
render file: '/path/to/your/file'
render file: '/path/to/your/file.html.erb'
```
<!-- .element: style="font-size: .95em" -->


## inline 寫法

```ruby
render inline: '<h1><%= @post.title %></h1>' # ERB
render plain: 'OK'                           # 純文字
render body: 'raw'                           # 純文字
render html: '<p>Hello</p>'.html_safe        # HTML
render json: @product                        # JSON
render xml: @product                         # XML
render js: 'alert('Hello Rails');'           # JS
```
<!-- .element: style="font-size: .8em" -->

js 的 GET 請求在 Rails 4.1 版被 `protect_from_forgery` 保護，避開方式：

```ruby
skip_before_action :verify_authenticity_token
```
<!-- .element: style="font-size: .9em" -->


## Headers & Status

```ruby
headers['Location'] = '/somewhere'
self.status = 302
```


## Options for render

Option       | 說明
------------ | ----
content_type | HTTP Content-Type header
layout       | Template Layout
location     | HTTP Location header
status       | HTTP Status Code


```ruby
render content_type: 'application/octet-stream'
render content_type: 'text/plain'
render layout: 'admin'
render layout: flase # no layout
render location: '/somewhere'
render status: 200
render status: :ok
```


## Render Nothing
```ruby
render nothing: true
```


# redirect_to
### 301、302 重導


```ruby
headers['Location'] = '/somewhere'
self.status = 302
render nothing: true
```
等於
```ruby
headers['Location'] = '/somewhere'
render nothing: true, status: 302
```
等於
```ruby
redirect_to '/somewhere'
```


# head
### Header-Only Response


```ruby
self.status = 404
render nothing: true
```
等於
```ruby
head 404
```
等於
```ruby
head :bad_request
```


## 範例
```ruby
if @post.save
  head 201 # created
else
  head :bad_request
end
```

---

# Layout


```no-highlight
<html>
  <head>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
```
此處 `yield` 會依照情境將 views 內的檔案在此處展開


## content_for
```no-highlight
<div class="container">
  <div class="col-sm-2">
    <%= yield :sidebar %>
  </div>
  <div class="col-sm-10">
    <%= yield %>
  </div>
</div>
```

```no-highlight
<% content_for :sidebar do %>
  <h1>Side bar</h1>
<% end %>
```


## content_for?
```no-highlight
<div class="container">
  <% if content_for? :sidebar %>
    <div class="col-sm-2"><%= yield :sidebar %></div>
    <div class="col-sm-10"><%= yield %></div>
  <% else %>
    <%= yield %>
  <% end %>
</div>
```
<!-- .element: style="font-size: .8em" -->


## Multiple Layout
```ruby
class PostsController < ApplicationController
  layout 'special' # 預設為 application
  class index
  end
  ...
end
```
<!-- .element: style="font-size: .75em" -->

```ruby
render 'template', layout: 'special'
# app/views/layouts/special.html.erb
```


## Nested Layout
`app/controllers/products_controller.rb`
```ruby
class PagesController < ApplicationController
  def about
    render layout: 'side'
  end
end
# application.html.erb 與 side.html.erb 只差一點
```
<!-- .element: style="font-size: .9em" -->


`layouts/application.html.erb`
```no-highlight
<div class="container">
  <%= content_for?(:content) ? yield(:content) : yield %>
</div>
```
<!-- .element: style="font-size: .7em" -->

`layouts/special.html.erb`
```no-highlight
<% content_for :content do %>
  <div class="col-sm-2"><%= yield :sidebar %></div>
  <div class="col-sm-10"><%= yield %></div>
<% end %>
<%= render template: 'layouts/application' %>
```
<!-- .element: style="font-size: .8em" -->

---

# Partial


```html
<!-- views/CONTROLLER/_menu.html.ber -->
<%= render 'menu' %>
<%= render partial: 'menu' %>

<!-- views/shared/_navbar.html.ber -->
<%= render 'shared/navbar' %>
```


## 變數傳遞
`products/new.html.erb`

```no-highlight
<%= render 'form', product: @product %>
<%= render partial: 'form', locals: {product: @product} %>
```
<!-- .element: style="font-size: .7em" -->

`products/_form.html.erb`
```no-highlight
<%= form_for(zone) do |f| %>
  ...
<% end %>
```


## Model Partial

`products/_product.html.erb`
```no-highlight
<tr>
  <td><%= product.name %></td>
  <td><%= product.description %></td>
  <td><%= product.price %></td>
  <td><%= product.volume %></td>
  <td><%= link_to 'Show', product %></td>
  <td><%= link_to 'Edit', edit_product_path(product) %></td>
  <td><%= link_to 'Destroy', product, method: :delete, data: { confirm: 'Are you sure?' } %></td>
</tr>
```

`products/index.html.erb`
```no-highlight
<%= render @products %>
```