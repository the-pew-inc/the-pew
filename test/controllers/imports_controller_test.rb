require "test_helper"

class ImportsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get imports_new_url
    assert_response :success
  end

  test "should get create" do
    get imports_create_url
    assert_response :success
  end
end
