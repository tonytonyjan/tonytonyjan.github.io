---
title: "大兜的 gcc 歷險記"
date: 2012-10-02 13:13
comments: true
categories: [C, C++, gcc]
---

由於不是很清楚 gcc 在編譯 c 文件時到底做了什麼事情，於是展開了深入理解的旅程。從最簡單的 `hello.c` 開始：

``` c hello.c
#include <stdio.h>

int main(int argc, char* args[]){
  printf("Hello, world!");
}
```

在編譯之前，讓我們回顧一下編譯的步驟：

步驟                   | 指令                      | 中出檔
---------------------- | ------------------------- | --------------------
                       |                           | 原始碼
前處理（preprocessing）| gcc -E hello.c -o hello.i |   ↓↓
                       |                           | 原始碼（標頭被展開）
編譯（compiling）      | gcc -S hello.i -o hello.s |   ↓↓
                       |                           | 組合語言
組譯（assembling）     | gcc -c hello.s -o hello.o |   ↓↓
                       |                           | 機器碼
連結（linking）        | ld ... （暫略）           |   ↓↓
                       |                           | 可執行機器碼

    -E 僅作預先處理，不進行編譯、組譯和連結
    -S 編譯到組合語言，不進行組譯和連結
    -c 編譯、組譯到目的程式碼，不進行連結

看到鍵盤上的 `Esc` 了嗎？那正是編譯步驟，是不是超好記的。

<!-- more -->

## 前處理（Preprocessing）

    gcc -E hello.c -o hello.i

在這個步驟裡面會把標頭（header）一一展開，即範例中的 `stdio.h`，展開之後取代 `#include<stdio.h>`，我的 `hello.i` 就多了四百多行，看起來像是這樣子：

    // 以上 432 行略，建議自己 DIY 看看
    int main(int argc, char* args[]){
      printf("Hello, world!");
    }

## 編譯

    gcc -S hello.i -o hello.s

步驟                              | 輸出檔
--------------------------------- | ----------------------------
                                  | Sequence of characters
lexical analysis                  | ↓↓
                                  | Sequence of lexical elements
parsing                           | ↓↓
                                  | Syntax tree
semantic analysis                 | ↓↓
                                  | Annotated syntax tree
generation of intermediate code   | ↓↓
                                  | Sequence of IL
optimization of intermediate code | ↓↓
                                  | Sequence of IL
generation of pseudo code         | ↓↓
                                  | Assembly program

編譯就是把原始碼轉換成目的語言的動作（通常就是組合語言）

``` nasm hello.s
  .file "hello.c"
  .def  ___main;  .scl  2;  .type 32; .endef
  .section .rdata,"dr"
LC0:
  .ascii "Hello, world!\0"
  .text
  .globl  _main
  .def  _main;  .scl  2;  .type 32; .endef
_main:
LFB6:
  .cfi_startproc
  pushl %ebp
  .cfi_def_cfa_offset 8
  .cfi_offset 5, -8
  movl  %esp, %ebp
  .cfi_def_cfa_register 5
  andl  $-16, %esp
  subl  $16, %esp
  call  ___main
  movl  $LC0, (%esp)
  call  _printf
  leave
  .cfi_restore 5
  .cfi_def_cfa 4, 4
  ret
  .cfi_endproc
LFE6:
  .def  _printf;  .scl  2;  .type 32; .endef
```

## 組譯

    gcc -c hello.s -o hello.o

組譯之後會產生目的檔（hello.o），裡面全都是機器碼。

但因為我們還少了連結的動作，所以 `hello.o` 還無法被執行。

## 連結

    ld -o hello.exe c:/mingw/bin/../lib/gcc/mingw32/4.7.0/../../../crt2.o hello.o -lmingw32 -lmoldname -lmingwex -lmsvcrt -ladvapi32 -lshell32 -luser32 -lkernel32

你大概感到好奇為什麼 `hello.o` 和 `hello.exe` 平平都是機器碼，少了連結，前者就無法執行。

這個程式就只是在黑窗上面印出一個「Hello, world!」，但我們並沒有真的去實做 IO 處理或是送訊號去顯卡，因為這些繁瑣的工作全交給 `printf` 完成了。然而在編譯的過程，編譯器並不知道 `printf` 編譯好的機器碼放在哪裡（可能在一個 `.obj` 或 `.lib` 裡面），所以在產生目的檔時，會在 `printf` 的進入點留位置給連結器（linker）去做填空，等連結器收集了所有需要的機器碼之後，才將他們填上。

這也是為什麼可執行檔會比原來的原始碼大很多，因為連結器插入了很多來自其他檔案的機器碼。