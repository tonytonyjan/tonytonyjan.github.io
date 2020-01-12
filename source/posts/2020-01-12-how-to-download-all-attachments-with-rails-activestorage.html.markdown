---
title: Rails ActiveStorage 一次下載所有檔案
date: 2020-01-12 14:44 +0800
tags: ["Rails", "Ruby", "ActiveStorage"]
---

自從 Rails 5.2 引進了 ActiveStorage 之後，似乎一直沒有看到什麼好方法可以一次下載所有的檔案。在 Rails 6 之後，多了 `ActiveStorage::Blob#open` 用以取代 `ActiveStorage::Downloading`，即便如此，`ActiveStorage::Blob#open` 仍然只能處理一個檔案。無論是 Google 還是 Stack Overflow，皆尚未能看到任何簡潔的做法。

<!-- more -->

# TLDR

```ruby
def download_all(attachments, files = [], &block)
  if attachments.empty?
    yield files
    return
  end

  attachments.first.open do |file|
    files << file
    method(__method__)[attachments[1, attachments.length - 1], files, &block]
  end
end
```

```ruby
download_all(record.attachments) do |files|
  pp files
end
```

# `ActiveStorage::Blob#open` 有什麼限制？

`ActiveStorage::Blob#open` 在處理單一檔案時沒什麼問題，具體使用方法如下：

```ruby
blob.open(tmpdir: "/path/to/tmp") do |file|
 file.class # => Tempfile
end
```

詳細資訊請參考[官方 API 文件](https://api.rubyonrails.org/v6.0.2.1/classes/ActiveStorage/Blob.html#method-i-open)。

其實作大概就是將檔案下載為暫存檔，而之所以不直接回傳 file 實體，改為用 block 來存取，是為了在 block 結束時自動將暫存檔刪掉，正如官方 API 文件所描述：

> The tempfile is automatically closed and unlinked after the given block is executed.

所以使用者在調用該方法時可以不用擔心下載後的檔案是否最終會塞滿硬碟空間，內部的實作已有做妥善的處理。

但若我們想手動刪除暫存檔，辦得到嗎？一個常見的用例是將所有的檔案打包後壓縮成一個檔案，直覺的解法是迭代所有的檔案，逐一調用 `ActiveStorage::Blob#open`，但由於 block 結束後會將檔案刪掉導致無法存取。讓我們看一下[原始碼](https://github.com/rails/rails/blob/f33d52c95217212cbacc8d5e44b5a8e3cdc6f5b3/activestorage/lib/active_storage/downloader.rb#L11-L17)：

```ruby
    def open(key, checksum:, name: "ActiveStorage-", tmpdir: nil)
      open_tempfile(name, tmpdir) do |file|
        download key, file
        verify_integrity_of file, checksum: checksum
        yield file
      end
    end
```

由於 `ActiveStorage::Blob#open` 最終會調用 `ActiveStorage::Downloader#open`，而 `ActiveStorage::Downloader#open` 卻僅支援 block 的寫法，導致無法將檔案迭代後再進行批次存取，因只要每次 block 一結束，該暫存檔就會被刪除。

# 解法 1 - 另外複製檔案

這個方法得記得手動把產生的檔案刪掉：

```ruby
files = []
record.attachments.each do |attachment|
  attachment.open do |file|
    new_path = "/usr/src/app/#{attachment.filename}"
    FileUtils.cp file.path, new_path
    files << new_path
  end
end
pp files
```

# 解法 2 - 迭代

這是筆者較常用的做法，暫存檔一樣會自動刪掉，但是必須在 block 內處理檔案，原始碼如下：

```ruby
def download_all(attachments, files = [], &block)
  if attachments.empty?
    yield files
    return
  end

  attachments.first.open do |file|
    files << file
    method(__method__)[attachments[1, attachments.length - 1], files, &block]
  end
end
```

用法：

```ruby
download_all(record.attachments) do |files|
  pp files
end
```
