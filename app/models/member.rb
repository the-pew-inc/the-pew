class Member < ApplicationRecord
  # Tracking changes
  has_paper_trail
  
  belongs_to :user
  belongs_to :account
end
