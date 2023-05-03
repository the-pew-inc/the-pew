# == Schema Information
#
# Table name: votes
#
#  id           :bigint           not null, primary key
#  choice       :integer          default("cancel")
#  votable_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid             not null
#  votable_id   :uuid             not null
#
# Indexes
#
#  index_votes_on_user_id  (user_id)
#  index_votes_on_votable  (votable_type,votable_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  enum choice: { up_vote: 1, down_vote: -1, cancel: 0, make_it_null: nil }

  def voted(choice)
    case choice
    when 'up_vote'
      up_vote? ? make_it_null! : up_vote!
    when 'down_vote'
      down_vote? ? make_it_null! : down_vote!
    when 'cancel'
      cancel!
    else
      errors.add(:choice, 'invalid_choice')
      return
    end
  end

end
