---
title: Rails 購物車設計
image: /images/cart.png
thumb: /images/thumbs/cart.png
date: 2015-08-05 21:14 +0800

tags: [Rails, Cart]
---

![](/images/cart.png)

> 封面圖片為 Minecraft 遊戲的截圖，軌道上的貨車（cart on rails），筆者也算是從 alpha 版就開始玩的老玩家呢。

隨著電子商務的崛起，網站上的購物車系統已經成了普遍的功能，這幾年 Rails 在台灣也快速竄紅，且由 Dave Thomas 與 David Heinemeier Hansson 所著的「[Agile Web Development with Rails 4](https://pragprog.com/book/rails4/agile-web-development-with-rails-4)」一書中也有購物車範例。即便如此，仍然有許多開發者對於設計真正可用的購物車平台感到挫折。

其中一個理由是書中對於購物車、訂單、發票等規劃並沒有詳細的介紹，其二則是台灣的第三方支付並沒有任何一家廠商提供足夠友善的 API 供開發者使用。

# 購物車系統起手式

該如何設計一個購物車系統呢？在思考這個問題前不妨先想想從挑選商品到放入購物車，到最後結帳的過程中，可以切出哪些 entity 以方便規劃資料庫，我們隨即可以直覺的想到有「商品」與「購物車」，而以下就是一個初步的 [Entity-Relation diagram](https://www.wikiwand.com/en/Entity%E2%80%93relationship_model)：

![](/images/erd/2.png)

## 保留金額資訊

沒道理筆者拿了一罐牛奶，你就只能挑豆漿，所以研判一個購物車可以有多個產品，且一個產品放進多個購物車，而這樣的設計圖乍看完美卻有個問題：試想當一個訪客挑選了一樣產品，並且放入購物車，這時如果該產品的價錢被後台管理員異動，那麼在訪客結帳之前購物車中的商品價錢也需要異動嗎？

如果這是被允許的，那麼筆者可以在訪客結帳的前一秒，將價錢偷改為幾百萬（之後幾年就是官司人生），於是我們需要新的設計避免這樣的悲劇：

![](/images/erd/3.png)

這樣就好了許多，LineItem（在其他 Rails 的專案中，有的人會將 LineItem 命名為 CartItem）作為關聯 Product 與 Cart 的角色之外，還需額外儲存數量與金額資訊，這個金額必須是該產品加入購物車當下的數字，如此結帳時才不會有爭議價錢異動的爭議。

## 「訂單」與「購物車」的差異？

「訂單」與「購物車」在電子商務系統中扮演的角色相似卻也有些差異，相似是兩者都同樣會記錄訪客加入購物車的商品的當前價錢與數量，差異則是「購物車」可編輯商品資訊（例如數量或新增商品），但「訂單」除了付款之外，不可再異動商品資訊，且「訂單」會擁有更多如地址、姓名、統編等一類的通訊資料。

加上「訂單」後的設計圖：

![](/images/erd/5.png)

## 付款紀錄

「訂單」不能異動，唯一可以執行的動作就是「付款」。可是付款未必每次都會成功，且無論成功與否都應該留個記錄，記錄除了方便管理員查詢、找出問題之外，也能提供給使用者供參考與留存。

「交易紀錄」不需通訊資料，只需要記錄成功與否、交易編號即可，以下是新的設計圖：

![](/images/erd/7.png)

你大概會注意到 Trade 有個 `params:text` 屬性，這是用來存放第三方支付服務所回傳的資料，可能是 JSON 或是 XML 格式，搭配 ActiveRecord 中的 [`#serialize`](http://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Serialization/ClassMethods.html#method-i-serialize)，可以輕易存取這個欄位以供日後的查閱由服務所回傳的原始交易資料。

# 其他人怎麼做？

像購物車系統如此常見的功能，想必也有許多開源項目可以使用，其中最有名的三個專案分別是：

- [ror_ecommerce](https://github.com/drhenner/ror_ecommerce)
- [Spree](https://spreecommerce.com/)
- [Piggybak](https://github.com/piggybak/piggybak)

## ror_ecommerce

![](/images/ror-ecommerce.png)

是由 [David Henner](https://github.com/drhenner) 在設計一個電子商務系統時，順手開源的項目，並且寫了[一個網站](http://www.ror-e.com/)解釋他的設計哲學，即便這個項目是三個之中更新最慢的，但對於想學習如何徒手製作電子商務網站的人來說，筆者認為這是最值得參考的學習文件。

ror_ecommerce 的資料庫設計與本篇文章的示意圖、以及「Agile Web Development with Rails 4」書中的範例相同。

## Spree

![](/images/spree.jpg)

Spree 是 Rails 開源電子商務圈最著名的項目，是由許多資深工程師組成的核心團隊所開發，其中不乏 Apache 軟體協會的成員與公司的 CTO、CEO，品質保證，加上完整的 API、文件以及活絡的社群，此外與 ActiveMerchant 相容性高，對於單純只是想要快速架設電子商務網站的人來說，Spree 堪稱首選。

資料結構方面，有別於前述的架構，Spree 並沒有 Cart entity，而是在 Order 之中新增一個 `state` 屬性將「訂單」偽裝成「購物車」的行為，導致 Order 的行為邏輯比 Cart 複雜，但是可以實現的功能更多。

## Piggybak

![](/images/piggybak.png)

算是 Rails 開源電子商務的後起之秀，沒有 Spree 那樣完備，但其模組化的彈性使得許多開發者也開始投像 Piggybak 的懷抱，這層關係有點像 Paperclip 與 CarrierWave 之間一樣，後者也是以模組化著稱。

你可以在 Rails 中任何一個 ActiveRecord model 中掛上 `acts_as_sellable` 使其成為可以買賣的商品，相當簡便，如果你想要的是在既有的網站上加上購物功能，而非重新打造一個購物網站，也許這是讓你選擇 Piggybak 而非 Spree 的誘因。

# 結語嗎

購物車系統沒有什麼「一定得這樣」的設計，不管是什麼架構的購物車，可以結帳的就是好的購物車。如果對於設計購物車仍有疑惑，也建議不妨多看看他人的開源項目怎麼設計，其實許多書中找不到的答案，都放在程式碼裡面，而優良的程式碼更是可以閱讀的。

筆者也有一份串接歐付寶的範例網站就放在 [Github](https://github.com/tonytonyjan/brainana_shop) 上，有興趣的讀者可供參考，當然，也歡迎送 patch =)
