---
title: "在 Octopress 顯示目錄與標籤雲"
date: 2012-02-13 00:34
comments: true
categories: Octopress
---

正在苦惱 octopress 沒有可以顯示所有目錄地外掛時，在[高見龍前輩的網誌上取到西經](http://blog.eddie.com.tw/2011/12/05/add-catetories-to-sidebar-in-octopress/)（看不懂的人，建議先閱讀過 [jekll plugin](https://github.com/mojombo/jekyll/wiki/Plugins)）。但由於這種解在 `rake preview` 時會失敗，於是我開始撰寫 tag 版本。

嗯……好險我沒有寫完，因為我後來又發現在底下的回覆，tokkonoPapa 分享了一個 [repository](https://github.com/tokkonopapa/octopress-tagcloud)，和我想要做的東西一模一樣。當然，為了不重造輪子，我的網誌就採用了 tokkonoPapa 整理後的程式碼。

使用方式只要將三個檔案放在對應的位置即可，但要注意的是必須在 _config.yml 中設定 default_asides。