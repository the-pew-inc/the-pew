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
require "test_helper"

class ImportResultTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
