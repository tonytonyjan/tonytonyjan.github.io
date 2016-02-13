---
title: Rails on webpack
date: 2016-02-10 22:35 +0800
category: 程式
tags: Ruby on Rails, webpack
description: 覺得 Rails 與 webpack 的整合不需要像網路上找到的各種教學文或是 gem 搞的那樣複雜，所以想藉這篇文章分享自己的做法。
github: https://github.com/tonytonyjan/webpack_stats
---

記得筆者在去年於 RubyConf Taiwan 講的題目「[還給前端工程師一片天空](https://youtu.be/0mphTtsekkI?t=2m59s)」中提到如何整合 Rails 與 Node.js 世界的工具，[投影片在此](/slides/2015-09-11-return-front-end-back-to-front-end-developers/slides.pdf)。雖然 [webpack](https://github.com/webpack/webpack) 正夯，但礙於筆者當時沒去研究，使用的工具仍是上一代的 gulp、bower，所幸議程也有相關的講題，如**何澤清**前輩的「[gem 'webpack-rails'](https://www.youtube.com/watch?v=vbdVuEctCCQ)」。

只是經過筆者幾番研究之後，覺得整合這兩樣東西似乎不需要像網路上找到的各種教學文或是 gem 搞的那樣複雜，所以想藉這篇文章分享自己的做法（但並不保留 sprockets）。在那之前，先分享一些小知識：

<!-- more -->

# asset_path 知多少？

`#asset_path` 是 Rails 中其中一個底層 API，許多 helper 如 `#image_tag` 等都會調用，而若沒有特別查閱原始碼，大概不多人知道 `asset_path('/app.js')` 和 `asset_path('app.js')` 差了一個斜線會影響結果，至於差在哪就讓我們節錄部份原始碼：

```ruby
def asset_path(source, options = {})
  # ...
  if source[0] != ?/
    source = compute_asset_path(source, options)
  end
  # ...
end
```

sprockets 其實有偷偷去複寫 `#compute_asset_path`，也就是說當傳入 `"/app.js"`，assets pipeline 是不會運作的，但若傳入 `"app.js"`，在 sprockets `#compute_asset_path` 的加持下結果會長的像 `/assets/app-c5bd5cb45ee76432b26a5dfb28e01b59.js?body=1`；反之若 `"app.js"` 檔案不存在，或者根本就沒安裝 sprockets，那就退回原型得到 `"/app.js"`。

所以只要我們複寫的 `#compute_asset_path` 能算出 webpack 產生在 `public/assets` 中的正確路徑，其實不用更改任何 API，就可以輕鬆整合 webpack。而 `#javascript_include_tag`、`#stylesheet_link_tag`、`#image_tag` 等 helper 都可以照常使用。

# webpack --json

sprockets 在編譯後會產生 `manifest.json`，裡面有 asset 原始路徑與其計算後的路徑資訊（例如 `app.js` 對應到 `/assets/app-c5bd5cb45ee76432b26a5dfb28e01b59.js`，以 Hash 儲存），好處是 Rails 可以透過讀檔取得計算後的路徑結果，不須透過 sprockets，所以為了增加效能，這個檔案在 production 環境中是必要的，而在 development 環境中，由於 assets 的路徑是及時透過 sprockets 得出，所以並不需要這個檔案。

此外 sprockets 在 controller 與 router 中也動了手腳，這也是為什麼專案中 `public/assets` 明明沒東西，而在 development 環境下中送出像是 `/assets/ooxx.js` 的請求卻仍可以正常運作的原因。

只是 webpack 畢竟是 Node.js 世界的產物，無法篡改 Rails controller 與 router，好消息是 `webpack --json` 會產生一個跟 `manifest.json` 類似的檔案（官方稱之為 stats file）。所以只要在 `webpack.config.js` 中加入產生 stats 的 plugin，再用 `webpack --watch` 來開發就已經綽綽有餘了，例如我們在專案的根目錄下產生 `stats.json`：

```js
plugins = [
  function() {
    this.plugin('done', function(stats) {
      require('fs').writeFileSync(__dirname + '/stats.json', JSON.stringify(stats.toJson()))
    })
  }
]
```

# 範例專案

筆者[在 Github 實作了一個範例](https://github.com/tonytonyjan/rails_on_webpack)，重點只在兩個檔案： [app/helpers/webpack_helper.rb](https://github.com/tonytonyjan/rails_on_webpack/blob/master/app/helpers/webpack_helper.rb) 與 [lib/webpack_stats.rb](https://github.com/tonytonyjan/rails_on_webpack/blob/master/lib/webpack_stats.rb) 。

`webpack_stats.rb` 負責載入 webpack 產生的 `stats.json`，經過處理之後產生一個 assets hash，例如：

```ruby
{
  'app.js' => '/assets/app.js',
  'app.css' => '/assets/app-c5bd5cb45ee76432b26a5dfb28e01b59.css' # 也支援 hash 尾綴
}
```

（限制是 webpack 必須遵守檔名格式為 `filename-hash.extname` 或是 `filename.extname`。）

而這個 assets hash 將被用在 `#compute_asset_path`：

```ruby
# app/helpers/webpack_helper.rb
require 'webpack_stats'
module WebpackHelper
  def compute_asset_path source, options = {}
    WebpackStats.assets[source] || super
  end
end
```

大功告成！老實說這樣就已經能完美運作了，不用安裝什麼 gem，實測用來寫 react 也不用安裝 [react-rails](https://github.com/reactjs/react-rails)。而剩下的問題已經不關整合的事，像要加入 SASS、CoffeeScript 或是 Font Awesome 等，或是在 production 下要壓縮 JavaScript 並且分離 CSS 檔案等，這取決開發者對 webpack 的掌握。

至於只在 production 中分離 CSS 檔案，裡面可以這樣寫：

```html
<%= stylesheet_link_tag 'application', media: 'all' if Rails.env.production? %>
```

至於為何要這樣做，可參考 extract-text-webpack-plugin 的 [README](https://github.com/webpack/extract-text-webpack-plugin/blob/master/README.md) 提到的優缺點。

# 我就是要 gem

其實筆者也是有做啦⋯⋯如果真的覺得那兩個檔案很麻煩，可以安裝 [webpack_stats](https://github.com/tonytonyjan/webpack_stats)，這除了可以用在 Rails，也可以當一般 webpack stats 的 loader 使用（用在 Rails 之外的地方）。