# Helper


## URL Helper

```no-highlight
$ rake routes
  Prefix Verb   URI Pattern             Controller#Action
    root GET    /                       pages#index
   about GET    /about(.:format)        pages#about
```
<!-- .element: style="font-size: .7em" -->

 Prefix | Helper        | Return
 ------ | ------------- | -------------
 root   | root_path     | /
        | root_url      | http://host
 about  | about_path    | /about
        | about_url     | http://host/about


```html
<a href="/products/new">New Product</a>
<a href="/about">About</a>
```
<!-- .element: style="font-size: .8em" -->

```html
<a href="<%= new_product_path %>">New Product</a>
<a href="<%= about_path %>">About</a>
```
<!-- .element: style="font-size: .8em" -->


## HTML Tag Helper

- tag(name, options = nil)
- content_tag(name, content = nil, options = nil)
- content_tag(name, options = nil, &block)


## tag

```ruby
tag("br")
# => <br />
tag("input", type: 'text', disabled: true)
# => <input type="text" />
```
<!-- .element: style="font-size: .95em" -->


```
<img src="http://i.imgur.com/6H17ygE.jpg">
<br>
<hr>
```
<!-- .element: style="font-size: .95em" -->

```ruby
tag :img, src="http://i.imgur.com/6H17ygE.jpg"
tag :br
tag :hr
```
<!-- .element: style="font-size: .9em" -->


## content_tag

```ruby
content_tag(:p, "Hello world!")
# => <p>Hello world!</p>

# 可以巢狀包裹
content_tag(:div, content_tag(:p, "Hello world!"), class: "strong")
# => <div class="strong"><p>Hello world!</p></div>

# block 的寫法
<%= content_tag :div, class: "strong" do -%>
  Hello world!
<% end -%>
# => <div class="strong">Hello world!</div>
```
<!-- .element: style="font-size: .6em" -->


## 一般用法
```html
<li><a href="/products/new">New Product</a></li>
```
<!-- .element: style="font-size: .8em" -->

```ruby
content_tag :li, content_tag(:a, "New Product", href="/products/new")
```
<!-- .element: style="font-size: .6em" -->


## block 用法
```no-highlight
<p>
  <strong>Name:</strong>
  <%= @product.name %>
</p>
```

```no-highlight
<%= content_tag :p do %>
  <%= content_tag :strong, "Name" %>
  <%= @product.name %>
<% end %>
```


## link_to

```ruby
link_to name, url_or_object
link_to 'New Product', '/products/new'
link_to 'New Product', new_product_path
link_to 'View', product_path(product.id)
link_to 'View', product_path(product)
link_to 'View', product
```


## Form Helper

```html
<!-- app/views/layouts/_navbar.html.erb -->
<form action="/products" class="navbar-form navbar-left" role="search">
  <div class="form-group">
    <input name="q" type="text" class="form-control" placeholder="Search">
  </div>
  <button type="submit" class="btn btn-default">Submit</button>
</form>
```
<!-- .element: style="font-size: .55em" -->


## form_tag

```ruby
form_tag('/posts')
# => <form action="/posts" method="post">

form_tag('/posts/1', method: :put)

<%= form_tag('/posts') do -%>
  <div><%= submit_tag 'Save' %></div>
<% end -%>
```
<!-- .element: style="font-size: .9em" -->


```no-highlight
<%= form_tag products_path, method: :get, class: 'navbar-form navbar-left', role: 'search' do %>
  <div class="form-group">
    <%= text_field_tag :q, nil, class: 'form-control', placeholder: 'Search' %>
  </div>
  <%= button_tag 'Submit', class: 'btn btn-default' %>
<% end %>
```
<!-- .element: style="font-size: .5em" -->


## content_tag_for & form_for


## content_tag_for
app/views/products/index.html.erb
```no-highlight
<% @products.each do |product| %>
  <tr>
    <td><%= product.name %></td>
  </tr>
<% end %>
```

```no-highlight
<% @products.each do |product| %>
  <%= content_tag_for :tr, product %>
    <td><%= product.name %></td>
  <% end %>
<% end %>
```


## form_for

```no-highlight
<%= form_for product do |f| %>
  <%= f.text_field :name %>
<% end %>
```


## 自製 helper

```html
<li>
  <a href="/products/new">New Product</a>
</li>
```

```ruby
# app/helpers/application_helper.rb
def nav_li name, url
  content_tag :li do
    link_to name, url
  end
end
```
<!-- .element: style="font-size: .95em" -->