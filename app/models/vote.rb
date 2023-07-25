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
      up_vote? ? cancel! : up_vote!
    when 'down_vote'
      down_vote? ? cancel! : down_vote!
    when 'cancel'
      cancel!
    else
      errors.add(:choice, 'invalid_choice')
      return
    end
  end

  def poll_voted(poll, user, choice)
    num_votes = poll.num_votes
    max_votes = poll.max_votes
  
    case choice
    when 'up_vote'
      if up_vote?
        make_it_null!
      else
        if num_votes.nil? || num_votes <= 0
          up_vote!
          poll.update_participants
        elsif max_votes.nil? || max_votes > 0
          vote_count = user_votes_in_poll(user, poll)
          if num_votes > vote_count
            up_vote!
            poll.update_participants
          else
            errors.add(:vote, 'num_votes_exceeded')
          end
        else
          errors.add(:vote, 'invalid_poll_settings')
        end
      end
    when 'down_vote'
      if down_vote?
        make_it_null!
      else
        if num_votes.nil? || num_votes <= 0
          down_vote!
          poll.update_participants
        elsif max_votes.nil? || max_votes > 0
          vote_count = user_votes_in_poll(user, poll)
          if num_votes > vote_count
            down_vote!
            poll.update_participants
          else
            errors.add(:vote, 'num_votes_exceeded')
          end
        else
          errors.add(:vote, 'invalid_poll_settings')
        end
      end
    when 'cancel'
      if cancel?
        make_it_null!
      else
        if num_votes.nil? || num_votes <= 0
          cancel!
          poll.update_participants
        elsif max_votes.nil? || max_votes > 0
          vote_count = user_votes_in_poll(user, poll)
          if num_votes > vote_count
            cancel!
            poll.update_participants
          else
            errors.add(:vote, 'num_votes_exceeded')
          end
        else
          errors.add(:vote, 'invalid_poll_settings')
        end
      end
    else
      errors.add(:choice, 'invalid_choice')
    end
  end
  
  private

  def user_votes_in_poll(user, poll)
    Vote.where(votable: poll.poll_options, user_id: user.id).count
  end

end
