Time.zone = 'Asia/Taipei'
activate :i18n, mount_at_root: :'zh-TW'
activate :blog do |blog|
  blog.layout  = 'blog'
  blog.sources = 'posts/{year}-{month}-{day}-{title}.html'
end
