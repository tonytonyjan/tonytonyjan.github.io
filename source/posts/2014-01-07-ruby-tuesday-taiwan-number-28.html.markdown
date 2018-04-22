---
title: "Ruby Tuesday Taiwan #28"
date: 2014-01-07 19:19 +0800

published: false
---

## Topic 1

講者：慕凡  
主題：Eventmachine Websocket

介紹如何使用 EM-Websocket 開發 Websocket 的網頁程式, 以及 production environment 的佈署

以前的 real time 解決方案

*   Client Interval Polling
*   Long Polling
*   Comet
*   Flash Socket
    *   SSL 相容性問題
    *   server 端需仰賴第三方元件

Websocket

*   Real server push
*   W3C spec
*   IE10+ support
*   SSL support

Ruby 解決方案

*   EventMachine
*   抽象 Thread 或 Fiber
*   抽象 socket 處理
*   通用 CRuby/JRuby

Why Event Machine?

*   C10K issue

Notes

*   Server 端主要透過 HTTP upgrade header 判斷 request 是否為 websocket 連線。
*   WS 只能是 GET，不能是 POST
*   設計時每個 event 處理越小越好（可以利用 next_tick）
*   利用 EM 有包裝的相關的實做

## Topic 2

講者：Godfat  
主題：Why Bother to Create? Why Not Just Use?

為什麼要再造輪？現有的輪子不好用嗎？什麼時候我們甘願用方形的輪子？如果我們都會飛了，為什麼還要輪子？跟大家分享我一路走來用了造了各種輪子的一些心路歷程。












