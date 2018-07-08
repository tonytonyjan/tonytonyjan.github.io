---
title: cron 如何忽略系統的環境變數
date: 2018-07-08 14:57 +08:00
tags: [Docker, cron, UNIX]
description: 本文並不會告訴你如何將環境變數傳入 cron 工作，而是記錄了筆者探究 cron 如何處理環境變數的過程。
---

# cron 的環境變數去哪了？

這大概是碼農們時常會遇到的問題之一了，明明設定好的環境變數在殼層操作沒有問題，但是同樣的指令在 cron 卻會出現找不到該指令或找不到環境變數的錯誤。

為了偵錯，這時筆者通常會在 cron 腳本設定：

```
* * * * * env > /var/log/env.log
```

靜待一分鐘後觀察 `/var/log/env.log` 的內容，以決定要補上那些缺漏的環境變數。

筆者將以類似這樣技巧來重現問題與實驗，並且透過以下 `Dockerfile` 作為基礎：

```dockerfile
FROM debian:stretch-slim
RUN echo 'deb-src http://deb.debian.org/debian stretch main' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y procps cron vim dpkg-dev
```

# 問題重現

透過 `docker run -e FOO=BAR` 可以將環境變數 `FOO=BAR` 設定在 Docker container 的 init 程序，由於 init 程序是 UN*X 啟動時開天闢地的第一個程序，其他的程序都是由此程序衍生出來，所以除非做了特別設定，否則所有程序能繼承到 `FOO` 環境變數。

讓我們驗證一下：

```
$ docker run --rm -e FOO=BAR IMAGE_NAME env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=20794784a3ce
FOO=BAR
HOME=/root
```

我們可以看到 `FOO=BAR` 確實傳進去了，接著，我們再用 cron 做另外一個實驗：

```
$ docker run --rm -e FOO=BAR IMAGE_NAME sh -c 'echo \'* * * * * env > /var/log/env.log\' | crontab - && cron && sleep $((62 - $(date +%S) )) && cat /var/log/env.log'
HOME=/root
LOGNAME=root
PATH=/usr/bin:/bin
SHELL=/bin/sh
PWD=/root
```

- `sleep $((62 - $(date +%S) ))` - 指的是「睡到秒針到 2」。

從印出的結果發現，同樣是 `env` 指令，在殼層執行與 cron 執行的結果並不一致。首先 `FOO=BAR` 消失了，甚至 `PATH` 裡的路徑也差異極大，從原本的 `/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin` 變成僅剩下 `/usr/bin:/bin`，這可以說明為何許多人在 cron 腳本中使用指令時，習慣使用絕對路徑，或者在腳本上方定義明確定義 `PATH` 變數。

## cron 的 forking 過程

> 那麼 cron 是在哪個階段把環境變數清掉的呢？

由於筆者深受「知其然不知其所以然」的痛苦，不得不調查 cron 到底在搞什麼鬼。在此推薦一個好用的指令：

```sh
ps wwefxo pid,ppid,command
```

- `ww` - 無視終端機的寬度，將結果都印出
- `e` - 印出環境變數
- `f` - 以樹狀的方式呈現
- `x` - 印出不被任何終端所控制的程序，例如守護行程
- `o pid,ppid,command` - 只印出程序的 pid、ppid、command

更多用法請參考 [man ps](https://linux.die.net/man/1/ps)

用同樣的技巧再作一次實驗：

```
$ docker run --rm -e FOO=BAR foo sh -c 'echo \'* * * * * ps wwefxo pid,ppid,command > /var/log/ps.log\' | crontab - && cron && sleep $((62 - $(date +%S) )) && cat /var/log/ps.log'
  PID  PPID COMMAND
    1     0 sh -c echo '* * * * * ps wwefxo pid,ppid,command > /var/log/ps.log' | crontab - && cron && sleep $((62 - $(date +%S) )) && cat /var/log/ps.log PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin HOSTNAME=87736bfa1426 FOO=BAR HOME=/root
   11     1 cron HOSTNAME=87736bfa1426 HOME=/root PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin FOO=BAR PWD=/
   14    11  \_ CRON HOSTNAME=87736bfa1426 HOME=/root PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin FOO=BAR PWD=/
   15    14      \_ /bin/sh -c ps wwefxo pid,ppid,command > /var/log/ps.log SHELL=/bin/sh HOME=/root PATH=/usr/bin:/bin LOGNAME=root
   16    15          \_ ps wwefxo pid,ppid,command HOME=/root LOGNAME=root PATH=/usr/bin:/bin SHELL=/bin/sh PWD=/root
   13     1 sleep 57 HOSTNAME=87736bfa1426 HOME=/root PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin FOO=BAR PWD=/
```

由此可見當 cron 執行一份工作項目時，整體程序的祖孫結構如下：

```
init -> cron -> cron -> sh -> cron job
```

cron 會額外再 fork 一次自己，然後再執行 `sh -c "JOB STRING"`，而環境變數正是在這個階段消失的。

截至目前為止我們僅知道執行 `sh` 時，環境變數已經被改變，無法說明為何環境變數會莫名奇妙消失。筆者起初猜測是 cron 有使用 `env -i` 指令，但從程序樹的結果來看則不然。

無計可施，只好翻了一下 cron 的原始碼，在 `do_command.c` 找到了線索：

```
$ docker run --rm -e FOO=BAR -w /usr/src -v (pwd)/src:/usr/src IMAGE_NAME apt-get source cron
$ grep -C 3 --color '"-c"' (find src -name do_command.c)
                            }
                        }
#endif
                        execle(shell, shell, "-c", e->cmd, (char *)0, jobenv);
                        fprintf(stderr, "%s: execle: %s\n", shell, strerror(errno));
                        _exit(ERROR_EXIT);
                }
```

原來 cron 在執行 `sh` 指令時，使用了 `execle`，且在最後的參數傳入了自訂的環境變數 `jobenv`。

引用一段 `execle` 的 `man` 頁面：

> The execle() and execvpe() functions allow the caller to specify the environment of the executed program via the argument envp. The envp argument is an array of pointers to null-terminated strings and must be terminated by a NULL pointer. The other functions take the environment for the new process image from the external variable environ in the calling process.  - https://linux.die.net/man/3/execle

然後於是筆者在 `entry.c` 找到了設定環境變數的地方

```
$ grep -B 2 --color 'env_set' (find src -name entry.c)
        if (!env_get("SHELL", e->envp)) {
                snprintf(envstr, MAX_ENVSTR, "SHELL=%s", _PATH_BSHELL);
                if ((tenvp = env_set(e->envp, envstr))) {
--
        if (!env_get("HOME", e->envp)) {
                snprintf(envstr, MAX_ENVSTR, "HOME=%s", pw->pw_dir);
                if ((tenvp = env_set(e->envp, envstr))) {
--
        if (!env_get("PATH", e->envp)) {
                snprintf(envstr, MAX_ENVSTR, "PATH=%s", _PATH_DEFPATH);
                if ((tenvp = env_set(e->envp, envstr))) {
--
        }
        snprintf(envstr, MAX_ENVSTR, "%s=%s", "LOGNAME", pw->pw_name);
        if ((tenvp = env_set(e->envp, envstr))) {
--
#if defined(BSD)
        snprintf(envstr, MAX_ENVSTR, "%s=%s", "USER", pw->pw_name);
        if ((tenvp = env_set(e->envp, envstr))) {
```

分別設定了 `SHELL`、`HOME`、`PATH` 和 `LOGNAME`，這 4 的變數和上述用 `ps` 所觀測的環境變數，`SHELL=/bin/sh HOME=/root PATH=/usr/bin:/bin LOGNAME=root`，其結果是完全吻合的。


至此，真相大白。

# 後記

- 本文中的 cron 指的是大多數人所使用的 vixie cron，如果是 busybox 的實作則不會出現這個問題，在 busybox 裡面，cron 工作的程序環境變數會繼承父程序。
- 感謝吾友 @floydwch 提出了的問題，使筆者學到不少知識。