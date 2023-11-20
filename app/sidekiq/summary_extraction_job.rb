# app/sidekiq/summary_extraction_job.rb
require 'open-uri'
require 'uri'
require 'nokogiri'

class SummaryExtractionJob
  include Sidekiq::Job

  def perform(url, food_for_thought_id)
    food_for_thought = FoodForThought.find(food_for_thought_id)
    summary = extract_summary_from_url(url)
    food_for_thought.update(summary:)
  end

  private

  def extract_summary_from_url(url)
    # Parse the URL and open it safely
    doc = URI.parse(url).open { |response| Nokogiri::HTML(response) }

    # Extract meta description
    meta_summary = doc.at('meta[name="description"]')&.[]('content')
    return meta_summary if meta_summary.present?

    # Extract article summary (assuming extract_article_summary is defined elsewhere)
    article_summary = extract_article_summary(doc)
    return article_summary if article_summary.present?

    # Default return value if no summary is found
    'No summary available'
  rescue URI::InvalidURIError => e
    Rails.logger.error("Invalid URL: #{e.message}")
    'Invalid URL'
  rescue OpenURI::HTTPError => e
    Rails.logger.error("HTTP Error: #{e.message}")
    'Error fetching URL'
  rescue StandardError => e
    Rails.logger.error("General Error: #{e.message}")
    'An error occurred'
  end

  def extract_article_summary(doc)
    # Example: Extracting the first paragraph or div containing text
    relevant_elements = doc.css('p, div').select { |element| element.text.present? }
    summary = relevant_elements.first&.text
    summary.truncate(100) if summary.present?
  end
end
