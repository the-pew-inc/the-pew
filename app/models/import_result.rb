# frozen_string_literal: true

# == Schema Information
#
# Table name: import_results
#
#  id         :uuid             not null, primary key
#  filename   :string           not null
#  message    :text
#  status     :integer          default("uploading"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_import_results_on_status   (status)
#  index_import_results_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class ImportResult < ApplicationRecord
  belongs_to :user

  validates :filename, presence: true

  enum status: { uploading: 0, processing: 10, success: 20, error: 30 }
end
