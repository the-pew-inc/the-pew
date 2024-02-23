# == Schema Information
#
# Table name: poll_participations
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  poll_id    :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_poll_participations_on_poll_id  (poll_id)
#  index_poll_participations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class PollParticipationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
