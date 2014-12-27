# Model


```ruby
product = Product.create name: 'Foo'
product = Product.find(1)
product.update name: 'Bar'
product.destory
```


## Query


## where

```ruby
# 純字串用法
Product.where("price = '100'")
# 陣列用法
Product.where("price = ?", 100)
# 多條件
Product.where("price = ? AND volume = ?", 100, 10)
```


## Hash 用法
```ruby
Product.where(is_online: true)                    # Boolean
Product.where(id: [1,2,3])                        # Array
Product.where(created_at: Time.now)               # Time
Product.where(id: (1..2))                         # Range
Product.where(created_at: (3.days.ago..Time.now)) # Range
```
<!-- .element: style="font-size: .7em" -->


## 否定

```ruby
Product.where.not(id: (1..2))
```


## order

```ruby
Product.order(created_at: :desc)
Product.order(created_at: :asc)
Product.order("created_at DESC")
Product.order("created_at ASC")
```


## limit & offset

```ruby
Product.limit(10) # 前 10 個
Product.limit(10).offset(10) # 第 11 ~ 20 個
```
<!-- .element: style="font-size: .95em" -->


## 資料驗證（Validation）

```ruby
class Product < ActiveRecord::Base
  validates :name, presence: true
end

Product.create(name: "冰箱").valid?
Product.create(name: nil).valid?
```


## validates

```ruby
# 用法：validates names, options
validates :name, presence: true
validates :name, :price, presence: true
validates :price, presence: true, inclusion: {in: 0..9}
```
<!-- .element: style="font-size: .75em" -->


## Association


![](../img/erm.png)


```ruby
Product.all # 得到全部的產品
category = Category.first
category.products # 得到屬於該分類的產品
Product.first.category # 得到該產品的分類
```


```no-highlight
$ rails g scaffold category name
$ rails g migration add_category_id_to_products category_id:integer
```
<!-- .element: style="font-size: .6em" -->

category_id 在關聯式資料庫中扮演 forign key 的角色

```ruby
class Category < ActiveRecord::Base
  has_many :products
end
 
class Product < ActiveRecord::Base
  belongs_to :category
end
```


```ruby
Category.products
# Product.where(category_id: id)
Category.products<<
# 跟 Array#push 一樣
Category.products.find
# Product.where(category_id: id).find(id)
```
<!-- .element: style="font-size: .9em" -->


```ruby
Category.products.build
# Product.new("category_id" => id)
Category.products.new
# Product.new("category_id" => id)
Category.products.create
# p = Product.new("category_id" => id); p.save; p
```
<!-- .element: style="font-size: .8em" -->