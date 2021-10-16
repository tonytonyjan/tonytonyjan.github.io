---
title: 你不需要 dotenv
date: 2021-10-16 12:58 +0800
tags: [env, xargs, tr, grep, dotenv]
image: /images/no-dotenv.jpg
thumb: /images/thumbs/no-dotenv.jpg
---

![TJDict](/images/no-dotenv.jpg)

還記得筆者第一次看到 `dotenv` 的時候覺得這是哪個幽默的工程師寫的笑話用以嘲笑外行人，後來發現不對，這東西是認真的，而且有很多人在用這套工具。百思不得其解，就像幾年前看到 [`left-pad`][left_pad] 一樣，明明實作不過 11 行，人們卻寧願仰賴第三方套件，也不願自己寫，好奇我們在開源軟體蓬勃發展之下，是否漸漸忘記怎麼用電腦。

<!-- more -->

## 情境

假設我們有一個 `.env` 檔案，裡面存放 `key=value` 這樣的資訊，而目的是在執行某個程序時，能夠將檔案中的內容載入環境變數，例如：

```
$ cat .env
FOO=1
BAR=2
```

## 解法

筆者用以下方法已經很多年了：

```sh
env $(cat .env) ruby -e 'pp ENV'
```

但是不少人卻覺得這樣做比較酷：

**Ruby**

```ruby
require 'dotenv'
Dotenv.load
pp ENV
```

**Node.js**

```js
require("dotenv").config();
console.log(process.env);
```

廢到笑。

即便不具備 UN\*X 的基本學識，但只要懂一點程式語言，起碼還能用語言本身的功能做到一樣的事，例如：

**Ruby**

```ruby
# myenv.rb
ENV.merge!({ 'FOO' => '1', 'BAR' => '2' })
```

```ruby
require 'myenv'
pp ENV
```

**Node.js**

```js
// myenv.js
process.env.FOO = "1";
process.env.BAR = "2";
```

```js
require("myenv");
console.log(process.env);
```

其實這個做法在 `.bashrc` 很常見，有人會習慣在裡面放 `export KEY=VALUE`，習慣再好一點的人會把環境變數分成別的檔案，並用 `source .env.sh` 的方式來載入它們：

```sh
# env.sh
export FOO=1
export BAR=2
```

```sh
source env.sh
echo $FOO $BAR
```

這其實跟上述 `env.rb` 和 `env.js` 是一樣的道理，都是載入外部的檔案以設定環境變數。此外大多情況我們會用 POSIX 兼容的 shell 來完成日常的工作，這時再做一個能 cross shell 的 `.env.sh` 是沒有必要的（例如支援 fish）。我們也不會為了設定 `bash` 或 `fish` 的環境變數，特別去尋找支援該 shell 的 `dotenv` 套件，那顯得十分多餘。

但是這個方法好像從 shell 語言換到其他程式語言後，工程師的大腦就會跟著突然被格式化。認為自己設定環境變數的風險太高，如果不趕快找一個第三方的環境變數載入器，自己將無法完成這個任務；使用套件後除得到內心的平靜，還能在其他新手間宣示自己使用了成熟的套件，藉以獲得他人尊敬，一舉數得。

黑人問號。

## 進階解法

再複習一次原本的做法：

```sh
env $(cat .env) ruby -e 'pp ENV'
```

雖然這已能應付大多狀況，但無法處理環境變數中的空格及註解，例如：

```
FOO=hello world

＃ comment
```

我們能用 `tr` 和 `xargs` 處理空格（此處為 BSD xargs 而非 GNU xargs）：

```sh
cat .env |
  tr '\n' '\000' |
  xargs -0 -J@ env @ ruby -e 'pp ENV'
```

並用 `grep` 處理註解：

```sh
grep -v '^ *#' .env |
  tr '\n' '\000' |
  xargs -0 -J@ env @ ruby -e 'pp ENV'
```

接著把這段指令寫在 alias 或是 function：

```sh
alias xenv="grep -v '^ *#' | tr '\n' '\000' | xargs -0 -J@ env @"
```

```sh
xenv() {
  grep -v '^ *#' | tr '\n' '\000' | xargs -0 -J@ env @ "$@"
}
```

之後便能更方便地使用：

```sh
cat .env1 .env2 .env3 | xenv ruby -e 'pp ENV'
```

## 與 `dotenv` 之間的差異

相較下筆者的做法較單純，其中最關鍵的差異是處理 `value` 的方式為所見即所得。既沒有保留字元（除了換行），也不像 `dotenv` 有 inner/outer/single/double quotes 的概念，更不會有出乎預期的行為（例如 `dotenv` 會偷刪空格，沒仔細看 README 也許不會知道，更別說 `dotenv` 還有一堆 quoting 相關的規則）。

因為所見即所得，意即不用擔心意外用到任何跳脫字元：

```
$ cat .env
FOO= ~!@#$%^&*()_+"'\
```

```
$ cat .env | xenv ruby -e 'puts ENV["FOO"]'
 ~!@#$%^&*()_+"'\
```

目前看來表現得還不錯，但難免還是會好奇目前的實作和 `dotenv` 之間的差距，於是筆者把 `dotenv` 官方的 [README][dotenv_readme] 拿出參考：

1. [x] `BASIC=basic` becomes `{BASIC: 'basic'}`
2. [x] empty lines are skipped
3. [x] lines beginning with `#` are treated as comments
4. [x] empty values become empty strings (`EMPTY=` becomes `{EMPTY: ''}`)
5. [x] inner quotes are maintained (think JSON) (`JSON={"foo": "bar"}` becomes `{JSON:"{\"foo\": \"bar\"}"`)
6. [ ] whitespace is removed from both ends of unquoted values (`FOO= some value ` becomes `{FOO: 'some value'}`)
7. [ ] single and double quoted values are escaped (`SINGLE_QUOTE='quoted'` becomes `{SINGLE_QUOTE: "quoted"}`)
8. [ ] single and double quoted values maintain whitespace from both ends (`FOO=" some value "` becomes `{FOO: ' some value '}`)
9. [ ] double quoted values expand new lines

大概一半以上的功能都達到了，其中 6 筆者不認為是好設計，而 7 和 8 則是多餘的規則。總結來說只要沒有 `LF` 換行字元，所有 `dotenv` 能做到的事情，筆者的方法都能做到。

## 關於 `LF` 換行字元

筆者的方法在 `value` 的部分無法有換行字元，唯一的權變措施是將 `value` 進行 `JSON` 或是 `Base64` 編碼，並在軟體中解碼，但筆者不建議這樣做。

不如說有這種需求下，筆者建議放棄 `.env` 的格式，有兩個理由。

第一個理由是因為設定檔的存在是在工程師不更動原始碼的情況下，能夠透過修改這份檔案以在短時間內調整軟體的設定，亦即這樣的檔案理想上必須要能易讀、易改，不會出現大量像是 `\n` 等的跳脫字元。

既然設定檔必須是人本設計，那硬生生在 `key=value` 的格式上加上 `\n` 的符號反而與設定檔的初衷背道而馳。取而代之使用 `YAML` 或是 `TOML` 會比起 `.env` 更為適合，試比較以下 3 種格式的可讀性：

**dotenv**

```
FOO="hello\nworld"
```

**YAML**

```yml
FOO: |
  hello
  world
```

**TOML**

```toml
lines = '''
hello
world
'''
```

第二個反對的理由是 `.env` 的檔案格式並不存在標準，[POSIX 僅對環境變數定義了 `key=value` 的格式][posix]，並沒有提到將環境變數寫檔案中應該怎麼呈現，且每個語言的實作皆有所差異，能在 Node.js 的 `dotenv` 執行的 `.env` 未必能在 Ruby 的 `dotenv` 中執行。

另一方面 [`YAML`][yaml_spec] 或 [`TOML`][toml_spec] 都有詳細的規格書，很多程式語言都有支援這些格式，所以實作起來也相當容易，例如使用 Ruby 載入 `env.yml` 中的環境變數：

```sh
alias yenv="ruby -ryaml -e 'exec(YAML.load(STDIN.read), *ARGV)'"
```

為避免混淆，這裡用 `node`（而非 `ruby`）把環境變數 `FOO` 印出來：

```
$ cat env.yml | yenv node -e 'console.log(process.env.FOO)'
hello
world
```

## 簡單就是讚（Simple is Good）

最後再複習一次：

```sh
env $(cat .env) [COMMAND [ARGS ...]]
```

先不防看看自己專案下的 `.env` 有沒有註解、空格、空行？沒有的話 `env` 和 `cat` 就能解決你的問題，有的話再加上 `grep`、`tr` 和 `xargs`。如果有更花式的需求，那也許 `sed` 和 `awk` 也可以幫上忙。不要懼怕這些工具，它們全都符合 [Unix 哲學][unix_philosophy]，只要你想，便能組合出各種可能性。

至於想在設定檔中支援特殊字元或換行，是時候考慮用成熟的格式標準了，例如 YAML、JSON、TOML 等，透過自己熟悉的程式語言與成熟的格式標準變能輕易做到。

你的 `.env` 應該越簡單越好，沒有跳脫字元、沒有換行、就只有 `key=value`；當你需要更進階的設定，考慮更多的 UN\*X 工具；當你不熟悉 UN\*X 工具，可以比照像是 `.bashrc` 的設定習慣以自己熟悉的程式語言實現；當你發現你幾乎要發明自己的 `.env` 格式了，不妨考慮用更成熟的標準配合自己熟悉的程式語言實作它。

最後就會發現，你真的不需要 `dotenv`。

## 參考

1. https://man7.org/linux/man-pages/man1/xargs.1.html
2. https://www.freebsd.org/cgi/man.cgi?xargs
3. https://github.com/freebsd/freebsd-src/blob/0c1a5ea/usr.bin/env/env.c#L192-L200
4. https://github.com/coreutils/coreutils/blob/3753c70/src/env.c#L839-L851

[posix]: https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap08.html
[unix_philosophy]: https://en.wikipedia.org/wiki/Unix_philosophy
[left_pad]: https://qz.com/646467/how-one-programmer-broke-the-internet-by-deleting-a-tiny-piece-of-code/
[dotenv_readme]: https://github.com/motdotla/dotenv/blob/27dfd3f/README.md#rules
[toml_spec]: https://toml.io/en/v1.0.0
[yaml_spec]: https://yaml.org/spec/
