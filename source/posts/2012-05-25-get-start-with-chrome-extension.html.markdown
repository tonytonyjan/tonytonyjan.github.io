---
title: "大兜的 Chrome Extension 學習筆記"
date: 2012-05-25 12:12 +0800
comments: true
categories: Chrome
---

要寫 Chrome Extension 的先決條件是擁有網頁基礎，因為寫 Chrome Extension 會用到 HTML、Javascript、CSS，如果還不會這些東西，建議在學習 Chrome Extension 之前，先把這些技能磨練好。

這篇介紹會針對 Chrome Extension 的 manifest 結構、檔案結構以及一些常用到的部份做簡單的介紹，包括 Browser Action、Page Action、Background Page 和 Content Script。

<!-- more -->

## 架構簡介

### Background Pages

大多外掛會有一個 background page 常駐在背景，可能是一個 HTML 或者 javascript 檔，外掛的功能與邏輯都被定義在此，然後透過 API 與 UI（browser actions 或 page actions）做溝通。

![](/images/arch-1.gif)

### UI Pages

Chrome Extension 的 UI 介面使用的是 HTML，例如我們可以在 browser action 定義一個 popup.html ：

![](/images/arch-2.gif)

Chrome Extension UI：
*   Browser Actions
*   Page Actions
*   Desktop Notifications
*   Omnibox
*   Override Pages
*   Options Pages
*   Context Menu：右鍵出現的內容

## Chrome Extension = Manifest + Web Assets

一個 Chrome Extension 由一個 `manifest.json` 和其他網頁檔案組成，檔案目錄大概會像這個樣子：

![](/images/chrome-ext.png)

除了 `manifest.json` 之外，其餘的檔案都是可選的，所以一個最簡單的（不具任何功能的） Chrome Extension 可以只由一個 `manifest.json` 組成，其他的檔案需要與否則視 `manifest.json` 裡頭的設定。Chrome Extension 之於 `manifest.json` 就像人之於個資一樣，裡面描述所有關於這個 Extension 的資料，包括名稱、敘述、版本、語言、使用的圖片等等。

### manifest.json 簡介

``` json
{
  // 必要
  "name": "My Extension",
  "version": "versionString",
  "manifest_version": 2,

  // 建議，非必要
  "description": "A plain text description",
  "icons": { ... },
  "default_locale": "en",

  // 選一個
  "browser_action": {...},
  "page_action": {...},
  "theme": {...},
  "app": {...},

  // 其他視情況需要的設定
  "background": {...},
  "chrome_url_overrides": {...},
  "content_scripts": [...],
  "content_security_policy": "policyString",
  "file_browser_handlers": [...],
  "homepage_url": "http://path/to/homepage",
  "incognito": "spanning" or "split",
  "intents": {...},
  "key": "publicKey",
  "minimum_chrome_version": "versionString",
  "nacl_modules": [...],
  "offline_enabled": true,
  "omnibox": { "keyword": "aString" },
  "options_page": "aFile.html",
  "permissions": [...],
  "plugins": [...],
  "requirements": {...},
  "update_url": "http://path/to/updateInfo.xml",
  "web_accessible_resources": [...]
}
```

#### version

代表該 Extension 的版本，最多由四個整數組成，並且用 `.` 分開，數字必須介在 0 到 65535 之間，而且非零的數字不可以 0 當開頭，舉例：

*   錯誤：
    *   "version": "99999"
    *   "version": "032"
*   正確
    *   "version": "1"
    *   "version": "1.0"
    *   "version": "2.10.2"
    *   "version": "3.1.2.4567"

#### manifest_version

一個代表 manifest file 格式版本的整數，如果使用的是 Chrome 18 以上，則應該設定成 2。

    "manifest_version": 2

可以在[這裡](http://code.google.com/chrome/extensions/manifestVersion.html)查閱版本 1 和 2 之間的差別。

### icons

這邊可以定義 Chrome extension 的 logo。盡量是 PNG 格式，因為 Webkit 對 PNG 的透明度轉換最好。

``` json
{
  ...
  "icons": {
    "16": "icon16.png",
    "48": "icon48.png",
    "128": "icon128.png"
  },
  ...
}
```

*   128x128：用在安裝時
*   48x48：在 `chrome://extensions` 裡顯示
*   16x16：favicon

## Browser Action

![](/images/browser-action.png)

Browser action 適合在需要一個常駐的功能放在 Google 工具列時使用，可以加上 tooltip、badge（例如收到幾封信） 和 popup。

### Manifest

``` json
{
  ...
  "browser_action": {
    "default_icon": "icon19.png",     // 可選
    "default_title": "Tooltip title", // 可選
    "default_popup": "popup.html"     // 可選，滑鼠單擊會呈現的內容
  },
  ...
}
```

## Page Action

![](/images/page-action.png)

類似 browser action，差別在於 page action 用於特定網頁才需要的功能，由於 browser action 常駐時會佔用一部份的記憶體，如果你的功能需要在特定狀況下才啟用，建議用 page action 取代 browser action。常見應用是 RSS 訂閱（只有網頁提供 RSS 時才啟用）。

### Manifest

``` json
{
  ...
  "page_action": {
    "default_icon": "icons/foo.png", // 可選
    "default_title": "Tooltip title",    // 可選
    "default_popup": "popup.html"    // 可選，滑鼠單擊會呈現的內容
  },
  ...
}
```

設計原則：

*   在功能只針對部份網頁時，使用 page action。
*   如果功能需要常駐在每個網頁，使用 browser action。

## Content Script

這是筆者認為最有趣的部份，content script 顧名思義可以在頁面裡面嵌入 javascript，他們可以透過 DOM 得知使用者瀏覽的頁面的內容，甚至可以改變這些內容。

這些是 content script 可以做到的事：

*   爬出所有沒有 `<a>` 的 URL，為他們加上 `<a>`
*   把字放大
*   去掉廣告

基本上可以在 chrome 開發人員視窗中能做到的事情，content script 都可以做到。但這功能看似強大，卻有些限制：

*   **無法**呼叫 `chrome.* APIs` 這類的 API（`chrome.extension` 除外）
*   **無法**使用 extension page 上的變數和函式（例如 background pages）
*   **無法**使用網頁上的變數和函式

但這些限制可以透過 `chrome.extension` 與 extension pages 做溝通。

## Manifest

``` json
{
  ...
  "content_scripts": [
    {
      "matches": ["http://www.google.com/*"],
      "css": ["mystyles.css"],
      "js": ["jquery.js", "myscript.js"]
    }
  ],
  ...
}
```

### matches

常用的格式：

*   http://127.0.0.1/*

    指定某個 host 下的所有 path

*   http://example.org/foo/bar.html

    指定某個連結

*   &lt;all_urls&gt;

    在所有的頁面（這樣的狀況不多，但惡作劇的時候可能會用到）

其他用法[詳見此](http://code.google.com/chrome/extensions/match_patterns.html)


## Background Pages

一個 extension 通常要有一個常駐執行的 script，用來控制 Browser UI（page action 或 browser action），例如我們會需要一個常駐的程式去監聽 FB 是否有新的訊息，如果聽到則在 browser actoin 上面顯示 badge，收信亦如是。

同時如果 content script 需要與 UI 做溝通，要定義的 function 都放在這裡。

### Manifest

如果內容很少，可以寫在一個檔案即可：

``` json
{
  ...
  "background": {
    "scripts": ["background.js"]
  },
  ...
}
```

如果內容很多，要分成好幾個 `.js` 檔，則改用以下方式並配合 `<script>` 標籤：

``` json
{
  ...
  "background": {
    "page": "background.html"
  },
  ...
}
```
