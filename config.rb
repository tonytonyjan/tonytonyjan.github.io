activate :blog do |blog|
  blog.layout  = 'blog'
  blog.sources = 'posts/{year}-{month}-{day}-{title}.html'
end
