---
layout: single
title: Ruby on Rails 自習手冊
subtitle: 邁向鐵道工人之路
image: images/rails_road.jpg
comment: true
description: 這裡是「Ruby on Rails 自習手冊：邁向鐵道工人之路」的作者官方頁面，附上勘誤表、常見問題與購買連結，並歡迎在這裡與作者互動、或者回報書中錯誤。
---

<div class="row">
  <div class="col-md-6"><img src="/images/rails_road.jpg" alt="Ruby on Rails 自習手冊：邁向鐵道工人之路"></div>
  <div class="col-md-6">
    <h3>你可以在這裡……</h3>
    <ul>
      <li>查閱勘誤表、常見問題。</li>
      <li>留言與筆者互動。</li>
      <li>回報書中錯誤。</li>
      <li><del>多買幾本。</del></li>
    </ul>
    <h3>基本資訊</h3>
    <table class="table">
      <tr><th>出版社</th><td><a href="http://www.drmaster.com.tw/Bookinfo.asp?BookID=MP21504" target="_blank">博碩文化</a></td></tr>
      <tr><th>出版日</th><td>2015/2/15</td></tr>
      <tr><th>定價</th><td>NT$300</td></tr>
    </table>
    <h3>購買</h3>
    <a href="http://www.books.com.tw/products/0010666097" class="button button-icon big grass" target="_blank"><i class="fa fa-shopping-cart"></i>博客來</a>
    <a href="http://www.tenlong.com.tw/items/9789862019948" class="button button-icon big grass" target="_blank"><i class="fa fa-shopping-cart"></i>天瓏</a>
  </div>
</div>

## 勘誤表

頁碼 | 原文                                        | 修正                                                    | 讀者
---  | ---                                         | ---                                                     | ---
序   | 2014 年 2 月                                | 2015 年 2 月                                            | 蘇介吾
4    | 傳入的多少個參數                            | 傳入了多少個參數                                        | @ask
27   | app/views/homt.html 與 app/views/about.html | app/views/pages/homt.html 與 app/views/pages/about.html | @frank.pon
51   | ireapp.kkbox.com                            | fireapp.kkbox.com                                       | @juanitofatas
60   | math_path # => "http://..."                 | math_url # => "http://..."                              | @frank.pon
66   | `hot_calss`                                 | `hot_class`                                             | Kevin Wu
76   | 正如一開始提到的的寫法一樣                  | 正如一開始提到的寫法一樣                                | Kevin Wu
94   | 物件關聯對應物件關聯對映                    | 物件關聯對映                                            | Kevin Wu
114  | 嘗試儲存空的 Posot 物件                     | 嘗試儲存空的 Post 物件                                  | Kevin Wu
116  | `#updat`                                    | `#update`                                               | Kevin Wu
119  | `rails g migraiton`                         | `rails g migration`                                     | Kevin Wu
121  | 倒數第三行 tony.psots                       | 倒數第三行 tony.posts                                   | Kevin Wu
134  | `'posts#edit' # 新增文章表單頁`             | `'posts#edit' # 編輯文章表單頁`                         | Kevin Wu
139  | `link_to post.title "/posts#{post.id}"`     | `link_to post.title "/posts/#{post.id}"`                | Kevin Wu
147  | form_tag 會根據判斷 model                   | form_for 會根據判斷 model                               | Kevin Wu
151  | `@post = Post.find(params[:id])`            | `@post.destroy`                                         | Kevin Wu
153  | 且 Rials 提供了 notice 與 alert 兩個捷徑    | 且 Rails 提供了 notice 與 alert 兩個捷徑                | Kevin Wu
153  | `flast[:notice] # 等於直接寫 notice`        | `flash[:notice] # 等於直接寫 notice`                    | Kevin Wu
153  | `flast[:alert] # 等於直接寫 alert`          | `flash[:alert] # 等於直接寫 alert`                      | Kevin Wu
156  | 得額外讓 usre_id                            | 得額外讓 user_id                                        | Kevin Wu



## 常見問題

<dl>
  <dt>這本書適合誰？</dt>
  <dd>本書鎖定的對象是已經略懂一點網頁、資料庫和 Ruby，但對 Rails 想要有初步了解的人。</dd>
  <dt>會有簽書會嗎？</dt>
  <dd>羞恥之餘萬一辦起來無人到場就糗了，但若不嫌棄，<a href="http://fb.me/tonytonyjan" target="_blank">抓筆者出來</a>吃頓飯交個朋友無妨 =)</dd>
  <dt>使用的 Ruby 與 Rails 版本？</dt>
  <dd>Ruby 2.2 + Rails 4.2</dd>
</dl>