class ActiveSession < ApplicationRecord
  belongs_to :user

  # Remeber me feature
  has_secure_token :remember_token
end
