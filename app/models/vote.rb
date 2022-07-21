class Vote < ApplicationRecord
  include ActionView::RecordIdentifier
  include ApplicationHelper

  belongs_to :user
  belongs_to :votable, polymorphic: true

  # validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

  enum choice: { up_vote: 1, down_vote: -1, cancel: 0 }

  def voted(choice)
    return unless choice.in?(Vote::choices.keys)

    case choice
    when 'up_vote'
      up_vote? ? cancel! : up_vote!
    when 'down_vote'
      down_vote? ? cancel! : down_vote!
    end
  end

  # TODO: find a way to make the target independent from the object
  after_update_commit do
    target_name = [votable.room_id, votable.class.name.downcase.pluralize]
    broadcast_update_later_to(target_name, target: "#{dom_id(votable)}_count", html: votable.vote_count)
  end

end
