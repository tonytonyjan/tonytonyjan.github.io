---
title: "臉書打卡集氣棒"
date: 2014-06-27 23:51:38 +0800

tags: [Ruby]
thumb: thumbs/fb.jpg
---

![](/images/fb-page-countdown.png)

本棒會在指定 FB 粉絲頁或打卡點，其按讚數量與打卡數總和超過指定數量時，放出慶祝特效。

這是當初為了[五倍紅寶石](https://www.facebook.com/5xruby)說明會做出來的東西，此外也被用在 [I'M Waffle 現烤鬆餅](https://www.facebook.com/wwacimwaffle)，為了可以重複利用，特此放到了 [Github Page](http://5xruby.github.io/FB-checkin)，並且改版為可透過網址變數去設定頁面內容。

## 產生器

<form action="http://5xruby.github.io/FB-checkin" target="_blank">
  <label for="obj_id">粉絲頁 ID</label>
  <input id="obj_id" type="text" name="obj_id">
  <label for="max_count">讚、打卡最大值</label>
  <input id="max_count" type="number" name="max_count" value="500">
  <label for="auto_fire">自動放煙火</label>
  <input id="auto_fire" type="checkbox" name="auto_fire">
  <input type="submit" value="送出"><br>
  <b>進階設定：</b><br>
  <label for="font_size">倒數數字大小</label>
  <input id="font_size" type="number" name="font_size" value="0.5" step="any"><br>
  <label for="btn_size">啟動煙火按鈕大小（px）</label>
  <input id="btn_size" type="number" name="btn_size" value="100"><br>
  <label for="qr_code_size">QRCode 圖片大小（px）</label>
  <input id="qr_code_size" type="number" name="qr_code_size" value="600"><br>
  <label for="cycle">更新週期（千分之秒）</label>
  <input id="cycle" type="number" name="cycle" value="1000"><br>
</form>

Github：https://github.com/5xRuby/FB-checkin

## 變數說明

變數           | 預設值  | 說明
-------------- | ------- | ----
`obj_id`       | 5xruby  | 粉絲頁 ID
`font_size`    | 0.5     | 倒數數字大小
`auto_fire`    | false   | 自動放煙火
`btn_size`     | 100     | 啟動煙火按大小
`qr_code_size` | 600     | QRCode 圖片大小
`max_count`    | 500     | 讚、打卡最大值
`cycle`        | 1000    | 更新週期