module CustomHelpers
  def condense str
    str.gsub(/[\s\n]+/, ' ') if str
  end

  def article_title
    "#{current_article.title} - #{site_name}"
  end

  def article_description
    current_article.data.description || condense(strip_tags(current_article.summary))
  end

  def article_thumb_path article
    return article.data.thumb if article.data.thumb

    default_thumb_path = "thumbs/#{article.data.image}"
    return default_thumb_path if File.exist?(File.join(source_dir, "images/#{default_thumb_path}"))

    return "thumbs/兜-1.png"
  end
end