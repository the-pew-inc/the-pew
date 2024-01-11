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
  def setup
    @attendance = attendances(:one)
  end

  test 'should be valid' do
    assert @attendance.valid?
  end

  test 'should require a user' do
    @attendance.user = nil
    assert_not @attendance.valid?
  end

  test 'should require an event' do
    @attendance.event = nil
    assert_not @attendance.valid?
  end

  test 'should require a room' do
    @attendance.room = nil
    assert_not @attendance.valid?
  end

  test 'should have a start time' do
    @attendance.start_time = nil
    assert_not @attendance.valid?
  end

  test 'can have an end time' do
    @attendance.end_time = nil
    assert @attendance.valid?
  end

  test 'should have a valid status' do
    assert_includes Attendance.statuses.keys, @attendance.status
  end

  # Add more tests as necessary
end
