---
title: "Masonry - 好用的動態排版工具"
date: 2012-07-08 14:12 +0800
tags: [jQuery, JavaScript]

---

![](/images/masonry-demo.png)

[官網](http://masonry.desandro.com)

昨天看到社上 JS 大神[喔哩](http://www.facebook.com/photo.php?fbid=4451976741683&set=a.1753065630592.2102379.1357466415&type=1&theater&notif_t=photo_reply)正在寫類似 [Google Web Store](https://chrome.google.com/webstore) 首頁那樣的圖形排版（雖然他說不太一樣）。但我想這麼常見的東西應該有可用的函式庫，果然餵狗之後被我找到了一個好用工具 [Masonry](http://masonry.desandro.com)。

如果還不太懂這東西是幹麼的，不如先看看我做的簡單[示範](/demo/masonry/)，瀏覽時不妨試著調整瀏覽器視窗大小，圖片的排版會隨著視窗可視範圍而改變。

<!-- more -->

## 使用

### HTML

先準備好要排版的項目，正規結構如下：

``` html
<div id="container">
  <div class="item">...</div>
  <div class="item">...</div>
  <div class="item">...</div>
  ...
</div>
```

``` html
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
<script src="/path/to/jquery.masonry.min.js"></script>
```

由於 Masonry 有些特效仰賴 jQuery，所以在引入 `masonry.js` 之前要先引入 `jquery.js`，如果你覺得麻煩，Masonry 後期也很貼心的提供了純 JS 版：[Vanilla Masonry](http://vanilla-masonry.desandro.com/)

### CSS

將所有的項目設定成浮動的（floated），寬度也最好設定，否則容易排出空隙。

``` css
.item {
  width: 220px;
  margin: 10px;
  float: left;
}
```

### JavaScript

建議要設定 `itemSelector`，不設定也可以，他會自己抓 container 裡面的所有 elements。另外官方也建議設定 `columnWidth`。

``` javascript
$(function(){
  $('#container').masonry({
    // options
    itemSelector : '.item',
    columnWidth : 240
  });
});
```

完成了，更多的使用方式請[看這裡](http://masonry.desandro.com/docs/intro.html)。

## 非官方叮嚀

當然，如果只是翻譯一下文件就拍屁股走人未免也太不夠意思，我其實另外發現官方文件少提醒了一點我覺得很重要的部份：

如果你只是單純照著官方文件在 item 裡面放大小不一的圖片：

``` html
<div class="item"><img src="..." /></div>
<div class="item"><img src="..." /></div>
...
```

不難碰上一些問題：

1.  跑出一大堆空隙，無法漂亮的排版。
2.  `div` 的高度比 `img` 大，圖片上下之間有空隙，而且這個空隙即使你丟了一個 `reset.css` 也無法獲得解決。

![](/images/masonry-demo2.png)

原因出在 `<img>` 預設是 `inline`，且對於排版長寬不等的圖片還要求沒有空隙本來就不太合理，所以我們再加上新的 CSS 設定：

``` css
.item img{
  display: block;
  max-width: 100%;
}
```

乾杯！