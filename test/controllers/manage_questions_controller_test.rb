require "test_helper"

class ManageQuestionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get manage_questions_index_url
    assert_response :success
  end
end
