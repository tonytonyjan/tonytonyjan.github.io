set :site_url, 'http://tonytonyjan.net'

set :markdown_engine, :kramdown
set :markdown, input: :GFM
set :time_zone, 'Taipei'


activate :i18n, mount_at_root: :'zh-TW'
activate :blog do |blog|
  blog.layout   = 'blog'
  blog.sources  = 'posts/{year}-{month}-{day}-{title}.html'
  blog.paginate = true
  blog.summary_separator = /<!-- more -->/
  blog.summary_length    = 150
end
activate :directory_indexes

helpers do
 def condense str
  str.gsub(/[\s\n]+/, ' ') if str
 end
end