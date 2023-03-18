# == Schema Information
#
# Table name: rooms
#
#  id              :uuid             not null, primary key
#  allow_anonymous :boolean          default(FALSE), not null
#  always_on       :boolean          default(FALSE), not null
#  name            :string           not null
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
  def setup
    @room = rooms(:one)
  end

  test "valid room" do
    assert @room.valid?
  end

  test "invalid without name" do
    @room.name = nil
    assert_not @room.valid?
  end
end
