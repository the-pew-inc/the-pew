require "test_helper"

class RoleTest < ActiveSupport::TestCase

  test "presence and uniqueness of name" do
    should validate_presence_of(:name)
    should validate_uniqueness_of(:name)
  end

  test "relationships" do
    should have_many(:assignments)
    should have_many(:users).through(:assignments)
  end

end
