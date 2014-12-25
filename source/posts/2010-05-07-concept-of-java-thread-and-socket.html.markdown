---
title: "Concept of Java Thread and Socket"
date: 2010-05-07 09:02:52 +0800
comments: true
category: Java
---

<iframe src="https://docs.google.com/present/embed?id=dfdphq6m_16gtjmk7hh&size=m" frameborder="0" width="555" height="451"></iframe>

當蔡神的小助教也要半個學期了，發現一些可愛的學弟妹到了學期中竟然還不懂什麼叫做物件，讓我有點憂心，所以藉著這次Lab12的機會來好好調校一下學弟妹= =+

短短二十五張已經是最短極限，再濃縮就沒東西了……感覺還有很多東西沒有講……

<!-- more -->

``` java
/*
 * Copyright 2010 CSsula.twgg.org. All Rights Reserved.
 * Author: Tony Jian
 * Descriptoin: Simply demostrate two ways to use Thread
 * Usage: java thread.ThreadDemo
 */

package thread;

public class ThreadDemo {

    public static void main(String[] args) {
        new ThreadA().start();
        new Thread(new RunnableB()).start();
    }
}

class ThreadA extends Thread {
    @Override
    public void run() {
        int i = 0;
        while (true)
            System.out.printf("ThreadA: %d\n", i++);
    }
}

class RunnableB implements Runnable {
    @Override
    public void run() {
        int i = 0;
        while (true)
            System.out.printf("ThreadB: %d\n", i++);
    }
}
```

``` java
/*
 * Copyright 2010 CSsula.twgg.org. All Rights Reserved.
 * Author: Tony Jian
 * Descriptoin: Simply demostrate two ways to use Thread
 * Usage: java net.InetAddressDemo
 */

package net;

import java.net.*;

public class InetAddressDemo {

    public static void main(String[] args) {
        try {
            //getLocalHost
            InetAddress local = InetAddress.getLocalHost();
            System.out.println(local);
            System.out.println(local.getHostName());
            System.out.println(local.getHostAddress());
            System.out.println();

            //getByName
            InetAddress cssula = InetAddress.getByName("cssula.twgg.org");
            System.out.println(cssula);
            System.out.println(cssula.getHostName());
            System.out.println(cssula.getHostAddress());
            System.out.println();

            //getAllByName
            InetAddress[] google = InetAddress.getAllByName("google.com.tw");
            for (InetAddress i : google) {
                System.out.println(i);
            }
        } catch (UnknownHostException e) {
            System.err.println("Unknow Host");
        }
    }
}
```

``` java
/*
 * Copyright 2010 CSsula.twgg.org. All Rights Reserved.
 * Author: Tony Jian
 * Descriptoin: An example of scanning ports from host
 * Usage: java net.ScanPort
 */

package net;

import java.net.*;
import java.io.*;

public class ScanPort extends Thread {

    public static String usage = "Usage: java net.ScanPort ";
    private final int port;
    private final String hostName;

    public ScanPort(String hostName, int port) {
        this.port = port;
        this.hostName = hostName;
    }

    public static void main(String[] args) {
        try {
            if(args.length == 1)
                for (int i = 0; i &lt; 1024; i++)
                    new ScanPort(args[0], i).start();
            else
                System.err.println(usage);
        } catch (Exception e) {
            System.err.println(usage);
        }
    }

    @Override
    public void run() {
        try {
            InetAddress address = InetAddress.getByName(hostName);
            try {
                Socket socket = new Socket(address, port); // The port is open if socket was created succeefully.
                System.out.printf("%nPort: %d Opened..", port);
                socket.close();
            } catch (IOException e) {
                System.out.print("."); // The port isn't open if socket throws IOException.
            }
        } catch (UnknownHostException e) {
            e.printStackTrace();
        }
    }
}
```

``` java
/*
 * Copyright 2010 CSsula.twgg.org. All Rights Reserved.
 * Author: Tony Jian
 * Descriptoin: An example of multithreading echo server
 * Usage: java net.EchoServer
 */

package net;

import java.net.*;
import java.io.*;

public class EchoServer extends Thread {

    public static String usage = "Usage: java net.EchoServer ";
    private final int port;
    private ServerSocket srvSock;
    private Socket clnSock;

    public EchoServer(int port) {
        this.port = port;
        try {
            srvSock = new ServerSocket(port);
        } catch (IOException e) {
            System.err.println(e);
        }
    }

    public static void main(String[] args) {
        try {
            if (args.length == 1)
                new EchoServer(Integer.parseInt(args[0])).start();
            else
                System.err.println(usage);
        } catch (Exception e) {
            System.err.println(usage);
        }
    }

    @Override
    public void run() {
        try {
            while (true) {
                System.out.printf("Server: Port %d waiting for connection...\n", port);
                clnSock = srvSock.accept();
                System.out.printf("Server: connected with %s\n", clnSock.getInetAddress().getHostAddress().toString());
                new EchoChildServer(clnSock).start();
            }
        } catch (IOException e) {
            System.err.println(e);
        }
    }

    class EchoChildServer extends Thread {

        private Socket clnSock;
        private BufferedReader sockIn;
        private PrintStream sockOut;

        public EchoChildServer(Socket clnSock) {
            try {
                this.clnSock = clnSock;
                sockIn = new BufferedReader(new InputStreamReader(clnSock.getInputStream()));
                sockOut = new PrintStream(clnSock.getOutputStream());
            } catch (IOException e) {
                System.err.println(e);
            }
        }

        @Override
        public void run() {
            try {
                String message;
                while ((message = sockIn.readLine()) != null) {
                    if (message.equals("/bye")) {
                        break;
                    }
                    System.out.printf("%s: %s\n", clnSock.getInetAddress().getHostAddress().toString(), message);
                    sockOut.printf("echo: %s\n", message);
                }
                System.out.printf("Server: %s leaved\n", clnSock.getInetAddress().getHostAddress().toString());
                clnSock.close();
            } catch (IOException e) {
                System.err.println(e);
            }
        }
    }
}
```