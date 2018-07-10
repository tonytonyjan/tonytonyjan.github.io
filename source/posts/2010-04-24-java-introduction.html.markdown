---
title: "第一次喝 Java 就上癮-計畫序"
date: 2010-04-24 01:14:40 +0800

tags: [Java]
---
![](/images/cssula-blog/javaLogo.png)
![](/images/cssula-blog/duke.png)

（左邊是Java的Logo，右邊則是可愛的Java吉祥物，Duke&gt;///&lt;）

<!--more-->

<strong>學習一個語言，有"愛"很重要</strong>

<strong> </strong>這個世界存在的程式語言實在太多，但如果還是想粗略的一探多寡，<a href="http://en.wikipedia.org/wiki/List_of_programming_languages" target="_blank">維基</a>可以幫上一點忙，但是實際數量肯定是比這還要多更多的。除了一些耳熟能詳的程式語言元老如 C, C++, Java, Fortran……等等，至今仍屹立不搖；2009年11月，新的語言<a href="http://www.zimbu.org/" target="_blank">Zimbu</a>問世，同時Google也發布了<a href="http://golang.org/" target="_blank">go</a>。另外呢，這個月TIOBE軟體公司公佈了最新的<a href="http://www.tiobe.com/index.php/content/paperinfo/tpci/index.html" target="_blank">程式語言使用率統計</a>（這東西每個月都會更新一次），這個月C又再次奪回了第一名寶座，Java被C領先位居第二。語言的數目是多到數不清，關係與地位又瞬息萬變。然而儘管語言的種類是如此龐大，對於到底該學哪一個，大兜認為不是最重要的議題，於此大兜想分享一些建議：

* 尋找一個您對它有"<strong>愛</strong>"的程式語言，並且持續不懈的了解它、發展它、熟悉它，不斷探索其背後原理、實做、理論根基、應用…等等，別急著什麼都學，等到根扎實、夠穩了，有時間再慢慢發展旁邊的枝葉。

* 大兜不會把您綁起來要脅去學Java，這只是我個人的因緣遭遇導致我選擇了 Java 當做我的樹根。除了Java之外您仍有很多選擇。

重要的還是"<strong>愛</strong>"啊～～～～<strong> </strong>

<strong>Java 的魅力</strong>

<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="480" height="385" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0">







<embed type="application/x-shockwave-flash" width="480" height="385" src="http://www.youtube.com/v/SRLU1bJSLVg&amp;hl=zh_TW&amp;fs=1&amp;rel=0" allowscriptaccess="always" allowfullscreen="true"></embed></object>


其實不妨試著在 Google 上搜尋一下"<a href="http://www.google.com.tw/search?source=ig&amp;hl=zh-TW&amp;rlz=&amp;=&amp;q=java+%E7%89%B9%E8%89%B2&amp;meta=lr%3D&amp;aq=f&amp;aqi=g1&amp;aql=&amp;oq=&amp;gs_rfai=" target="_blank">Java 特色</a>"，會得到數量可觀的筆數。意思是如果我把它們全部列出來，可能會被批佔頁面。而由於每個Java 控喜愛 Java 的並理由不一樣，在此大兜只舉出一些自己之所以選擇 Java 的主要理由。

整個程式設計個過程可以說是一種對複雜度的控管，包括底層機器的複雜度、問題的複雜度。但也有許多語言如 VB、C++、Perl、SmallTalk 對於複雜度議題的解決有相當的成效，Python 更是以「降低程式開發與維護過程的複雜度」為目標而生。

話說將大兜引入程式設計這調不歸路的程式語言的並不是 Java，而是 C。正當我已經玩過 C 有一段時間，接觸 C++ 之際，被這所謂的「物件導向」式程式語言所吸引，C++能夠大大簡化以往C解決問題時所需要的複雜度。然而有些美中不足的是 C++ 脫離不了歷史的包袱，正因 C++ 正是承襲 C 而來，這原本為了物件導向而生的語言，卻因秉持「向下相容」的原則，在語法上及架構上徒增了不少特例。

當我漸漸的了解 Java 後，我發現 Java 其中一個深深吸引我的特性就是「簡單」，這除了因為它是一個號稱「純」的物件導向式程式語言外，還有替 name space 的控管有了 package 這個觀念。另外還有 javadoc 可以幫助編寫好的自文件化的程式碼立即轉換成網頁，能以最清楚明瞭的方式呈現給用戶端，利其使用。

Java 的另一項著名特色：「跨平台」亦是大兜喜愛的特性之一，也就是所謂的「Write once, run anywhere」（WORA）。這麼說是誇張了點，但實際上方法就是在每個用戶端裝上一個 Virtual Machine，讓所有的 java byte code可以運行其上。即使速度慢了點（真的是慢了一點點點點點點），但由於跨平台在很多應用上都很吃香，犧牲一些速度換取這樣優勢有其划算之處。

另外 Java 也簡化了網路程式設計的複雜度，同時也提高了安全性。以往對於撰寫各個不同作業系統的網路程式，必須費心思弄清楚各個作業系統上與網路相關的系統呼叫，然而 Java 因為其「寫一次跑各地」的特性而讓程式員得以免於這樣的煩惱。

Applet 是讓 Java 一舉成名的一項關鍵，它讓 Java 程式可以跑在網頁上，只要用戶端有裝瀏覽器與 JRE 便可以透過 html 中的 applet 標籤，執行遠地的 Java 程式， Java 標準函式庫提供了許多好用的繪圖函式，可以寫出如 flash 般動畫、遊戲，而 Java OpenGL 更是一項令人振奮的領域，使其配合 applet 可以在網頁順暢的玩起 3D 遊戲，不需要安裝任何東西，用戶只需要瀏覽器就足夠。

下面一些官方的 Applet 展示：

<a href="http://java.sun.com/products/java-media/2D/samples/java2demo/Java2Demo.html" target="_blank">Java2D</a>

<a href="http://java.sun.com/products/java-media/2D/samples/java2demo/Java2Demo.html" target="_blank">![](/images/cssula-blog/Screenshot-17.png)</a>

<a href="https://jogl-demos.dev.java.net/applettest.html" target="_blank">JOGL</a>

<br class="spacer_" />

<strong>關於本計畫</strong>

本文件的誕生是一個出自吃飽太閒的死大學生的學習分享計畫，在這之前並沒有任何技術文件的撰文經驗，任何訪客如對於之後的內容有任何疑問，歡迎切磋指教，如果能糾正我那就更好了。希望藉此計畫學習教學文件的杜撰與章法風格，另外雖知道網路上存在許多人跟我做著同樣的事，大兜只是想單純的<strong>分享自己所學的一點微薄知識，以及發現與發明的喜悅</strong>。這是這個計畫的唯一目的。

<br class="spacer_" />

<strong>給讀者</strong>

很歡迎很歡迎有讀者可以給予迴響、建議與指正，甚至一起討論，因為討論往往可以激盪出美麗火花，我很喜歡。只是萬一我哪裡錯了盡量不要大聲嗆我，拜託了，我是很脆弱的……QQ

<br class="spacer_" />

參考資料：

http://java.sun.com

Thinking in Java 4/e