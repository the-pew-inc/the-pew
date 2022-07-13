class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :voteable, polymorphic: true
end
