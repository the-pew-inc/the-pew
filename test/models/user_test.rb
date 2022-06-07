require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
      @user = users :first
  end 

  %i[email password].each do |attr|
    test "#{attr} must be present" do 
      eval "@user.#{attr} = nil"
      assert_not @user.valid?
    end
  end
end
