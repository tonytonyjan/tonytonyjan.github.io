---
title: "Rails 4.2 重點介紹"
date: 2014-12-20 09:46:11 +0800
categories: Rails
---

Rails 團隊終於要在[聖誕節](http://weblog.rubyonrails.org/2014/12/19/Rails-4-2-final)的同時釋出 Rails 4.2 版了，這次更新的重點有以下項目：

- Active Job
- Asynchronous mails
- Adequate Record
- Web Console
- Foreign key support

<!-- more -->

## Active Job

一個網站常有些較繁重的工作，並不希望在使用者提出請求時立即執行，以寄出一萬封信為例，這也許需要幾分鐘的時間，當使用者點下寄信按鈕時如果還需要等個幾分鐘才可以看到回傳頁面，這將造成糟糕的使用者體驗。

正規的作法是將這類需要長時間的工作丟到工作佇列去排程，並在背景中執行多個 worker 程序，每個 worker 都會不斷重複從佇列中取得新的工作去執行。

Rails 已經有許多 gem 可以解決這個問題，著名項目包括 [Resque](https://github.com/resque/resque)、[Sidekiq](http://sidekiq.org/) 與 [DelayedJob](https://github.com/collectiveidea/delayed_job)，其中 Resque 與 Sidekiq 使用 Redis 存放工作住列，DelayedJob 則用關聯式資料庫。

Active Job 並不是提出了一個新的實作，換句話說，使用 Rails 4.2 並不代表未來就不用安裝 Resque 之類的 gem。

它的真正意義在於統一使用介面，讓開發者在不同的 gem 之間切換時，可以不用受到 gem 的不同 API 而影響，因而降低重新改寫的成本。

看到這裡是否覺得這種作法很熟悉？它其實就是適配器模式（Adapter pattern），早在 Active Record 誕生的時候就已經使用相同的技巧，Rails 之所以能以相同的 API 介面在不同的資料庫之間遊走也是拜此所賜。

目前支援的 gem 有：

```
$ ls -1 activejob/lib/active_job/queue_adapters
backburner_adapter.rb
delayed_job_adapter.rb
inline_adapter.rb
qu_adapter.rb
que_adapter.rb
queue_classic_adapter.rb
resque_adapter.rb
sidekiq_adapter.rb
sneakers_adapter.rb
sucker_punch_adapter.rb
test_adapter.rb
```

除了 `test_adapter.rb` 僅用於測試，以及 `inline_adapter.rb` 為預設（立即執行，不會丟入背景），以外都有相對的 gem 需要安裝。

### 使用方式

工作的內容必須定義在 `app/jobs/` 下，並繼承自 `ActiveJob::Base`，不過 Rails 4.2 提供了產生器，並不一定要手動新增：

```
$ rails g job execute_simulate
      invoke  test_unit
      create    test/jobs/execute_simulate_job_test.rb
      create  app/jobs/execute_simulate_job.rb
```

```ruby
# app/jobs/execute_simulate_job.rb
class ExecuteSimulateJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # Do something later
  end
end
```

`queue_as` 可以設定將此工作排進特定的佇列，預設是 `default`，可以透過 `--queue`
參數修改：

```
$ rails g job execute_simulate --queue urgent
```

使用起來像是這樣：

```ruby
# 將工作丟進佇列
ExecuteSimulateJob.perform_later record

# 排程明天中午再執行
ExecuteSimulateJob.set(wait_until: Date.tomorrow.noon).perform_later(record)

# 排程一週後執行
ExecuteSimulateJob.set(wait: 1.week).perform_later(record)

# 指定特定的佇列
ExecuteSimulateJob.set(queue: :important).perform_later(record)
```

設定要使用的 gem：

```ruby
# config/application.rb
module YourApp
  class Application < Rails::Application
    # 請確保 Gemfile 已經有安裝所要使用的 gem
    config.active_job.queue_adapter = :resque
  end
end
```

### 回呼（Callback）

共有以下 6 個註冊點：

- before_enqueue
- around_enqueue
- after_enqueue
- before_perform
- around_perform
- after_perform

使用方式與 controller、model 中的回呼寫法是一樣的：

```ruby
class ExecuteSimulateJob < ActiveJob::Base
  queue_as :default
 
  before_enqueue do |job|
    # 在佇列前執行
  end
 
  around_perform do |job, block|
    # 在工作開始前執行
    block.call
    # 在工作完成後執行
  end
 
  def perform
    # Do something later
  end
end
```

## Asynchronous Mails

如果寄信工作也要丟到工作佇列，先別急著寫工作檔，Rails 4.2 的 Action Mailer 內建了 `DeliveryJob` 類別，並提供 `deliver_later` 方法將寄信工作推進佇列。

你可以像這樣使用：

```ruby
# 使用 #deliver_later 透過 DeliveryJob 來寄信
MyMailer.welcome(@user).deliver_later

# 若不想丟到工作住列，也有 #deliver_now 可以使用
MyMailer.welcome(@user).deliver_now
```

## Adequate Record

由 Aaron Patterson 所作，用於提高 `#find`、`#find_by` 等一些常用查詢指令的速度，可以提升 Active Record 約莫兩倍的效能。

主要是因為 Active Record 在產生 SQL 過程有很多重複的片段不斷被重新製造，這其實可利用快取將重複的片段保存起來。細節請參考 [Aaron Patterson 的網誌](http://tenderlovemaking.com/2014/02/19/adequaterecord-pro-like-activerecord.html)。

## Web Console

如果你有用過 `better_errors` gem，那麼這就是類似的東西了。Rails 4.2 在開發環境下的錯誤頁面會多出一個 rails console 命令窗可以使用，除了一般 irb 的功能以外，也可以存取到該次請求中定義的實體與區域變數。

![Rails 4.2 Web Console](/images/web-console.png)

但不只有錯誤頁面才有命令窗可以使用，也可以在任何 view 的檔案中的任何位置加入 `<%= console %>`，只要渲染到該檔案，就有命令窗可以使用。

## 外鍵（Foreign Keys）

Rails 4.2 遷移指令支援了 SQL 的外鍵定義功能，目前只有 mysql、mysql2 與 postgresql 可用。

```ruby
# 將 `articles.author_id` 定義為參考 `authors.id` 的外鍵
add_foreign_key :articles, :authors

# 若命名沒有按照慣例，也可以透過設定達到
# 例如將 `articles.author_id` 定義為參考 `users.lng_id` 的外鍵
add_foreign_key :articles, :users, column: :author_id, primary_key: "lng_id"

# 刪除 `accounts.branch_id` 外鍵
remove_foreign_key :accounts, :branches
 
# 刪除 `accounts.owner_id` 外鍵
remove_foreign_key :accounts, column: :owner_id
```

這個功能在 migration 與 model 等會產生遷移檔的產生器，當使用到 `references` 型別時也會自動的被使用，例如：

```
$ rails g migration add_user_to_posts user:references
      invoke  active_record
      create    db/migrate/20141222180048_add_user_to_posts.rb
```

```ruby
class AddUserToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :user, index: true
    add_foreign_key :posts, :users # Rails 4.2 功能
  end
end
```
