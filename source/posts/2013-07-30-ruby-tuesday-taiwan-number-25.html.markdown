---
title: "Ruby Tuesday Taiwan #25"
date: 2013-07-30 20:07 +0800
comments: true
category: 閒聊
---

## Topic 1

講者：Carol Hsu  
主題：最速部署 Rails 3 在 IIS6 (及以上)

第一次部署 Rails on IIS 就上手！介紹如何在 Windows 環境內，用 IIS 與 reversy proxy 的架構搭建起 production-level 的 Rails 運行環境。

在 **Windows Server 2003**、**IIS 6** 、**9 年以上的機器**環境上佈署 Rails application！

光聽到這樣的環境就腿軟了，太猛了XDDD，解法大綱是利用反向代理的方式，將 IIS 收到的 request 送給 Rails server。

至於為什麼要執著在 windows，原來是講者負責政府機關網站的維護，並且在講題當中稍微抱怨政府單位的機器老舊又脫離不了 windows。至此我實在非常有同感，最近手邊就有一個學校的案子，結果網站竟然要支援到 IE7，還要有 responsive design，實在血尿啊！

<del>另外今天講者有綁馬尾，心情不錯www</del>

## Topic 2

講者：Tka  
主題：Ruby 與推薦系統

介紹推薦系統的原理以及如何使用 Ruby 或 JRuby+Mahout 來搭建簡易的推薦系統。

### 推薦系統的分類

1.  Content Based：以消費者個人的資料作為推理基礎
2.  Collaborative Filtering
    1.  Item Based：找出類似的商品
    2.  User Based：這個商品被誰買過，同時這人有買了其他哪些商品

### Libraries

1.  [Recommendify](https://github.com/paulasmuth/recommendify)
2.  [Mahout](http://mahout.apache.org/)

想到推薦系統也許可用在交友網站上面，例如選了對象 A 的人，同時也選了對象 B。搭配 linkedin 的親友驗證機制，過濾掉自我感覺良好的人，這東西拿來搞個專案似乎很多演算法都可以玩到啊XD
