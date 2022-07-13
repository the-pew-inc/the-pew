require "test_helper"

class YourQuestionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get your_questions_index_url
    assert_response :success
  end

  test "should get show" do
    get your_questions_show_url
    assert_response :success
  end
end
