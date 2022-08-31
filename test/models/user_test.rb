require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  %i[email password].each do |attr|
    test "#{attr} must be present" do
      eval "@user.#{attr} = nil"
      assert_not @user.valid?
    end
  end

  # test "roles and assignments" do
  #   should have_many(:assignments)
  #   should have_many(:roles).through(:assignments)
  # end

  # test "user should have role" do
  #   assert_not(@subject.role? :admin)

  #   @subject.roles << Role.new(name: 'admin')

  #   assert(@subject.role? :admin)
  # end
end
