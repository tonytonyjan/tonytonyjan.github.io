---
title: C 語言之多行巨集
date: 2014-10-07 02:19:13 +0800
category: 程式
tags: [C]
thumb: thumbs/c.png
---

有時候我們在翻閱原始碼的時候會看到類似這樣的寫法：

```c
#define FOO(x, y)    \
do {                 \
  typeof(x) tmp = x; \
  x = y;             \
  y = tmp;           \
} while (0)
```

當然有的人會提出質疑，並且習慣使用邊界區塊（scope block）的寫法：

```c
#define FOO(x, y)    \
{                    \
  typeof(x) tmp = x; \
  x = y;             \
  y = tmp;           \
}
```

乍看之下比較漂亮，但事實上後者的寫法有潛在的問題。其實 do/while 的風格只有一個目的，就是將展開的內容變成一個敘述（statement）。讓我們舉個例子：

```c
if(condition)
  foo(x, y);
else
  bar(x, y);
```

目前 `foo()` 與 `bar()` 都是一個標準的 C 函式，可以正常編譯。但如果現在把 `foo()` 換成了巨集之後，狀況就不一樣了：

```c
if(condition)
  FOO(x, y);
else
  bar(x, y);
```

如果我們使用的是後者的寫法，經過預編步驟展開之後：

```c
if(condition)
  {
    typeof(x) tmp = x;
    x = y;
    y = tmp;
  };
else
  bar(x, y);
```

`if` 因為 `FOO(x, y);` 後面的分號，提早終結了，事實上這段程式碼也無法編譯。其中一個解法是把分號拿掉：

```c
if(condition)
  FOO(x, y)
else
  bar(x, y);
```

這樣產生的程式碼就可以符合 if/else 的正確語法，可是 `FOO(x, y)` 後面沒有分號卻又破壞了程式設計的一致性。所以最後才會出現 do/while 風格的寫法，要注意的是 `while(0)` 的後方沒有分號，如果加上了分號，那麼會因為這個分號終結的是 do/while 敘述，導致 `FOO(x, y);` 會展開出兩個分號，又出現了剛剛的問題。

當然，如果你覺得每次多行的巨集都要加個 do/while 其醜無比且又可能會打錯字，筆者建議可以再包裹一層巨集去處理這件事情，別忘了巨集可以當樣板使用：

```c
#define STMT( stuff )  do { stuff } while (0)

#define SWAP(x, y)     \
  STMT(                \
    typeof(x) tmp = x; \
    x = y;             \
    y = tmp;           \
  )
```
