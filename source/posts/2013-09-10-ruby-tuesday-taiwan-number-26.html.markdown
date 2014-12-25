---
title: "Ruby Tuesday Taiwan #26"
date: 2013-09-10 20:07 +0800
comments: true
categories: 閒聊
---

## Topic 1

講者：Chris Sun  
主題：重構輕旅

介紹如何在重構的過程中，試著重新認識領域甚至發掘潛在問題。

糟糕……我聽不太懂啊……Orz，另外其實投影片大部分是 code，我這裡就不做筆記了XD（偷懶）

其中有提到 Ruby 還沒有很方便的 IDE（講者表示不比 10 年前的 Java IDE）。我本身不用 IDE，當然重構可能也都是靠 grep、sed、regular expression，這類東西去做換名字或是複製貼上等等的工作，沒有遇到什麼大問題（不過應該是我程式寫不夠大的關係XD）。

## Topic 2

講者：Kevin Wang  
主題：別再偷我App裡的金幣, 淺談Server端In-App Purchase的處理與驗證

介紹有關用Rails處理處理手機APP的 In-app Purchase的運作流程以及注意要點和加速方式, 請注意本場的長度將會有1小時。

### In-App Purchase (IAP)

* One-Time Purchase/Consumable
* Subscription
* Auto-renewable Subscription

### 處理 IAP 流程

1. 接受 App 傳來的資訊
2. 資料驗證
3. 三方驗證（TPV）
4. 紀錄交易內容
5. 更新使用者？？
6. 回傳結果

### 三方驗證（TPV）

1.  準備傳給 Store 的資料
2.  接受 Store 回傳的資料

    *   Store 驗證成功，回傳相關的交易資訊
    *   Store 驗證失敗，回傳錯誤訊息
    *   Store 回傳一個未知的錯誤格式
    *   Store timeout

這個講者除了幽默之外也講的頗仔細，範例以 Rails 和 iOS 為例。這場也聽的吃力，一來因為我沒有寫 mobile app，二者則是我都避免去碰金流:P（寫應用最痛的就是這部份XD）。
