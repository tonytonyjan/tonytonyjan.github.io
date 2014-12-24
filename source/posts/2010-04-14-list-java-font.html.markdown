---
title: "列出系統中 Java 可用字型"
date: 2010-04-14 21:18:02
comments: true
categories: Java
---

由於 GUI 無論文字，都是用「畫」出來的，第一件事情就是要取得自身的圖形環境（GraphicaEnvironment）

要取得它可以用 GraphicsEnvironment 類別中的 `static function getLocalGraphicsEnvironment()`，然後再呼叫 `getAvailableFontFamilyNames()`，這個方法會回傳一個字串陣列，存放著圖形環境中所有的 font families。

<!--more-->

```java
String[] fontList = GraphicsEnvironment.getLocalGraphicsEnvironment().getAvailableFontFamilyNames();
```

以下是筆者寫的一個小程式可以印出所有的字型＠＠

``` java
/////////////////////////////////////////////////////////////////////
// Copyright (c) 2010 Do-Some Studio All rights reserved. //
// Author: Tony Jian                                      //
/////////////////////////////////////////////////////////////////////
import java.awt.*;
import javax.swing.*;

public class FontList extends JFrame{
	static String[] fontList = GraphicsEnvironment.getLocalGraphicsEnvironment().getAvailableFontFamilyNames();
	static JLabel[] labelList = new JLabel[fontList.length];
	
	public FontList(){
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		JPanel panel = new JPanel(new GridLayout(fontList.length,1));
		for(int i=0;i<fontList.length;i++){
			labelList[i] = new JLabel(fontList[i]);
			labelList[i].setFont(new Font(fontList[i], Font.PLAIN, 24));
			panel.add(labelList[i]);
		}
		add(new JScrollPane(panel));
		pack();
		setVisible(true);
	}
	
	public static void main(String[] args){
		FontList f = new FontList();
		for(String i:fontList) System.out.println(i);
	}
}
```

![](/images/cssula-blog/Screenshot-13.png)