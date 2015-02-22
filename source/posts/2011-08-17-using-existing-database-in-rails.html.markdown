---
title: "將現有資料庫導入 Rails ActiveModel"
date: 2011-08-17 17:45 +0800
category: 程式
tags: Ruby, Ruby on Rails
---

官方說明文件上沒有這方面的說明，網路上爬到的解大多過時，或者根本不正確，於是作此文分享我目前的方法。

當使用 rails 指令產生新的 Model 時，這樣的寫法很常見：

<!-- more -->

```
$ rails g model my_model
      invoke  active_record
      create    db/migrate/yyyymmddhhMMss_create_my_models.rb
      create    app/models/my_model.rb
      invoke    test_unit
      create      test/unit/my_model_test.rb
      create      test/fixtures/my_models.yml
```

```ruby
class CreateMyModels < ActiveRecord::Migration
  def self.up
    create_table :my_models do |t|
      t.timestamps
    end
  end
 
  def self.down
    drop_table :my_models
  end
end
```

```ruby
# app/models/my_model.rb
class MyModel < ActiveRecord::Base
end
```

當然，如果對於要產生新的 schema 來說，這的確是個好方法。但有有時候我們需要使用資料庫上既有的 table（例如接管某個 legacy database，尤其是這個 database 原先不是架構在 RoR 之上），如此 migratoin 顯得多餘，如果只是單純想要有個 model 介面來撈資料，可能需要解決以下問題：

1. 不要產生 migration

   因為我們只是想去撈資料，而非更動 table，自然不需要 migrate

2. 並非所有 table 都是複數

   指令產生的 migration 可見 table name 預設為 model name 的複數型，但我們的 table 未必如此

3. 並非所有的 primary key 都叫 id

   schema 裡頭除了定義使用者自訂的 column 之外，rails 預設會加上 id 和時間戳記（created_at 和 updated_at），而 id 同時也是 primary key 且 預設為 auto_increment，此外 primary key 也有可能是字串

4. 有些 primary key 包涵多個 column（composite primary key）

   又稱「組合鍵」，即主鍵由多個欄位組成。遺憾的，RoR 並沒有支援 composite primary key

以下聽我娓娓道來。

## 不要產生 Migration

那就是直接建立 `app/models/my_model.rb`

```ruby
# app/models/my_model.rb
class MyModel < ActiveRecord::Base
end
```

但是建議最好還是以指令方式產生比較省時，記得加上 --skip-migration 參數即可，除此還可以得到 test unit。

```
$ rails g model my_model --skip-migration
      invoke  active_record
      create    app/models/my_model.rb
      invoke    test_unit
      create      test/unit/my_model_test.rb
      create      test/fixtures/my_models.yml
```

## 設定 Table Name

第一步已經完成了，假設我們想撈資料的 table name 為 my_table，我們產生的 model name 為 my_model，按照 Rails convention 法則，應該要有 table 名為 my_models 才是。但假設我們卻想掛羊頭賣狗肉地把 my_model 裝在 my_table 上：

```ruby
app/models/my_model.rb
class MyModel < ActiveRecord::Base
  set_table_name :my_table
end
```

試試看，成功了： 

```
$ rails c
Loading development environment (Rails 3.0.9)
irb(main):001:0> MyModel
=> MyModel(id: integer, title: string, description: text)
```

但這只有在 id column 跟好是 primary key 才會這麼順利，萬一 primary key 是別的 column，光這樣這定還不夠。

## 設定 Primary Key

假設 primary key 是 title：

```ruby
# app/models/my_model.rb
class MyModel < ActiveRecord::Base
  set_table_name :my_table
  set_primary_key :title # or 'self.primary_key = :title'
  # This method is also aliased as primary_key=
end
```

正常情況下，Active Record 會在我們產生新的 record 時自動產生 primary key，名為 id ，且是會遞增的整數。然而，如果我們在 table 上使用其他 column name 做為 primary key 的名字，我們同時有責任要重新定義該 record 上的 primary key，正如上方展示的程式碼。

神奇的事發生了，我們仍可以透過 id 方法去存取的 primary key。這是因為 Active Record 慣於將 primary key 的操作綁在 id 和 id= 等方法，而 set_primary_key 只是投射 id 會指向的 column name。下方程式碼展示了在 primary key 是 "title" 的情況下用 id 去存取 primary key：

```
irb(main):010:0> MyModel.first.stuid
=> "A Title"
irb(main):011:0> MyModel.first.id # same as MyModel.first.title
=> "A Title"
irb(main):012:0> MyModel.find("A Title")
=> #<MyModel id: "A Title", title: "A Title", description: "A Description">
irb(main):013:0>
```

相當乾淨俐落地解決了第三個問題，至於第四個問題，composite primary key，該怎麼辦？假設該 composite primary keys 分別為 title 和 description。恩，加個's'：

```ruby
class MyModel < ActiveRecord::Base
  set_table_name :my_table
  set_primary_keys :title, :description
end
```

然後你會免費被贈送一個 NoMethodError Exception。在你一邊擦螢幕時，請聽我說：既然RoR都說不支援了，哪有這麼簡單的事情讓你加個's'就解決呢？這個問題目前的解決方案是透過 plugin 來實現。你可以參考[這一頁](http://weblog.rubyonrails.org/2006/7/30/composite-primary-keys-for-active-record)。你會發現，裝完這個 plugin 之後，確實就只要加上一個 `s`。XD