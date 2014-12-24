set :site_url, 'http://tonytonyjan.net'

Time.zone = 'Asia/Taipei'
set :markdown_engine, :kramdown
set :markdown, input: :GFM
activate :i18n, mount_at_root: :'zh-TW'
activate :blog do |blog|
  blog.layout   = 'blog'
  blog.sources  = 'posts/{year}-{month}-{day}-{title}.html'
  blog.paginate = true
  blog.per_page = 10
  blog.summary_separator = /<!-- more -->/
end
activate :directory_indexes
