---
title: "在目錄下打開命令提示字元"
date: 2012-03-06 23:03 +0800
comments: true
categories: Windows
---

這篇文章會告訴你在 windows 檔案總管，如何用右鍵快速在某個目錄下打開命令字元。

因為我發現周遭有很多習慣於命令列工作的人，仍傻呼呼的執行 `cmd.exe` 之後，一次又一次的 `cd`、`dir`，直到抵敵目的地。抑或先打開檔案總管，到目的地之後再複製目錄，貼到命令列，然後在前面再加個 `cd`。雖然後者又快了一點。若是可以對目錄右鍵之後，有個選項能打開當前目錄的命令提示字元，豈不是非常方便？

## Windows 7

1. 在檔案總管中選取你想要打開命令列的資料夾
2. `Shift` + 右鍵
3. 按下 'W'（或者左鍵點擊「開啟命令視窗」）

![](/images/right-click-prompt.png)

## Windows XP
### DIY
（這個方法需要動到你的登錄檔，如果你不敢改或者不擅長……請跳到下面的簡易版）

1. 執行 `regedit`
2. 找到 HKEY_LOCAL_MACHINE/Software/Classes/Folder/Shell
3. 新增一個鍵，命名為 `Command Prompt`
4. 預設值設定成 `Command Prompt Here`
5. 新增一個鍵，命名為 `Command`
6. 預設值設定成 `cmd.exe /k pushd %L`

之後你只要在資料夾上點右鍵，就會出現一個叫 `Command Prompt Here` 的選項。

### 簡單方法
[Windows 自己有開發這樣的功能，在 Power Toys 下，下載之後安裝就行了。](http://windows.microsoft.com/en-US/windows/downloads/windows-xp)