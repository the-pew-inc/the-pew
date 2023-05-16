require "test_helper"

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should render 404 not found" do
    get "/404"
    assert_response 404
  end

  test "should render 422 unacceptable" do
    get "/422"
    assert_response 422
  end

  test "should render 500 internal server error" do
    get "/500"
    assert_response 500
  end
end
