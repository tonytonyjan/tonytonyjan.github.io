---
title: "System V 與 Upstart"
date: 2013-06-26 10:53 +0800
comments: true
categories: Ubuntu
---
[Upstart]: http://upstart.ubuntu.com
[System V]: https://en.wikipedia.org/wiki/UNIX_System_V

最近剛好將某個過去架設的 Heroku-like server，用 [Upstart] 將傳統的 [System V] 替換掉，在此做個筆記，這篇文章不會教你怎麼寫啟動腳本，就只是個簡介。

Upstart 早在 Ubuntu 6.10 的時候首次出現，以取代傳統的 sysvinit。結果因為好評不斷，Fedora 9、Debian、Google Chrome OS 也相繼使用。其中一個最大的原因在啟動程序時採用了異步啟動（asynchronously）的方式。即便如此，鑑於不是所有的程式都有 upstart 的格式，最新的 Ubuntu 版本仍然保留了傳統的 sysvinit 啟動方式。

## System V

若遵循古法，當希望某程式能在 Linux 啟動的時候執行，會放個腳本在 `/etc/init.d`，（通常能在 `/etc/init.d/skeleton` 找到範例），同時用 `update-rc.d`（在 RedHat 家族是  `chkconfig`）決定是否啟用該服務。這個指令會根據 `/etc/init.d/` 產生一堆軟連結（symbolic links）在 `/etc/rc#.d/`。內容物大概長的像 `K##foo` 或 `S##bar`，用以決定 kill 或 start 的順序。

但是系統要啟動的時候，由於程序是乖乖的依序一個個執行（即便沒有相依關係），這將大大降低啟動的速度。為了改善這個問題，Upstart 誕生了。

## Upstart

Upstart 是一個事件驅動的啟動工具，根據 job definition files（`/etc/init/*.conf`），定義哪些服務應該在何時、何種情境下被執行，有別於 System V 的依序啟動，Upstart 的程序是異步執行的，好處是可以有效的利用系統資源，讓系統更快速的啟動（例如網路正在初始化的時候可以同時啟動一些硬碟或處理器相關的服務）。此外比起 System V 格式的腳本，`*.conf` 的腳本更易於閱讀使用。


## 停用/啟用

注意：一般而言，除非你清楚某 service 是幹嘛的，否則應該養成別亂停用服務的習慣。

如果我們今天想停用/啟用某個服務，但不知道他是否支援 upstart，可以先到 `/etc/init` 看看他是否有設定檔，或執行以下指令測試：

    $ sudo status mysql
    mysql start/running, process 12461

<!---->

    $ sudo status postgresql
    status: Unknown job: postgresql

以此為例，如果你想停用 mysql，可以直接在 `/etc/init/mysql.conf` 裡面，將檔頭附近某個以 `start on` 開頭的那行給註解掉，或是使用 `manual` 指令：

    # sudo
    $ echo 'manual' | sudo tee /etc/init/mysql.override # 當你不希望動到原設定，那就放個 `*.override`。

或是：

    # root
    $ echo manual >> /etc/init/smbd.conf

備註：更詳細的使用方法請閱讀 `man 5 init`，裡面有包括 `*.override` 的使用案例。

至於 `/etc/init/postgresql.conf` 不存在，要馬自己寫，否則仍可用傳統的方式停用：

    sudo update-rc.d apache2 disable
    sudo service apache2 stop
