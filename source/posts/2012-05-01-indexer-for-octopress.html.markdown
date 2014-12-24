---
title: "將 Octopress Page 依照標題自動索引"
date: 2012-05-01 13:30 +0800
comments: true
categories: [Octopress, Jekyll]
---

*   [範例展示、文件](/projects/octopress-indexer)
*   [gist](https://gist.github.com/2565249/6151c81f7af333d5c1d9dd0b2bdcba2c7a966dca)

## 用法懶人包

1.  下載 [Indexer for Octopress](https://gist.github.com/gists/2565249/download)。
2.  將 `indexer.rb` 複製到 `plugins` 目錄下。
3.  新增 `source\_includes\custom\asides\indexer.html`。

        {% raw %}
        {% if page.indexer == true %}
          <section>
          <h1>Catalog</h1>
          {{ page.indexer_aside }}
          </section>
        {% else %}
          {% if site.page_asides.size %}
            {% include_array default_asides %}
          {% endif %}
        {% endif %}
        {% endraw %}

4.  編輯 `_config.yml`。

        # Each layout uses the default asides, but they can have their own asides instead. Simply uncomment the lines below
        # and add an array with the asides you want to use.
        # blog_index_asides:
        # post_asides:
        page_asides: [custom/asides/indexer.html] # 加上這個

5.  完成！之後只要在你需要索引的 page 上方 YAML 區塊加上 `indexer: true`，右方欄位就會自己索引了。

<!-- more -->

## 為什麼有這種需求？

有想過用 Octopress 寫說明文件，雖然用 Markdown 可以很方便的杜撰，但文章只要一長了，要找標題特定的內容不用滑鼠滾輪一個一個找，就得用搜尋的，而且無法一次觀看到整篇文章的大綱。這時候最適合用索引來解決這個問題，而索引的優點之多，我想有寫過教學文件或是 wiki 的人應該是最清楚不過了。

但是 Octopress 如果要做到這樣，你要嘛用 Textile 取代 Mardown，如果用 Markdown 就還要徒手寫 tag，例如：

    <h2 id="getting-start">起步走</h2>

**這會讓寫作的爽度降低。**

但有人可能會說改用 Textile 就好了，確實，但麻煩的在後面：就算你用 Textile 好了，你還得為你的文件特地寫一個 aside，裡面有個兩層的 list，每個標題都有 `<a>` 包起來，還得自己寫 `href="#xxx"`。

**這更讓寫作的爽度降到冰點。**

好吧，萬一你是個很有耐心的人，你確實的在文章的 heading 都加上了 ID，且也自己寫了一個 asides 放在 `source\_includes\custom\asides\` 之下。但當你要設定 `_config.yml` 時發現：

    page_asides: [custom/asides/xxx.html]

![](/images/dead-eyes.jpg)

原來 page asides 是全局的，意思是接下來要處理的問題：你要怎麼在不影響其他的 page 的情況下，在特定 page 顯示特定 page？

這時候我就期望尋求一個方法，讓寫作只要專心在 heading 的編排就好，不用理會索引這樣瑣碎的工作。

## 你寫這個幹麼？

當然是為了解決自己問題（但也有可能同時是別人的問題）。

因為翻譯 Rails Guide 的關係，這幾天常常光顧 [docrails](https://github.com/lifo/docrails)，以及 [Rails](https://github.com/rails/rails) 的倉庫。對 Rilas Guide 生成文件的方式感到好奇，以 [Getting Start with Rails](http://guides.rubyonrails.org/getting_started.html) 這篇為例吧，右方的索引全部對應到左方的 h3 和 h4，也就是如果有個 heading 長這樣：

    <h3 id="guide-assumptions">1 Guide Assumptions</h3>

那麼右方所有就會有對應的

    <li><a href="#guide-assumptions">Guide Assumptions</a></li>

但實際上，在 Textile 文件中 他們實際是這樣寫的：

    h3. Guide Assumptions

研究了他們的原始碼，發現 Rails Guide 的 generator 在 render 之前做了這兩件事情：

1.  將所有的 heading 賦予同名 id。

    也就是將 `h3. Guide Assumptions` 替換成 `h3(#guide-assumptions). Guide Assumptions`。

2.  遞迴的方式產生清單。

    可以分析 `<h3>` 下的 `<h4>`，做出最多兩層的索引清單放在右方。

我馬上想到的一件事情就是，這功能可以用在 Octopress 上。