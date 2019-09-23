---
title: 在 canvas 繪製 JPEG 圖片後保留 EXIF 資訊
date: 2019-09-23 16:44 +0800
tags: [JavaScript, 已知用火]
---

[copyexif.js]: https://gist.github.com/tonytonyjan/ffb7cd0e82cb293b843ece7e79364233

筆者近來開發 [canvas](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API) 相關的應用，發現繪製後的圖片會遺失 EXIF 資訊，於是花了點時間研究 JPEG 檔案格式的規格，並在此將解法分享出來。

<!-- more -->

這個問題應該不難搜尋到[這篇 Stack Overflow 上的討論串](https://stackoverflow.com/questions/18297120/html5-resize-image-and-keep-exif-in-resized-image)。

只不過 Martin Perry 的[在 2013 的做法](http://www.perry.cz/files/ExifRestorer.js)有些老舊，筆者重新用 2019 已知的技術翻新了版本。僅使用 [Blob](https://developer.mozilla.org/en-US/docs/Web/API/Blob) 和 [ArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer)。

# 問題描述

在 canvas 上繪製 JPEG 圖片，處理後再將 canvas 輸出新的 JPEG 圖片，同時保留 EXIF 資訊。

# Demo

- [Keep EXIF Data after Drawing JPEG Image in Canvas](https://codepen.io/tonytonyjan/project/editor/XEkOkv)
- [copyExif.js]

# 解釋

直覺上，第一時間想到的做法會是先讀取 EXIF 後再重新寫入。其中讀取 EXIF 方面首選 [exif-js](https://github.com/exif-js/exif-js)，但寫入 EXIF 方面就不是這麼容易找到成熟的專案，若非年久失修，就是使用的人太少，可能有很多尚未發現的問題。

然而需求若只是單純要保存原本的 EXIF，而非逐一寫入，其實不需要用到像 exif-js 這麼大的專案。因為 JPEG 檔案的裡面的元資料其實像貨櫃一樣，一個個整齊地存放在名為 marker 的資料結構裡，而其中一個 marker 專門存放 EXIF 資訊。只要將其複製下來，並在新的 JPEG 圖片裡貼上，那麼新的圖片就可以完整保留原始圖片的 EXIF。

# JPEG Marker 結構

每一個 JPEG marker 結構如下：

| Marker | 大小 | 資料 |
| ------ | ---- | ---- |
| FFXX   | SSSS | DDDD |

marker 的標頭都以兩個位元表示，格式以 `FFXX` 的形式出現，而接著 marker 後的 2 個位元 `SSSS` 則表示後面的資料結構的大小，格式為大端序（big-endian），而該數字所表達的大小包含了 `SSSS` 所佔用 2 個位元。

舉例：

`FF C1 00 0C DD DD ...`

`FFC1` 表示 marker 標頭，`000C` 表示資料結構大小為 12，但 12 包含了 `000C` 本身，所以後面的 `DD DD ...` 只有 10 個位元。

# copyExif.js

EXIF 資訊存放在 APP1 marker 裡面，標頭為 `FFE1`，這個檔案的實際操作如下：

1. 讀取來源 blob，搜尋 `FFE1` 標頭，將整段 APP1 marker 擷取出來。
2. 取得 canvas 的 blob。
3. 將取得到的 APP1 marker 嵌入 canvas blob 裡面的正確位置。

如果有任何問題或覺得寫的哪裡不好，希望能到 [gist][copyexif.js] 給筆者一些指點，感激不盡。

# 參考資料

- [Exif - Wikipedia](https://en.wikipedia.org/wiki/Exif)
- [Exif file format - MIT Media Lab](https://www.media.mit.edu/pia/Research/deepview/exif.html)
