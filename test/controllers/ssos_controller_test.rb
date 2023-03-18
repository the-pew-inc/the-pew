require "test_helper"

class SsosControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get sso_edit_url
    assert_response :success
  end

  test "should get show" do
    get sso_show_url
    assert_response :success
  end

  test "should get update" do
    get sso_update_url
    assert_response :success
  end
end
