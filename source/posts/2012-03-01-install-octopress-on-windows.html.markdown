---
title: "在 Windows 使用 Octopress"
date: 2012-03-01 15:47 +0800
comments: true
categories: Octopress
---

[Octopress]: http://octopress.org
[Jekyll]: http://jekyllrb.com
[Ruby Downloads]: http://www.ruby-lang.org/en/downloads
[Ruby Installer]: http://rubyinstaller.org/downloads
[rdiscount]: https://github.com/rtomayko/rdiscount
[msys]: http://www.mingw.org/wiki/MSYS
[Git]: http://git-scm.com
[Python]: http://python.org/download/windows
[RubyPython]: http://rubypython.rubyforge.org
[Pygment]: http://pygments.org/
[MarkdownPad]: http://markdownpad.com/

## 安裝 Ruby

雖然你也可以安裝 [RVM][Ruby Downloads] 或者自行編譯，但既然是在 Windows 下，建議直接使用 [Ruby Installer] 最省事。在此要下載兩個東西，一就是 ruby ，另一個則是 development kit。之所以要後者是因為屆時在安裝 Octopress 時，所需要用到的 ruby gems 會需要在本地編譯（例如 [rdiscount]）。而 development kit 是一套基於 [MSYS/MinGW][msys] 下的 C/C++ 編譯環境工具組，安裝時請跟著[官網上的指示](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit)即可，你大概會輸入以下指令：

    cd C:\Devkit
    ruby dk.rb init :: 產生 config.yaml，裡面有你的 ruby 路徑，一般會幫你設好
    ruby dk.rb install

為了保險起見，安裝之後先更新一下 gem 是個好習慣。

    gem update --system
    gem update

<!-- more -->

## 安裝 Git

下載 [Git] 之後，安裝時請選擇 label 上有類似「Full installer for official Git for Windows」之類的字樣。

## 安裝 Octopress

    git clone git://github.com/imathis/octopress.git DIR_NAME
    cd DIR_NAME
    gem install bundler
    bundle install :: 安裝 Gemfile 檔案中所列的 gems
    rake install :: 安裝預設的 Octopress 樣式

如果你只是想要寫一般的文字網誌，那麼到此為止即可；如果想要加上一些分享代碼，當然你也可以使用 markdown 內附的 code block syntax，但要是你希望可以將程式碼上色或加上行號（也就是 [Octopress plugins](http://octopress.org/docs/plugins/) 裡面的 Backtick Code Block、Code Block 和 Include Code 功能），再安裝 Python 2.7。

## 安裝 Python

之所以要安裝 Python 是因為 Octopress 的代碼上色 plugin 是用 Python 的一個開源項目：[Pygment]，雖然 Pygment 支援 Python 2 版和 3 版，不過由於 Ruby 和 Python 之間的橋接是用 [RubyPython] 完成，而 RubyPython 目前只支援 Python 2。所以還是乖乖安裝 2 版吧！

## 遇到問題
### RubyPython

還有一點想在此特別提出，當我進行到這個步驟後，以為可以從此高枕無憂寫文章時，在文章中使用 code block 的功能並且執行 `rake generate`，不料卻噴了一大堆錯誤：
    (LoadError)ib/ruby/gems/1.9.1/gems/ffi-1.0.9-x86-mingw32/lib/ffi/library.rb:75:in `block in ffi_lib': Could not open library '.dll': 找不到指定的模組。
          from C:/Ruby193/lib/ruby/gems/1.9.1/gems/ffi-1.0.9-x86-mingw32/lib/ffi/library.rb:54:in `map'
          from C:/Ruby193/lib/ruby/gems/1.9.1/gems/ffi-1.0.9-x86-mingw32/lib/ffi/library.rb:54:in `ffi_lib'
          from C:/Ruby193/lib/ruby/gems/1.9.1/gems/rubypython-0.5.1/lib/rubypython/python.rb:30:in `<module:Python>'
          from C:/Ruby193/lib/ruby/gems/1.9.1/gems/rubypython-0.5.1/lib/rubypython/python.rb:21:in `<top (required)>'
    ...

一開使找不到原因，所以去問 Google，找到[這篇文章](http://mattn.github.com/blog/2011/10/21/octopress-pygments-utf8/)，提到 rubypython 需要 python27.dll，但由於在 C:\python\libs 下找不到，於是作者將 C:\windows\system32\python27.dll 複製過去便解決了這個問題。而我也照做了，果然！

果然事情沒有憨人想的這麼簡單，錯誤訊息原封不動地噴出來。經過 trace code 之後：

``` ruby C:\Ruby193\lib\ruby\gems\1.9.1\gems\rubypython-0.5.1\lib\rubypython\python.rb:26
    PYTHON_LIB = EXEC.library
    # FFI::DynamicLibrary::RTLD_LAZY | FFI::DynamicLibrary::RTLD_GLOBAL
    ffi_lib_flags :lazy, :global
    ffi_lib EXEC.library
```

我發現問題出在 EXEC.library 一直是 nil 所導致，神奇的是我用 irb 去測試同樣的代碼，卻可以正常運作，而且 python27.dll 明明就在預設的 path 中能找到。找不到原因，最後我只好決定使用最黑暗的方法解決這個問題：

``` ruby C:\Ruby193\lib\ruby\gems\1.9.1\gems\rubypython-0.5.1\lib\rubypython\python.rb:26
    PYTHON_LIB = EXEC.library
    # FFI::DynamicLibrary::RTLD_LAZY | FFI::DynamicLibrary::RTLD_GLOBAL
    ffi_lib_flags :lazy, :global
    # ffi_lib EXEC.library # 問題出在 EXEC.library 一直是 nil，所以就乾脆註解掉
    ffi_lib "python27" # 直接加上字串
```

RubyPython 對 Windows 的支援沒有很好是被公認的，而我今天也領教到了。

### UTF-8 編碼

嘗試在 windows 下使用 octopress，幾乎快被 Windows 的編碼問題搞死！

繁中版 Windows 預設都是以 Big5 為編碼，所以輸入 `rake generate` 時，如果文章裡面出現 utf-8 編碼，就會出錯。雖然這個問題只要在文章都以 big5 撰寫的前提下獲得解決，但我不太建議這麼做。以前寫網頁大多人都喜歡用 big5，但這僅限於台港中地區，只要出了這個地方往往會有亂碼，且現在寫網頁也多建議用 utf-8。

解決方式是在 `rake generate` 之前先設定變數：

    set LANG=zh_TW.UTF-8
    set LC_ALL=zh_TW.UTF-8

另外我們還要有個可以編寫 utf-8 文件的編輯器才行，我習慣用 [notepad++](http://notepad-plus-plus.org)。或者你也可以使用 [MarkdownPad]，一個在 Windows 下專門編寫 markdown 的編輯器。

大功告成，如此即可在 windows 寫 utf-8 編碼的部落格。如果嫌指令麻煩，可以寫成 batch：

``` bat gen.bat
@echo off
set LANG=zh_TW.UTF-8
set LC_ALL=zh_TW.UTF-8
bundle exec rake generate
```