require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  def setup
      @question = questions :first
  end 

  %i[title].each do |attr|
    test "#{attr} must be present" do 
      eval "@question.#{attr} = nil"
      assert_not @question.valid?
    end
  end
end
