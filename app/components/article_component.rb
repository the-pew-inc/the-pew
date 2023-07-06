# app/components/article_component.rb
# frozen_string_literal: true

class ArticleComponent < ViewComponent::Base
  with_collection_parameter :article

  def initialize(article)
    @article = article
  end

  def url_options
    { target: '_blank' }
  end

  def title
    @article.title
  end

  def summary
    @article.summary
  end

  def link
    @article.url
  end
end
