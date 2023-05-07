# == Schema Information
#
# Table name: poll_options
#
#  id                      :uuid             not null, primary key
#  document_answer_enabled :boolean          default(FALSE), not null
#  is_answer               :boolean          default(FALSE), not null
#  points                  :integer          default(0), not null
#  text_answer_enabled     :boolean          default(FALSE), not null
#  title                   :string
#  title_enabled           :boolean          default(FALSE), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  poll_id                 :uuid             not null
#  user_id                 :uuid
#
# Indexes
#
#  index_poll_options_on_poll_id  (poll_id)
#  index_poll_options_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (poll_id => polls.id)
#
class PollOption < ApplicationRecord
  belongs_to :poll

  # Tracking changes
  has_paper_trail

  has_many :poll_answers, dependent: :destroy
  has_many :votes,        as: :votable, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3, maximum: 250 }

  # This is the sum of +1 and -1
  def vote_count
    Vote.where(votable_id: self.id).sum(:choice)
  end

  # This only sums the +1
  def up_votes
    Vote.where(votable_id: self.id).up_vote.sum(:choice)
  end

  # This only sums the -1
  def down_votes
    Vote.where(votable_id: self.id).down_vote.sum(:choice)
  end

end
