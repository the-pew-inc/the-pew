require "test_helper"

class AsksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get asks_index_url
    assert_response :success
  end
end
