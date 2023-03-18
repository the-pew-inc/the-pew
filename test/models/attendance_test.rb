# == Schema Information
#
# Table name: attendances
#
#  id         :uuid             not null, primary key
#  end_time   :datetime
#  start_time :datetime         not null
#  status     :integer          default("offline"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :uuid             not null
#  room_id    :bigint
#  user_id    :uuid             not null
#
# Indexes
#
#  index_attendances_on_event_id  (event_id)
#  index_attendances_on_room_id   (room_id)
#  index_attendances_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class AttendanceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
