# frozen_string_literal: true
module CustomHelpers
  def page_image
    config[:site_url] + image_path(current_page.data.image || 'site/avatar_big.png')
  end

  def condense(str)
    str.gsub(/[\s\n]+/, ' ') if str
  end

  def article_title
    "#{current_article.title} - #{config[:site_name]}"
  end

  def article_description
    current_article.data.description || condense(strip_tags(current_article.summary))
  end

  def article_thumb_path(article)
    if article.data.thumb
      article.data.thumb
    elsif article.data.image && File.exist?(File.join(source_dir, "images/thumbs/#{article.data.image}"))
      "thumbs/#{article.data.image}"
    else
      "thumbs/兜-1.png"
    end
  end
end
