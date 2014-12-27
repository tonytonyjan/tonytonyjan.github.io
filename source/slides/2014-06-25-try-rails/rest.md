# REST <!-- .slide: data-background="../img/5xruby_bg_chapter.png" -->
## Representational State Transfer


# CRUD
對資料最基本的操作
## Create, Read, Update, Delete


## REST 風格
HTTP 動詞 | 路徑                | 功能
--------  | ------------------- | ----
GET       | /products           | 產品清單
GET       | /products/9527      | 顯示編號 9527 的產品
PUT       | /products/9527      | 更新編號 9527 的產品
DELETE    | /products/9527      | 刪除編號 9527 的產品
GET       | /products/new       | 新增產品頁
GET       | /products/9527/edit | 編輯編號 9527 的產品