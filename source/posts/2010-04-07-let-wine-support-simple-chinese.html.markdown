---
title: "讓 wine 再也不怕簡中"
date: 2010-04-07 16:05:49 +0800
comments: true
categories: FreeBSD
---

要安裝的一個簡中 win32 程式時出現了火星文……於是展開了爬文之旅，以下解決方式是更改登錄檔：

<!-- more -->

1.  將以下的文字存成 `winfonts.reg` 到 `/home/username/Desktop`。

        REGEDIT4
        [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes]
        "Arial"="Arial"
        "Arial CE,238"="PMingLiU"
        "Arial CYR,204"="PMingLiU"
        "Arial Greek,161"="PMingLiU"
        "Arial TUR,162"="PMingLiU"
        "Courier New"="Courier New"Courier New CE,238"="PMingLiU"
        "Courier New CYR,204"="PMingLiU"
        "Courier New Greek,161"="PMingLiU"
        "Courier New TUR,162"="PMingLiU"
        "MingLiU"="MingLiU"
        "PMingLiU"="PMingLiU"
        "FixedSys"="PMingLiU"
        "Helv"="PMingLiU"
        "Helvetica"="PMingLiU"
        "MS Sans Serif"="PMingLiU"
        "MS Shell Dlg"="PMingLiU"
        "MS Shell Dlg 2"="PMingLiU"
        "System"="PMingLiU"
        "Tahoma"="PMingLiU"
        "Times"="Times"
        "Times New Roman"="Times New Roman"
        "Times New Roman CE,238"="PMingLiU"
        "Times New Roman CYR,204"="PMingLiU"
        "Times New Roman Greek,161"="PMingLiU"
        "Times New Roman TUR,162"="PMingLiU"
        "Tms Rmn"="PMingLiU"

2.  下載 <a href="http://mingliu.myweb.hinet.net/MingLiu/MingLiU.zip">PMinLiu</a> 並解壓縮

        $ mv MingLiu.ttc /home/username/.wine/drive_c/windows/Fonts
        $ wine ~/.wine/drive_c/windows/regedit.exe ~/Desktop/winfonts.reg

3. 刪掉windonts.reg