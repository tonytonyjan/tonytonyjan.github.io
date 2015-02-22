---
title: "跟簡報說話"
date: 2013-07-03 14:12 +0800
category: 程式
tags: JavaScript
---
[老樹咖啡]: http://www.oldtree.com.tw/

## 起源

昨晚參加了 Ruby Tuesday #24，地點在[老樹咖啡] B1 休閒區，聽著講者不斷講著「下一頁」，然後協助換頁的人就會按一下鍵盤。身為一個程式設計師，我突然有個想把這個步驟交給電腦做的衝動，於是開始試著找一些 library 來完成。

## 找可用軟體（放棄）

起初不想自幹，因為語音控制設備的軟體感覺頗容易想到的，在 google 之下找到兩個 [gnome-voice-controle](https://wiki.gnome.org/GnomeVoiceControl) 和 [Simon](http://www.simon-listens.org/)，只是前者不但安裝麻煩且已經不再開發，後者則是 KDE 專用。只好另闢新逕。

## 自幹軟體（放棄）

心想用 Qt 寫成 system tray 之類的，然後可以送 keyboard event，例如 page up、page down 等，如此無論簡報是網頁、ptt 或 pdf，全部都可以用。至於語音辨識的部份則是用李開復的開源項目 [Sphinx](http://cmusphinx.sourceforge.net/)，但後來放棄的原因是此途徑更加「厚工」（但只要是可以完成，功力能夠大增應該是確定的）。由於筆者是個懶人，所以只好再找其他方法。

## Web Speech Recognition API

沒辦法了，那就退一步使用 [Web Speech API](https://dvcs.w3.org/hg/speech-api/raw-file/tip/speechapi.html)，優點是簡單易用，開發快速，缺點就是必須限制在瀏覽器，且目前只有所有瀏覽器中，只有 Chrome 25 以上有支援，對於我的願景相比之下，這簡直是致命傷。

## 動手做

所以我就不管了，反正只是做個玩具，堪用就好。第一個玩具就用 [Reveal.js](https://github.com/hakimel/reveal.js/) 來實驗效果：

[點我觀看](/demo/speech/)

## 後記

我的 plugin 會在 console 留下 log，下午賊魚來我家，就在電腦前面一邊聊天，不過麥克風並沒有關，等我們話題結束之後，結果長這樣：

    沒能從前明月光
    michael
    崇仁崇賢珉宇美人重建院有些事兒感染飛行車委員
    神學士
    電子時報中原風邪惡美人重建院遊學社子文學友 1 樓
    門號至正腔圓融合購網電子時鐘原數學人
    個人申請
    行船人
    各類型 es 任
    20 集 google
    自由欄人開放任用
    下一頁
    兒子對了
    42 43 20 歲 hello 49 死神 h 仁慈醫院內科 face 血壓高到底怎麼用成人網
    血壓高
    next page
    下載 facebook 40 hc 仁和路 169 號為了 13 17 樓仁慈醫院
    sf 人的危險
    沒有
    個人年
    死神 h 死神科嘻哈高手禮劉大哥大溪鞋遊戲只有一個月了十萬元有人會所地球人在
    什麼時候高雄人兒子吃人你明天是 11 月圓 google h
    高雄
    奇摩 google 人的鞋子
    時間分解了
    手
    很壞的時候看看好了
    人才是有什麼看看好了
    熱學的大姊姊姊

什麼「熱學的大姊姊」，chrome 真是神空耳啊XD
