# == Schema Information
#
# Table name: rooms
#
#  id              :uuid             not null, primary key
#  allow_anonymous :boolean          default(FALSE), not null
#  always_on       :boolean          default(FALSE), not null
#  end_date        :datetime         not null
#  name            :string           not null
#  room_type       :integer
#  start_date      :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  event_id        :uuid             not null
#  organization_id :uuid             not null
#
# Indexes
#
#  index_rooms_on_allow_anonymous  (allow_anonymous)
#  index_rooms_on_always_on        (always_on)
#  index_rooms_on_event_id         (event_id)
#  index_rooms_on_organization_id  (organization_id)
#  index_rooms_on_start_date       (start_date)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  setup do
    @room = rooms(:one)
    @room_with_always_on = rooms(:two)
  end

  test 'valid room' do
    assert @room.valid?
  end

  test 'invalid without name' do
    @room.name = nil
    refute @room.valid?, 'Room is valid without a name'
    assert_not_nil @room.errors[:name], 'no validation error for name present'
  end

  test 'set organization_id before validation' do
    room = Room.new(name: 'Test Room', event: events(:one), start_date: Time.current.utc)
    room.valid?
    assert_not_nil room.organization_id, 'organization_id should be set before validation'
    assert_equal room.organization_id, '8c5e36bb-6163-4d07-8a7e-9f13e77d6e40', 'organization_id should be set based on event'
  end

  test 'approved_question_count' do
    # You will need to add questions with the proper status to the rooms fixture
    # and then adjust the expected count accordingly.
    assert_equal @room.approved_question_count, 2, 'approved_question_count should be correct'
  end

  test 'asked_question_count' do
    # You will need to add questions with the status "asked" to the rooms fixture
    # and then adjust the expected count accordingly.
    assert_equal @room.asked_question_count, 3, 'asked_question_count should be correct'
  end

  test 'always_on room' do
    assert @room_with_always_on.always_on, 'Room should be always_on'
  end

  test 'not always_on room' do
    refute @room.always_on, 'Room should not be always_on'
  end

  test 'allow_anonymous room' do
    assert @room_with_always_on.allow_anonymous, 'Room should allow anonymous'
  end

  test 'not allow_anonymous room' do
    refute @room.allow_anonymous, 'Room should not allow anonymous'
  end
end

