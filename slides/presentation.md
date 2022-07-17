#!/usr/bin/env slides

# Ruby the Command

Ruby the command

---

## Running Ruby Script: `ruby FILE`

```sh
echo 'puts "hello"' > main.rb
ruby main.rb
```

### Output

```
hello
```

---

## Running Ruby Script: `ruby < FILE`

```sh
echo 'puts "hello"' > main.rb
ruby < main.rb
```

### Output

```
hello
```

---

## Running Ruby Script: `cat FILE | ruby`

```sh
echo 'puts "hello"' > main.rb
cat main.rb | ruby
```

### Output

```
hello
```

---

## Running Ruby Script: `ruby -e SCRIPT`

```sh
ruby -e '3.times { pust "hello" }'
```

### Output

```
hello
hello
hello
```

---

### Example `date`

```sh
date
```

### Output

```
Wed Jun 29 11:35:15 CST 2022
```

---

### Example `date`

```sh
ruby -e 'puts Time.now'
```

### Output

```
2022-06-29 11:35:57 +0800
```

---

### Example `date`

```sh
ruby -e 'puts Time.now.to_i'
```

### Output

```
1656473987
```

---

### Example `date`

```sh
ruby -e 'puts Time.now.strftime("%FT%T%:z")'
```

### Output

```
2022-06-29T11:39:12+08:00
```

---

## Use `ARGV` to Read Arguments

```sh
ruby -e 'p ARGV' foo bar buz
```

### Output

```
["foo", "bar", "buz"]
```

---

### Example `echo`

```sh
echo hello world
```

### Output

```
hello world
```

---

### Example `echo`

```sh
ruby -e 'puts ARGV.join(" ")' hello world
```

### Output

```
hello world
```

---

### Example `seq`

```sh
seq 3
```

### Output

```
1
2
3
```

---

### Example `seq`

```sh
ruby -e \
  'ARGV.first.to_i.times{ puts _1 + 1 }' 3
```

### Output

```
1
2
3
```

---

## Use `$stdin` to Read Input Stream

```sh
echo 'hello world' | ruby -e 'p $stdin.read'
```

### Output

```
"hello world\n"
```

---

## Example `tr`

```sh
echo 'hello world' | tr o 0
```

### Output

```
hell0 w0rld
```

---

## Example `tr`

```sh
echo 'hello world' |
  ruby -e 'puts $stdin.read.tr(*ARGV)' o 0
```

### Output

```
hell0 w0rld
```

---

## Example `tr`

```sh
echo 'hello world' |
  ruby -e 'puts $stdin.read.gsub(*ARGV)' o 0
```

### Output

```
hell0 w0rld
```

---

## Example `cat`

```sh
echo 'hello world' > input.txt
cat input.txt
```

### Output

```
hello world
```

---

## Example `cat`

```sh
echo 'hello world' | cat
```

### Output

```
hello world
```

---

## Example `cat`

```sh
echo 'hello world' > input.txt
ruby -e 'print File.read(ARGV.first)' input.txt
```

### Output

```
hello world
```

---

## Example `cat`

```sh
echo 'hello world' |
  ruby -e 'print $stdin.read'
```

### Output

```
hello world
```

---

## Example `cat`

```sh
echo 'hello world' |
  ruby -e 'IO.copy_stream $stdin, $stdout'
```

### Output

```
hello world
```

---

## Use `ARGF` to Read either Input Stream or Files

> ARGF is a stream designed for use in scripts that process files given ascommand-line arguments or passed in via STDIN.

---

## Use `ARGF` to Read either Input Stream or Files

```sh
echo hello > 1.txt
echo world > 2.txt
ruby -e 'print ARGF.read' 1.txt 2.txt
```

### Output

```
hello
world
```

---

## Use `ARGF` to Read either Input Stream or Files

```sh
echo 'hello
world' |
  ruby -e 'print ARGF.read'
```

### Output

```
hello
world
```

---

## Example `cat`

```sh
echo 'hello world' |
  ruby -e 'print ARGF.read'
```

### Output

```
hello world
```

---

## Example `cat`

```sh
echo 'hello world' |
  ruby -e 'IO.copy_stream ARGF, $stdout'
```

### Output

```
hello world
```

---

# Recapitulation

1. `ruby -e` - execute Ruby script inline
2. `$stdin` - read standard input stream
3. `ARGV` - read command arguments
4. `ARGF` - read input stream or files

---

# Recapitulation

1. `date`
2. `echo`
3. `seq`
4. `tr`
5. `cat`

---

## Use `ruby -n` to Iterate Line by Line

> assume `while gets; ... end` loop around your script

---

## Use `ruby -n` to Iterate Line by Line

```sh
seq 3 |
  ruby -e 'while x = gets; p x end'
```

### Output

```
"1\n"
"2\n"
"3\n"
```

---

## Use `ruby -n` to Iterate Line by Line

```sh
seq 3 |
  ruby -e 'while gets; p $_ end'
```

### Output

```
"1\n"
"2\n"
"3\n"
```

---

## Use `ruby -n` to Iterate Line by Line

```sh
seq 3 |
  ruby -ne 'p $_'
```

### Output

```
"1\n"
"2\n"
"3\n"
```

---

## Example `grep`

```sh
seq 30 |
  grep 3
```

### Output

```
3
13
23
30
```

---

## Example `grep`

```sh
seq 30 |
  ruby -ne 'puts $_ if $_.match? /3/'
```

### Output

```
3
13
23
30
```

---

## Use `ruby -p`

> assume loop like `-n` but print line also like `sed`

### How `sed` Work

1. Copy the next line to the buffer.
2. Applies all commands to the buffer.
3. Print the buffer to standard output.
4. Go to step 1.

`ruby -p` does step 3 automatically.

---

## Use `ruby -p`

```sh
seq 30 |
  ruby -ne 'puts $_ if $_.match? /3/'
```

### Output

```
3
13
23
30
```

---

## Use `ruby -p`

```sh
seq 30 |
  ruby -pe 'next unless $_.match? /3/'
```

### Output

```
3
13
23
30
```

---

## Example `grep`

```sh
echo '# http connection timeout in seconds
TIMEOUT=3600
API_ENDPOINT=https://example.org

# used for cache
REDIS=redis://example.org/redis' >.env

grep -v -e '^$' -e '^#' .env
```

### Output

```
TIMEOUT=3600
API_ENDPOINT=https://example.org
REDIS=redis://example.org/redis
```

---

## Example `grep`

```sh
echo '# http connection timeout in seconds
TIMEOUT=3600
API_ENDPOINT=https://example.org

# used for cache
REDIS=redis://example.org/redis' >.env

ruby -pe 'next if $_.match? /^#|^$/' .env
```

### Output

```
TIMEOUT=3600
API_ENDPOINT=https://example.org
REDIS=redis://example.org/redis
```

---

## Why not Just Use `grep`?

---

## Why not Just Use `grep`?

### Because of Love

We love Ruby

---

## Why not Just Use `grep`?

### It's hard to rememebr flags of `grep`

`-E`, `-P`, `-v`, etc

---

## Why not Just Use `grep`?

### There are many implementations of `grep`

GNU `grep` vs BSD `grep`

---

## Why not Just Use `grep`?

### IEEE Std 1003.2 (POSIX.2) leaves some aspects of RE syntax and semantics open

Run `man re_format` to see more details.

---

## Why not Just Use `grep`?

### There are many REs

1.  PCRE (`grep -P`; GNU only)
1.  Basic Regular Expression (BRE; `grep`)
1.  Extended Regular Expression (ERE; `grep -E`)
1.  Enhanced BRE/ERE

---

## Example `sed s///g`

```sh
echo 'hello world' |
  sed s/world/work/g
```

### Output

```
hello work
```

---

## Example `sed s///g`

```sh
echo 'hello world' |
  ruby -pe '$_.gsub!("world", "work")'
```

### Output

```
hello work
```

---

## Example `sed s///g`

```sh
echo 'hello world' |
  ruby -pe 'gsub("world","work")'
```

### Output

```
hello work
```

---

## `Kernel#gsub`

> Equivalent to `$_.gsub...`, except that $_ will be updated if substitution occurs. Available only when `-p/-n` command line option specified.

---

## `-p/-n` Family

- `Kernel#gsub`
- `Kernel#sub`
- `Kernel#chomp`

---

## Example `sed s///g`

```sh
echo 'https://user@example.org/path?query' |
  ruby -ruri -pe 'gsub(URI.regexp, "\\4")'
```

### Output

```
example.org
```

---

## Example `sed d`

```sh
seq 10 |
  sed '1,5d'
```

### Output

```
6
7
8
9
10
```

---

## Example `sed d`

```sh
seq 10 |
  ruby -pe 'next if $. < 6'
```

### Output

```
6
7
8
9
10
```

---

## Why not Just Use `sed`?

---

## Why not Just Use `sed`?

### Because of Love

We love Ruby

---

## Why not Just Use `sed`?

### There are many implementations of `sed`

GNU `sed` vs BSD `sed`

---

## Why not Just Use `sed`?

### `sed -E` is not POSIX compatible

It supports only BRE instead of ERE syntax, which means we can't use `?`, `+`, `|`, etc.

---

## Use `ruby -a` to Split Line into Fields

> autosplit mode with `-n` or `-p` (splits `$_` into `$F`)

---

## Use `ruby -a` to Split Line into Fields

```sh
seq 9 | xargs -n3 |
  ruby -ane 'p $F'
```

### Output

```
["1", "2", "3"]
["4", "5", "6"]
["7", "8", "9"]
```

### How

```ruby
"1 2 3\n".split # => ["1", "2", "3"]
"4 5 6\n".split # => ["1", "2", "3"]
"7 8 9\n".split # => ["1", "2", "3"]
```

---

## Use `ruby -a` to Split Line into Fields

```sh
seq 9 | xargs -n3 | tr ' ' '\t' |
  ruby -ane 'p $F'
```

### Output

```
["1", "2", "3"]
["4", "5", "6"]
["7", "8", "9"]
```

### How

```ruby
"1\t2\t3\n".split # => ["1", "2", "3"]
"4\t5\t6\n".split # => ["1", "2", "3"]
"7\t8\t9\n".split # => ["1", "2", "3"]
```

---

## Example `awk`

```sh
seq 9 | xargs -n3 |
  awk '{print $1 + $2 + $3}'
```

### Output

```
6
15
24
```

---

## Example `awk`

```sh
seq 9 | xargs -n3 |
  ruby -ane 'puts $F.map(&:to_i).sum'
```

### Output

```
6
15
24
```

---

## Use `ruby -F PATTERN`

> split() pattern for autosplit (-a)

---

## Use `ruby -F PATTERN`

```sh
seq 9 | xargs -n3 | tr ' ' , |
  ruby -F, -ane 'p $F'
```

### Output

```
["1", "2", "3\n"]
["4", "5", "6\n"]
["7", "8", "9\n"]
```

### How

```ruby
"1,2,3\n".split(',') # => ["1", "2", "3\n"]
"4,5,6\n".split(',') # => ["1", "2", "3\n"]
"7,8,9\n".split(',') # => ["1", "2", "3\n"]
```

---

## Use `ruby -l`

> enable line ending processing

---

## Use `ruby -l`

```sh
echo 'hello
world' |
  ruby -ne 'p $_'
```

### Output

```
"hello\n"
"world\n"
```

---

## Use `ruby -l`

```sh
echo 'hello
world' |
  ruby -nle 'p $_'
```

### Output

```
"hello"
"world"
```

---

## Combine `ruby -F` and `ruby -l`

```sh
seq 9 | xargs -n3 | tr ' ' , |
  ruby -aF, -ne 'p $F'
```

### Output

```
["1", "2", "3\n"]
["4", "5", "6\n"]
["7", "8", "9\n"]
```

---

## Combine `ruby -F` and `ruby -l`

```sh
seq 9 | xargs -n3 | tr ' ' , |
  ruby -aF, -nle 'p $F'
```

### Output

```
["1", "2", "3"]
["4", "5", "6"]
["7", "8", "9"]
```

---

## Example `awk`

```sh
seq 9 | xargs -n3 | tr ' ' , |
  awk -F, '{print $1 + $2 + $3}'
```

### Output

```
6
15
24
```

---

## Example `awk`

```sh
seq 9 | xargs -n3 | tr ' ' , |
  ruby -aF, -nle 'puts $F.map(&:to_i).sum'
```

### Output

```
6
15
24
```

---

# Recapitulation

1. `ruby -n` - `while gets(); ... end`
2. `ruby -p` - `while gets(); ... puts($_) end`
3. `ruby -a` - splits `$_` into `$F`
4. `ruby -Fpattern` - split pattern for `-a`
5. `ruby -l` - chops every line read by `$_.chomp!`

### Mnemonic

1. `ruby -lane command`
2. `ruby -pale command`

---

# Recapitulation

1. `grep`
2. `sed`
3. `awk`

---

## Use `BEGIN` and `END`

> BEGIN defines a block that is run before any other code in the current file.

> END defines a block that is run after any other code.

---

## Use `BEGIN` and `END`

```sh
ruby -e 'BEGIN{puts("begin")}
END{puts("end")}
puts("hello world")'
```

### Output

```
begin
hello world
end
```

---

## Use `BEGIN` and `END`

```sh
seq 100 |
  ruby -lane 'BEGIN{sum=0}
sum+=$_.to_i
END{puts sum}'
```

### Output

```
5050
```

---

## Example `awk`

```sh
echo 'month revenue
Feb   180
Mar   178
Apr   160' |
  awk 'BEGIN{sum=0}
NR>1 { sum+=$2 }
END {print sum}'
```

### Output

```
518
```

---

## Example `awk`

```sh
echo 'month revenue
Feb   180
Mar   178
Apr   160' |
  ruby -lane 'BEGIN{sum=0}
sum+=$F[1].to_i if $. > 1
END{puts sum}'
```

### Output

```
518
```

---

## Shebang `#!`

> When a text file with a shebang is used as if it is an executable in a Unix-like operating system, the program loader mechanism parses the rest of the file's initial line as an interpreter directive.

> The loader executes the specified interpreter program, passing to it as an argument using the path that was initially used when attempting to run the script, so that the program may use the file as input data.

---

## Shebang `#!`

```sh
echo '#!/bin/sh
date
' >now
chmod +x now

./now
```

### Output

```
Fri Jul  1 15:17:45 CST 2022
```

---

## Shebang `#!`

```sh
echo '#!/usr/local/opt/ruby/bin/ruby
x = ARGV[0].to_i
y = ARGV[1].to_i
puts x + y
' >sum
chmod +x sum

./sum 8 9
```

### Output

```
2
```

---

## Shebang `#!`

```sh
echo '#!/usr/bin/env ruby
x = ARGV[0].to_i
y = ARGV[1].to_i
puts x + y
' >sum
chmod +x sum

./sum 8 9
```

### Output

```
2
```

---

## Shebang `#!`

```sh
echo '#!/usr/bin/env ruby
require "csv"
require "json"
puts JSON.dump(
  CSV.new(ARGF, headers: true).to_a.map!(&:to_h)
)' >csv_to_json
chmod +x csv_to_json
```

---

## Shebang `#!`

```sh
echo 'name,age
tony,18
tom,15' | ./csv_to_json
```

### Output

```
[
  {"name":"tony","age":"18"},
  {"name":"tom","age":"15"}
]
```

---

## Thank you

### Download Slides

```sh
brew install slides
curl https://tonytonyjan.net/slides/2022-07-30-ruby-the-command/presentation.md > presentation.md
chmod +x presentation.md
./presentation.md
```

---

## Q&A
