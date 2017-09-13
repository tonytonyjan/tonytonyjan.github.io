---
title: "用 Java 掃描閘道"
date: 2010-04-29 00:27:15 +0800
category: 程式
tags: [Java]
---
這是一個用來掃描一台機器開放了哪些 port 的程式，主要用到了 Thread 與 Socket 兩個 Class。可能有人會說：「啥？這樣做可以幹麼呢？？」。嘿嘿，其實當一名駭客要試圖攻進一台機器時，掃描 port 是常見的第一步驟喔。這下不敢小看它了吧XD

![](/images/cssula-blog/l2_javame_duke_sdk3.gif)

（圖文無關，只是偶然看到 Duke 和手機合影XD）

<!-- more -->

碎碎念：

<ol>
	<li>主機預設ports有65536個（short型態）， port以1024為交界又可分兩部分</li>
	<li>1023以下的ports是常見的服務，且只能由該機器的root開啟port</li>
	<li>1024以上ports多用於client端</li>
	<li>Java裡與網路相關的Classes大部分放在java.net裡面</li>
	<li>Socet無法建立TCP連線的時候會丟出IOException</li>
	<li>getByName(String hostName); 失敗時會丟出UnknownHostException</li>
</ol>

``` java
/*
 * Copyright 2010 CSsula.twgg.org. All Rights Reserved.
 * Author: Tony Jian
 */
import java.io.*;
import java.net.*;

public class ScanPort extends Thread{
	int port;
	String hostName;

	public ScanPort(String hostName, int port){
		this.port = port;
		this.hostName = hostName;
	}

	public static void main(String[] args){
		for(int i=0;i&lt;1024;i++){
			new ScanPort(args[0], i).start();
		}
	}

	@Override
	public void run(){
		try{
			InetAddress address = InetAddress.getByName(hostName);
			try{
				Socket socket = new Socket(address, port); // The port is open if socket was created succeefully.
				System.out.printf("%nPort: %d Opened..", port);
				socket.close();
			}catch(IOException e){
				System.out.print("."); // The port isn't open if socket throws IOException.
			}
		}catch(UnknownHostException e){
			e.printStackTrace();
		}
	}
}
```

![](/images/cssula-blog/Screenshot-18.png)