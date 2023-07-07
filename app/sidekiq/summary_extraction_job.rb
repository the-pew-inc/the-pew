# app/sidekiq/summary_extraction_job.rb
require 'open-uri'
require 'nokogiri'

class SummaryExtractionJob
  include Sidekiq::Job

  def perform(url, food_for_thought_id)
    food_for_thought = FoodForThought.find(food_for_thought_id)
    summary = extract_summary_from_url(url)
    food_for_thought.update(summary: summary)
  end

  private

  def extract_summary_from_url(url)
    doc = Nokogiri::HTML(URI.open(url))
    meta_summary = doc.at('meta[name="description"]')&.[]('content')
    return meta_summary if meta_summary.present?

    article_summary = extract_article_summary(doc)
    return article_summary if article_summary.present?

    # If no summary is found, you can provide a default value or return nil
    return 'No summary available'
  end

  def extract_article_summary(doc)
    # Example: Extracting the first paragraph or div containing text
    relevant_elements = doc.css('p, div').select { |element| element.text.present? }
    summary = relevant_elements.first&.text
    summary.truncate(100) if summary.present?
  end
end
