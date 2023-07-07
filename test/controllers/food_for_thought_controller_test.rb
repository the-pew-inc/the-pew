require "test_helper"

class FoodForThoughtControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get food_for_thought_show_url
    assert_response :success
  end
end
