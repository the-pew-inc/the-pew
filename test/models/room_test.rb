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
