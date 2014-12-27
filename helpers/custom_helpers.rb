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
end