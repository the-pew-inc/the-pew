class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  enum choice: { up_vote: 1, down_vote: -1, cancel: 0 }

  def voted(choice)
    case choice
    when 'up_vote'
      up_vote? ? cancel! : up_vote!
    when 'down_vote'
      down_vote? ? cancel! : down_vote!
    else
      logger.error "User #{self.user_id} tried to use an invalid vote choice: #{choice}"
      return
    end
  end

end
