set :site_name, '不歸錄'
set :site_url, 'http://tonytonyjan.net'
set :blog_description, '大兜的個人部落格，本名簡煒航，網路代號 tonytonyjan。內容包括程式設計、音樂創作與生活雜記。'.freeze

set :markdown_engine, :kramdown
set :markdown, input: :GFM
set :time_zone, 'Taipei'

activate :livereload
activate :i18n, langs: %i[zh-TW en]
activate :blog do |blog|
  blog.layout   = 'blog'
  blog.sources  = 'posts/{year}-{month}-{day}-{title}.html'
  blog.paginate = true
  blog.summary_separator  = /<!-- more -->/
  blog.summary_length     = 150
  blog.tag_template       = 'tag.html'
  blog.custom_collections = {
    category: {
      link: '/categories/{category}.html',
      template: 'category.html'
    }
  }
end
activate :directory_indexes
activate :deploy do |deploy|
  deploy.method = :rsync
  deploy.clean = true
  deploy.user            = 'deploy'
  deploy.host            = '128.199.147.210'
  deploy.port            = 22
  deploy.path            = '/var/www/tonytonyjan.net'
  # deploy.build_before    = true
end

page 'feed.xml', layout: false
page 'google7bd685dfb8300eb0.html', directory_index: false
page '404.html', directory_index: false

ignore 'slides/*'
after_build do
  `cp -R source/slides build`
end
