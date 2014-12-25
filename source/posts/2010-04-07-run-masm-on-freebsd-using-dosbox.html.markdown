---
title: "用 dosbox 在 FreeBSD上寫 masm"
date: 2010-04-07 16:49:30 +0800
comments: true
category: 程式
tags: FreeBSD, ASM
---
課上要用 masm 交作業，然而我的系統是FreeBSD，由於不想灌windows，而有了這個替代方案。在開始之前可以先來<a href="http://zh.wikipedia.org/zh-tw/%E7%B5%84%E5%90%88%E8%AA%9E%E8%A8%80%E5%88%97%E8%A1%A8" target="_blank">這裡</a>看看組語言到底有哪些種類<br />
（唯一一個有標注 FreeBSD 的是 HLA……QQ）
 
<!-- more -->

先安裝 dosbox，這是一個dos的模擬器

    %portinstall -c emulators/dosbox
    %rehash
    %mkdir ~/learnASM
    %mkdir ~/learnASM/tools
    %mkdir ~/learnASM/tools/masm5

從網路上下載 masm5.0 （太新的版本可能不能跑），我是從<a href="http://download.pchome.net/development/linetools/detail-9028.html" target="_blank">這裡</a>下載的。

把含有.exe檔的目錄下所有的檔案放在 `~/learnASM/tools/masm5`

    %cd ~/learnASM
    %echo "dosbox -c 'mount c: ./' -c 'path %path%;c:\tools;c:\tools\masm5'" &gt; runDosbox.sh
    %chmod +x runDosbox.sh
    %./runDosbox.sh

到目前為止 dosbox 已經具備組譯的能力，至於怎麼使用 masm……
首先要寫一個 .asm 原碼，這裡以 hello.asm 為例，我是先用 vim 或 vi 在 `learnASM/` 編輯，然後對著 dosbox 按 Ctrl+F4 重新整理，不然新增的檔案 dosbox 會找不到。

``` nasm
.model small
.stack
.data
message   db "Hello world, I'm learning Assembly !!!", "$"
.code
main   proc
mov   ax,seg message
mov   ds,ax
mov   ah,09
lea   dx,message
int   21h
mov   ax,4c00h
int   21h
main   endp
end main
```

進入 dosbox 之後

    > c:
    > masm hello.asm  ::之後按三次回車
    Object filename [HELLO.OBJ]:
    Source listing [NUL.LST]:
    Cross-reference [NUL.CRF]:

這時會產生一個 HELLO.OBJ 檔案

    > link HELLO.OBJ  ::按三次回車
    Run File [HELLO.EXE]:
    List File [NUL.MAP]:
    Libraries [.LIB]:
    > HELLO.EXE
    Hello world, I'm learning Assembly !!!

成功^^

### 備註

每次要組譯都要打兩行指令，按六次回車不免太麻煩
於是可以寫一個mk.bat放在toos/masm/裡面

``` plain mk.bat
masm.exe %1.asm,%1.obj,nul.lst,nul.crf
link %1.obj,%1.exe,nul.map,,
```

以後只要輸入下面指令就好了

    > mk hello ::不要加副檔名