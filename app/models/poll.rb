# == Schema Information
#
# Table name: polls
#
#  id              :uuid             not null, primary key
#  add_option      :boolean          default(TRUE), not null
#  duration        :integer
#  max_answers     :integer
#  max_votes       :integer
#  num_answers     :integer
#  num_votes       :integer
#  participants    :integer          default(0), not null
#  poll_type       :integer          not null
#  selectors       :string           default(["\"upvote\"", "\"downvote\"", "\"neutral\""]), is an Array
#  status          :integer          not null
#  title           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#  user_id         :uuid             not null
#
# Indexes
#
#  index_polls_on_organization_id  (organization_id)
#  index_polls_on_poll_type        (poll_type)
#  index_polls_on_selectors        (selectors)
#  index_polls_on_status           (status)
#  index_polls_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (user_id => users.id)
#
class Poll < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  # Callbacks
  before_validation :convert_zero_to_nil

  # Tracking changes
  has_paper_trail

  # Relationships
  has_many :poll_options, dependent: :destroy
  accepts_nested_attributes_for :poll_options, allow_destroy: true
  
  has_many :poll_answers, dependent: :destroy

  has_rich_text :description

  validates :title, presence: true, length: { minimum: 3, maximum: 250 }
  validate :validate_poll_options

  # :num_answers and :max_answers validation rules
  validates :num_answers, :max_answers, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validate :num_answers_less_than_or_equal_to_poll_options_count
  validate :num_and_max_answers_exclusive
  validate :max_answers_less_than_or_equal_to_poll_options_count

  # Universal: everyone can see participate to the poll
  # Restricted: participating to the poll requires an account
  # Invite_only: participating to the poll requires an invitation
  enum poll_type: { universal: 10, restricted: 20, invite_only: 30 }, _default: 10

  enum status:  { opened: 10, closed: 20 }, _default: 10

  # Define how the poll options are ordered when displayed to the user
  enum display: { random: 10, up_vote: 20, down_vote: 30 }, _default: 10

  # Used to update the participants column
  # A poll participant is a person who casted their vote for a poll
  # A vote is :up_vote (+1), :down_vote (-1), :cancel (0)
  def update_participants
    participants = Vote.where(votable_id: self.poll_options.pluck(:id)).select(:user_id).distinct.count || 0
    self.update(participants: participants)
  end

  private

  def validate_poll_options
    if poll_options.size < 2
      errors.add(:poll_options, "must have at least two options")
    end
  end

  def num_answers_less_than_or_equal_to_poll_options_count
    if num_answers.present? && num_answers > poll_options.count
      errors.add(:num_answers, "cannot be greater than the number of poll options")
    end
  end

  def max_answers_less_than_or_equal_to_poll_options_count
    if max_answers.present? && max_answers > poll_options.count
      errors.add(:max_answers, "cannot be greater than the number of poll options")
    end
  end

  def num_and_max_answers_exclusive
    if num_answers.present? && max_answers.present? && num_answers > 0 && max_answers > 0
      errors.add(:base, "either strict or flexible when setting values for the number or options a user can vote for")
    end
  end

  def convert_zero_to_nil
    self.num_answers = nil if num_answers == 0
    self.max_answers = nil if max_answers == 0
  end
end
