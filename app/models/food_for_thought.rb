# == Schema Information
#
# Table name: food_for_thoughts
#
#  id              :uuid             not null, primary key
#  sponsored       :boolean          default(FALSE), not null
#  sponsored_by    :string
#  sponsored_utm   :string
#  summary         :string           not null
#  title           :string           not null
#  url             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  event_id        :uuid
#  organization_id :uuid
#
# Indexes
#
#  index_food_for_thoughts_on_event_id         (event_id)
#  index_food_for_thoughts_on_organization_id  (organization_id)
#  index_food_for_thoughts_on_sponsored        (sponsored)
#  index_food_for_thoughts_on_sponsored_by     (sponsored_by)
#

class FoodForThought < ApplicationRecord
  validates :title,   presence: true
  validates :summary, presence: true
  validates :url,     url: { allow_blank: true, enforce_https: true }

  validate :validate_url_and_article_presence

  has_rich_text :article

  before_validation :generate_summary, if: :article_changed?

  # Select a random set of articles based on provided criteria and sponsor ratio
  #
  # @param organization_id [String, nil] The organization ID to filter articles (default: nil)
  # @param event_id [String, nil] The event ID to filter articles (default: nil)
  # @param sponsor_ratio [Float] The ratio of sponsored articles to total articles (default: 0)
  #                            Value must be between 0.0 and 1.0
  # @return [Array<FoodForThought>] The randomly selected articles
  def self.random_selection(organization_id = nil, event_id = nil, sponsor_ratio = 0.0)
    raise ArgumentError, 'sponsor_ratio must be between 0.0 and 1.0' unless (0.0..1.0).cover?(sponsor_ratio)

    raise ArgumentError, 'organization_id and event_id cannot both be present' if organization_id.present? && event_id.present?

    articles = if event_id.present?
                 where(event_id: event_id)
               elsif organization_id.present?
                 where(organization_id: organization_id)
               else
                 where(organization_id: nil, event_id: nil)
               end

    total_articles = articles.count
    sponsored_count = (sponsor_ratio * 10).to_i
    random_count = 10 - sponsored_count

    # Handle cases where sponsored or non-sponsored articles are insufficient
    if sponsored_count > total_articles
      # If the sponsored count exceeds total articles, select all sponsored articles
      sponsored_articles = articles.where(sponsored: true)
      random_articles = articles.where(sponsored: false).order(Arel.sql('RANDOM()')).limit(random_count)
    elsif random_count > total_articles - sponsored_count
      # If the random count exceeds the available non-sponsored articles, select all non-sponsored articles
      sponsored_articles = articles.where(sponsored: true).order(Arel.sql('RANDOM()')).limit(sponsored_count)
      random_articles = articles.where(sponsored: false)
    else
      # Select the specified number of sponsored and non-sponsored articles randomly
      sponsored_articles = articles.where(sponsored: true).order(Arel.sql('RANDOM()')).limit(sponsored_count)
      random_articles = articles.where(sponsored: false).order(Arel.sql('RANDOM()')).limit(random_count)
    end

    all_articles = sponsored_articles + random_articles
    all_articles.shuffle
  end

  private

  # Validate that only one of URL or article is present
  def validate_url_and_article_presence
    if url.present? && article.present?
      errors.add(:base, 'URL and article cannot both be present')
    end
  end

  # Generate a summary from the article or extract a summary from the URL
  def generate_summary
    if article.present?
      self.summary = article.to_plain_text.truncate(100)
    elsif url.present?
      # Extract summary from URL logic goes here
      # Replace the following line with the code to extract the summary from the URL
      self.summary = 'Summary extracted from URL'
    end
  end
end
