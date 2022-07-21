class Vote < ApplicationRecord
  # include ActionView::RecordIdentifier
  # include ApplicationHelper

  belongs_to :user
  belongs_to :votable, polymorphic: true

  # validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

  enum choice: { up_vote: 1, down_vote: -1, cancel: 0 }
end
