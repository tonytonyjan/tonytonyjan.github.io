# Third-party Gems
- Rails Admin <!-- .element: class="fragment" -->
- Active Admin <!-- .element: class="fragment" -->

note: 記得我的第一個 Rails 專案，那時候沒有什麼製作後台的經驗，就去網路上四處找，最後找到兩個比較有名的項目。一個是 Rails Admin，另外一個則是 Active Admin。


<!-- .slide: data-background="img/rails-admin.png" -->
# Rails Admin


<!-- .slide: data-background="img/active-admin.png" -->
# Active Admin


# 安裝簡單
# Easy to Install

note: 他們兩個的共同特色是安裝簡單快速，大約五分鐘的時間就可以變出一個漂亮且堪用的後台。而且裡面已經附帶搜尋、統計、匯出 csv 檔案等功能。


# 調整困難
# Hard to Customize

note: 但是還是有缺點的，我覺得這兩個東西初衷很好，但畢竟不是銀彈。雖然一開始建製的時候方便，但到後期在擴展一些功能的時候會越搞越麻煩，常常為了一個小功能，浪費了一個下午的時間在讀文件和 hack 程式碼。

此外 bug 又是另外一回事情，尤其是 Active Admin。


![](img/what-gems-can-do.png)

第三方 Gems 提供的後台 v.s. 客戶需要的功能

note: 像我是靠接案為生，我遇到的大部分的狀況比較像這樣，客戶需要的功能可能包山包海包羅萬象。以下列舉：

1. 也許是個活動網站，客戶需要在主控台呈現月曆。
2. 需要靜態頁面。
3. 後台登入使用自製的驗證方式，而非 Devise。
4. 複雜的巢狀表單（nested resources form）。

如果在使用這些 gem 的情況下，光是在介面的調整可能就會改到海枯石爛。


## 缺點 / Cons
- 不少臭蟲，且難以調整 <!-- .element: class="fragment" -->
- i18n 不完善，加上難以調整 <!-- .element: class="fragment" -->
- 相容性問題，而且真的非常難以調整 <!-- .element: class="fragment" -->

note:

- 我不知道現在 Active Admin 現在更新的如何了，但我當初一年前在使用的時候給我的印象就是 bug 似乎頗多的。
- 至於相容性，則是需要整合 cancan 或是 mongodb 的興容性似乎不高。
- 此外由於不是每個人都有在用這些 gem，往往在交接的時候也會發生困難。


## 優點 / Pros
- 建置快速 <!-- .element: class="fragment" -->
- 適合初始專案 <!-- .element: class="fragment" -->
- 創造取多工作機會 <!-- .element: class="fragment" -->

note: 講了這麼多壞話還是要有些優點。正如剛剛提到的建置快速，以及適合在專案剛開始的時候使用之外，雖然他後續的維護會耗費許多時間與精神，但同時也創造了許多工作機會。