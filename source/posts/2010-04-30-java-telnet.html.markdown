---
title: "Java Telnet"
date: 2010-04-30 02:05:37 +0800
category: 程式
tags: Java
---

今天要來玩什麼好玩的呢？話說明天還有期中考，大兜竟然還有閒情逸致在這裡敲鍵盤（心虛中）……

不知道各位有沒有用過 telnet 的經驗，至少也打過類似 `telnet ptt.cc 23` 的指令吧？其實 telnet 不只可以拿來打B而已，他還可以拿來做很多事情喔～

<a href="http://cssula.twgg.org/wp-content/uploads/2010/04/duke-waving.gif">![](/images/cssula-blog/duke-waving.gif)</a>想要一起DIY的人快快來喔～～

<!-- more -->

telnet 也是 tcp/ip 協議的一員，有許多應用層的服務用的是 TCP 協定，拿 HTTP 為例子，如果懂得 HTTP 的 Header 的話，可以透過 telnet 建立連線發送 HTTP 要求，又例如 SMTP 協定用的也是 TCP 來傳訊，如果懂得 SMTP 的 Header，一樣可以用 telnet 來寄信。

什麼！？沒有試過？好吧，大兜勉強示範一下怎麼用XD

首先，要確認電腦有 telnet 可以用。（如果已經確認有 telnet 則可跳過此段）

但如果閣下用的電腦是 Vista 或 Windows 7，會在執行 `telnet` 時看到「'telnet' 不是內部或外部命令、可執行的程式或批次檔。」

很多人以為 Windows 在 Vista 以後的版本沒有 telnet，其實不然，只是沒有啟動而已，只要做到如下步驟即可：

開始-&gt;控制台-&gt;程式集-&gt;程式和功能-&gt;開啟或關閉windows功能，找到「telnet用戶端」溝選並確認。

![](/images/cssula-blog/Screenshot-21.png)

這下可以試試看輸入 `telnet bs2.to` 看看～

![](/images/cssula-blog/Screenshot-22.png)

打 B 人人會，下面示範怎麼發送 HTTP Request 給 google 搜尋 「tonytonyjan」。

進入 telnet：

![](/images/cssula-blog/Screenshot-23.png)

為了不要在連線後讓你的字打不出來，請在 open 之前打開 localecho。

輸入 `GET /search?q=tonytonyjan HTTP/1.1`，加上兩次 Enter：

![](/images/cssula-blog/Screenshot-24.png)

哇～～～～啥鬼！！

嘿～別慌別慌，仔細一看，會發現這些是熟悉的 html 標籤，隱約可以找到一些熟悉的網址，看到我的網誌了嗎XD，各位可以觀察一下在 google 首頁搜尋 tonytonyjan 得到的結果頁面，他的原始碼正和這個一樣。瀏覽器的工作，其實就是發送一大堆類似我們剛剛打的 GET 要求，以及這裡沒有提到的 POST 要求。

也就是說…如果你想要讓自己的部落格的搜尋次數上升的話……嘿嘿，= =+（我可是什麼也沒說喔～～XD）

該是回題的時候了，在 Java 裡面該怎麼寫一個 telnet 呢？其實只要理解下面的程式碼就可以達到我上一句話沒有說的事情^^"

下面這是個簡單的 Java Telnet 程式，Java 的 Socket 讓我們可以很方便的建立起 TCP 連線。我們所要做的就只是打造兩條穩定的管子，一條是從 stdin 到 socket，把鍵盤的輸入送出去；一條是 socket 到 stdout，把收到的訊息印出來。這兩件事情要同步做，所以各開一個 Thread，在此大兜將這兩條管子分別打造成兩個 Class（SocketToOut和InToSocket），並且皆繼承自 Thread。

這支陽春的程式提供參考，歡迎改良～～各位慢慢品嚐吧XD

### 碎碎念

<ol>
	<li>Telnet是許多駭……喔不……我是說是許多優良程式師的最愛</li>
	<li>Windows Vista和7並不是沒有telnet程式，只是沒有打開</li>
	<li>telnet屬於TCP/IP協議的一員，提供本機完成遠端工作的能力</li>
	<li><a href="http://zh.wikipedia.org/zh-tw/Http#.E4.BE.8B.E5.AD.90" target="_blank">這是</a>發送Http Request的例子</li>
	<li><a href="http://www.backup.idv.tw/viewtopic.php?=&amp;p=645" target="_blank">這是</a>發送SMTP Request來寄信的例子</li>
</ol>

``` java
/*
 * Copyright 2010 CSsula.twgg.org. All Rights Reserved.
 * Author: Tony Jian
 */
import java.io.*;
import java.net.*;

public class JavaTelnet{
	public static void main(String[] args) {
        String hostName;
        int port;
        InetAddress address;

        if(args.length == 2) {
            hostName = args[0];
            port = Integer.parseInt(args[1]);
        }else{
			System.out.println("Usage: java JavaTelnet address port");
			return;
		}

        try {
            address = InetAddress.getByName(hostName);
            try {
                Socket socket = new Socket(address, port);
                new SocketToOut(socket).start();
                new InToSocket(socket).start();
            } catch (IOException e) {
				System.err.println("Connection failed");
            }
        }
        catch(UnknownHostException e) {
			System.err.println("Unknown host");
        }
    }
}

class SocketToOut extends Thread {
    private Socket socket;
	private BufferedReader socketIn;

    public SocketToOut(Socket socket) throws IOException{
        this.socket = socket;
		socketIn = new BufferedReader(new InputStreamReader(socket.getInputStream()));
    }

	@Override
    public void run() {
        try {
            String line = null;
            while((line = socketIn.readLine()) != null) System.out.println(line);
            socket.close();
        } catch(IOException e) {
            System.out.println(e.toString());
        }
    }
}

class InToSocket extends Thread {
    private Socket socket;
	private PrintStream socketOut;
	private BufferedReader in;

    public InToSocket(Socket socket) throws IOException{
        this.socket = socket;
		socketOut = new PrintStream(socket.getOutputStream());
		in = new BufferedReader(new InputStreamReader(System.in));
    }

	@Override
    public void run(){
        try {
            while(!socket.isClosed()) socketOut.println(in.readLine());
        } catch(IOException e){
            e.printStackTrace();
        }
    }
}
```

![](/images/cssula-blog/Screenshot-19.png)
![](/images/cssula-blog/Screenshot-20.png)