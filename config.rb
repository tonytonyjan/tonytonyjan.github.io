set :site_url, 'http://tonytonyjan.net'
set :site_author, '大兜, 簡煒航, tonytonyjan, Jian Weihang'

set :markdown_engine, :kramdown
set :markdown, input: :GFM, parse_block_html: true
set :time_zone, 'Taipei'

page 'feed.xml', layout: false
page "google7bd685dfb8300eb0.html", directory_index: false

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
  deploy.method       = :git
  deploy.branch       = :master
  deploy.build_before = true
end

helpers do
  def condense str
    str.gsub(/[\s\n]+/, ' ') if str
  end

  def site_title
    "#{current_article.title} - 不歸錄" if current_article
  end

  def site_description
    current_page.data.description || condense(strip_tags(current_article.try(:summary))) || I18n.t('site.description')
  end
end