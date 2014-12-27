# 自己來 / DIY
note: 所以後來我發現後台還是自己 DIY 會比較好一點。


## Single Model
```ruby
class Account < ActiveRecord::Base
  def foo; end
  def bar; end

  # API
  def as_yaml; end
  def as_xml; end
  def as_json; end

  # Admin
  def reset; end
  def clear_data; end
  def transfer_money; end
end
```
- 不同概念的方法混在同一個地方
- 行數太多

note: DIY 的方法很多，過去可能會這樣寫，但是隨著專案的長大，所有方法都會擠在同一個 model。這樣的壞處除了維護上比較吃力之外，還把一些敏感的方法混在一起。

---

## Mix-in

```ruby
class Account < ActiveRecord::Admin
  include AccountApi
  include AccountAdmin
  def foo; end
  def bar; end
end
```
- 每個 model 都有自己的 mix-in module
- 這些 module 只用一次

note: 既然如此，那就用 Mix-in 的技巧吧，這樣就解決了剛剛的問題，程式碼看起來也比較有機可循一點。但這樣設計有點和 mix-in 的初衷背道而馳。mix-in 的功能應該是把可重復利用的東西抽出來。但在這裡的示範看來不是如此。

除了每個 model 都要額外設計自己的 mix-in module 之外，而且還只用一次。所以我還得想其他更好的方法。

---

## 分離前後台
2 個 Rails 專案，共用 1 個資料庫

- 前後台的 model 邏輯分離 - 安全
- 前後台開發不會互相干擾 - 穩定

note: 達到這樣的目標，我找到了第一個簡單可行的方法是分離前後台。也就是由兩個 Rails 專案共用同一個資料庫。這樣的好處是有些後台才會使用到的敏感功能，只有後台才有用到。一般閒雜人等不管瀏覽到網站的哪裡，絕對碰不到後台的 model。

另外一個好處是前後台的開發不會互相干擾，且可以分別獨立運作。


前台 `front/app/models/account.rb`

```ruby
class Account < ActiveRecord::Base
  ...
end
```
------
後台 `admin/app/models/account.rb`

```ruby
class Account < ActiveRecord::Base
  ...
  def clear_data
    ...
  end
  def transfer_money(account)
    ...
  end
  ...
end
```

- 太多重複的程式碼 <!-- .element: class="fragment" -->
- 管理 2 份的代價 <!-- .element: class="fragment" -->

note: 這一頁是用這個方法大概會呈現的樣子，後台的 class 比前台的 class 多了一些只有管理員可以用的方法，這樣做相對安全許多。

這樣的方式在我之前幾個專案也管放被用到，但是後來發現這樣子不太好。雖然後台的 model class 比前台多了一些方法，但在前台的 model 有的方法，往往後台也有，反而多了很多重複的程式碼，違反了 Rails 的 DRY 哲學。

另一個麻煩則是我原本的 1 份 repository 變成需要管理 2 份 repositories，事實上不只，因為我可能會為了解決上述的 model 重複程式碼的問題，用到了 git submodule，等於是無形的增加了維護門檻。

---

## 訴求

- 容易調整
- 易於維護
- 安全穩定

note: 後來發現設計一個後台沒有這麼容易，除了兼顧易於調整、維護之外，還要足夠安全。

這種方式雖然有他的優點在，但對於工程師不多的接案團隊來說，這種方法過於吃力，所以我想到用另外一種方式，就繼承。