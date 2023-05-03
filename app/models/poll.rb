# == Schema Information
#
# Table name: polls
#
#  id              :uuid             not null, primary key
#  add_option      :boolean          default(TRUE), not null
#  duration        :integer
#  participants    :integer          default(0), not null
#  poll_type       :integer          not null
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

  # Tracking changes
  has_paper_trail

  # Relationships
  has_many :poll_options, dependent: :destroy
  accepts_nested_attributes_for :poll_options, allow_destroy: true
  
  has_many :poll_answers, dependent: :destroy

  has_rich_text :description

  validates :title, presence: true, length: { minimum: 3, maximum: 250 }
  validate :validate_poll_options

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
    self.participants = 0
  end


  private

  def validate_poll_options
    if poll_options.size < 2
      errors.add(:poll_options, "must have at least two options")
    end
  end
end
