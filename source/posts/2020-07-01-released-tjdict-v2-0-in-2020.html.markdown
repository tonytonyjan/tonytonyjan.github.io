---
title: 2020 要幹嘛？做 TJDict 2.0！
date: 2020-07-01 01:43 +0800
tags: [TJDict, Chrome, JavaScript, Firefox, Edge]
image: /images/tjdict.png
thumb: /images/thumbs/tjdict.png
download: https://tjdict.com
---

![TJDict](/images/tjdict.png)

筆者今年因為肺炎疫情緣故失業，本來想說終於有時間可以做許多想做的事：看看書、學日文、作曲玩動物森友會等等，不料突然收到一封 TJDict 使用者的來信說 Yahoo 字典壞掉了。心想 TJDict 開發至今已經 8 年，其中後 4 年完全沒有經手這個專案，藉機看一下 [TJDict 在 Google Web Store][tjdict] 上的使用人數，發現至今仍然每週有約 20,000 人的使用者，頓時涕泗縱橫。身為一個碼農，知道自己的軟體對這個世界有所貢獻實在倍感光榮。

為了消耗因為失業產生的大量時間，TJDict 2.0 就誕生了。

<!-- more -->

## TJDict 2.0 做了什麼改變？

<iframe width="560" height="315" src="https://www.youtube.com/embed/CCDerTD8AsE?controls=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

TJDict 1.0 使用的是 2012 當時的技術，那時並沒有 npm 或 bower、瀏覽器沒有無頭模式、[Browser Extensions][browser extensions] 標準尚未成熟或被瀏覽器實作等，那時開發比現在辛苦很多。

而 TJDict 2.0 使用了 2020 能找到的最新技術：

- 將 Bootstrap 更新到最新版
- 使用 npm 管理套件，不用自己實作套件版本依存系統
- 使用 React 渲染介面，跟 JS 檔案裡醜陋的 HTML 說再見。
- 使用 Storybook 管理 React 元件
- 使用 webpack 打包程式碼
- 使用 Chrome headless 執行測試，終於可以不用在桌面環境開瀏覽器跑測試
- 使用 GitHub Actions 每天自動測試 parser 是否運作正常，不用等到網友提報才知字典壞掉
- Browser Extensions 標準成熟，輕鬆實現跨瀏覽器

以上看不懂？沒關係，簡單的說意思就是：

<strong style="font-size: 300%">2 > 1</strong>

沒錯，2 大於 1，也就是 2 是 1 的兩倍，意思就是 TJDict 2.0 比 1.0 更好、更快、更穩，你們用用看就知道。

## TJDict 1.0 去哪了？

雖然已經沒有維護，加上筆者擅長寫髒碼，閱讀的人可能會產生幻覺或思覺失調症，但一想到說不定哪天誰有這方面的需求也不一定，以防萬一，所以筆者把[原始碼公開在這了][tjdict v1 source]。

至於 2.0 的原始碼，未來可能也會公開，只是現在還不是時候。

## 官網成立

官網就在 [tjdict.com][tjdict.com]，建議大家如果還沒安裝的話，趕快點進去下載並安裝，因為 TJDict 真的是一款很棒的軟體，沒用過的話是你們的筍絲。

## 下一步

其實有蠻多東西都在願望清單裡面的，像歷史紀錄、透過歷史紀錄自動產生生字簿、單字卡等等，也有把 TJDict 做成桌面軟體而非瀏覽器外掛的打算。

除此之外有擴編團隊的想法，像工程師、設計師等，但更重要的是找到一個可以包養筆者、讓筆者一邊快樂寫程式一邊快樂長大的乾爹，目前這個職位尚有空缺（<del>歡迎來應徵</del>）。

## 感性一下

其實身為一個小碼農，不敢奢求能做到什麼改變世界的創舉，但筆者小小的夢想一直是能夠開發出對這個世界有幫助的軟體，所以真的很感謝每一位使用 TJDict 的人，今天 TJDict 有你們繼續使用，就是筆者最大的開發動力：）

[tjdict.com]: https://tjdict.com
[tjdict v1 source]: https://github.com/tonytonyjan/TJDict
[tjdict]: https://chrome.google.com/webstore/detail/caafmojgjlbflohillejdmnghkpcjjpp
[browser extensions]: https://browserext.github.io/browserext/
