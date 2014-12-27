# Cross-site request forgery


# 偽造請求
note: 什麼是偽造的請求呢？

在那之前想問一下有沒有人不懂 HTML 是什麼的？


http://www.haha.com/posts/9527/delete

這是一個刪除編號為 9527 的文章的網址

note: 假設這是一篇刪掉重要資料的網址，他可能出現在你的管理介面中


```html
你的帳號疑似被盜用，<a href="http://www.haha.com/posts/9527/delete">請點我</a>重設密碼。
```

![](img/mail.png) <!-- .element: class="fragment" -->

```html
<img src="http://www.haha.com/posts/9527/delete">
```
<!-- .element: class="fragment" -->