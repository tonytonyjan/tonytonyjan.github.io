# XSS


# Cross-site Scripting


# 跨站指令碼攻擊
note: 跨網站指令碼（Cross-site scripting，通常簡稱為XSS或跨站指令碼或跨站指令碼攻擊）是一種網站應用程式的安全漏洞攻擊，是代碼注入的一種。它允許惡意使用者將程式碼注入到網頁上，其他使用者在觀看網頁時就會受到影響。這類攻擊通常包含了HTML以及使用者端腳本語言。
XSS攻擊通常指的是透過利用網頁開發時留下的漏洞，透過巧妙的方法注入惡意指令代碼到網頁，使使用者載入並執行攻擊者惡意製造的網頁程式。這些惡意網頁程式通常是JavaScript，但實際上也可以包括Java， VBScript， ActiveX， Flash 或者甚至是普通的HTML。攻擊成功後，攻擊者可能得到包括但不限於更高的許可權（如執行一些操作）、私密網頁內容、會話和cookie等各種內容。


# 另類填空遊戲
### ex. http://www.insecurelabs.org/


# 然後勒？

---

# 攻
## 偷餅乾


# 網站怎麼認出你？
# Cookie <!-- .element: class="fragment" -->


<!-- .slide: data-background="img/cookie.jpg" -->


```
request_method=GET; __utma=250630274.1670555290.1394691521.1396027564.1396899647.22; __utmb=250630274.1.10.1396899647; __utmc=250630274; __utmz=250630274.1395729495.18.4.utmcsr=ukik.handlino.cc:3000|utmccn=(referral)|utmcmd=referral|utmcct=/pages/events/e2014crosspoint 
```

```js
alert(document.cookie);
```
<!-- .element: class="fragment" -->

note: 他長得比較像這樣，一個名字對應一個值。

可以透過 js 得到，或是瀏覽器的控制台。（示範）


# Cookie
# 身分證
note: 用 plurk 和 curl 舉例

---

# 防
## 過濾內容


```html
bla bla bla... <script>alert(document.cookie)< /script> la la la...
```

```html
bla bla bla... la la la...
```
<!-- .element: class="fragment" -->