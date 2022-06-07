require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  def setup
      @profile = profiles :first
  end 

  %i[nickname].each do |attr|
    test "#{attr} must be present" do 
      eval "@profile.#{attr} = nil"
      assert_not @profile.valid?
    end
  end
end
