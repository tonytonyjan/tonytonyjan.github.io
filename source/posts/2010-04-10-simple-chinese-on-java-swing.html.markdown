---
title: "解決 Java Swing GUI 在 Un*x 的中文亂碼問題"
date: 2010-04-10 02:54:01 +0800
comments: true
category: Java FreeBSD
---

換過作業系統後還沒有想到在Swing上顯示中文會有問題，只是因為幫別人寫一個小程式，很幸運的被我遇見了，尋求解決同時不忘研究過後把經驗貼出來分享～

![](/images/cssula-blog/Screenshot-10.png)
（顯示不出中文……）

<!--more-->

### 環境

    $ uname -ai                                                                      FreeBSD CS329.dorm8.nctu.edu.tw 8.0-RELEASE-p2 FreeBSD 8.0-RELEASE-p2 #6: Fri    Feb 12 01:37:32 CST 2010     root@:/usr/obj/usr/src/sys/TONYBSD  i386 TONYBSD
    $ pkg_info | grep jdk                                                            diablo-jdk-1.6.0.07.02_8 Java Development Kit 1.6.0_07.02

### 遇到問題

Swing 上除了 Banner 之外，其餘中文顯示出現問題

### 方法

    $ cd JavaHome/jre/lib/fonts/

是各位 jdk 的安裝路徑，我是在 `/usr/local/diablo-jdk1.6.0`

    $ mkdir fallback

接下來就是把想要的字型，看是用複製的或是 symbolic link，方到 fallback 目錄下
這時可以運用 `find /usr/local -name *.ttf` 來尋找，拿我的當例子：

    $ find /usr/local -name "*.ttf"

發現 `/usr/local/lib/X11/fonts` 有很多字型，其中有一個資料夾叫 TTF 裡面有個「文鼎ＰＬ中楷」，這是我要的。

    $ cd /usr/local/lib/X11/fonts/TTF
    $ ln -s *.ttf /usr/local/diablo-jdk1.6.0/jre/lib/fonts/fallback/

這樣就完成了，之後只要在 main 的開頭加上以下程式碼（或寫在 constructor），凡是 Swing GUI（JLabel、FileChooser...etc）從此就都能正常顯示中文了～

![](/images/cssula-blog/Screenshot-11.png)

看，多漂亮＝）

``` java
UIManager.put("Label.font", font);
UIManager.put("Label.foreground", Color.black);
UIManager.put("Button.font", font);
UIManager.put("Menu.font", font);
UIManager.put("MenuItem.font", font);
UIManager.put("List.font", font);
UIManager.put("CheckBox.font", font);
UIManager.put("RadioButton.font", font);
UIManager.put("ComboBox.font", font);
UIManager.put("TextArea.font", font);
UIManager.put("EditorPane.font", font);
UIManager.put("ScrollPane.font", font);
UIManager.put("ToolTip.font", font);
UIManager.put("TextField.font", font);
UIManager.put("TableHeader.font", font);
UIManager.put("Table.font", font);
```

眼看非常的完美，不過這樣子仍然有一個問題，照理說不需要自己指定字形才對. 不然別人寫的GUI程式要怎麼解決中文方塊酥的問題呢？所以另一個更好的方法應該在 fallback 複製好字形後，跑一下 mkfontscale

    $ cd fallback
    $ mkfontscale

這時候會產生 fonts.scale 檔，只要把檔案的內容複製到 fonts.dir 即可

    $ cat fonts.scale >> ../fonts.dir
