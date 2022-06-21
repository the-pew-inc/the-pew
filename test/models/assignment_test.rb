require "test_helper"

class AssignmentTest < ActiveSupport::TestCase

  test "test assignment relationship" do
    should belong_to(:user)
    should belong_to(:role)
  end
end
