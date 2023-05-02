require "test_helper"

class PollsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    login @user
    @organization = organizations(:one)
    @poll = polls(:one)
  end

  test "should get new" do
    get new_poll_url
    assert_response :success
  end

  test "should create a new poll" do
    assert_difference("Poll.count") do
      post polls_url, params: {
        poll: {
          title: "New Poll",
          poll_type: "universal",
          status: "opened",
          duration: 7,
          organization_id: @organization.id,
          user_id: @user.id,
          poll_options_attributes: [
            { title: "Option 1" },
            { title: "Option 2" }
          ]
        }
      }
    end
    assert_redirected_to polls_url
    assert_equal "The poll was succesfully saved.", flash[:notice]
  end

  test "should get edit" do
    get edit_poll_url(@poll)
    assert_response :success
  end

  test "should update a poll" do
    patch poll_url(@poll), params: {
      poll: {
        title: "Updated Poll",
        poll_type: "restricted",
        status: "closed",
        duration: 14,
        poll_options_attributes: [
          { id: poll_options(:one).id, title: "Option 2 Updated" }, # updated poll option
          { id: poll_options(:two).id, title: "Option 1 Updated" }  # updated poll option
        ]
      }
    }
    assert_redirected_to polls_url
    assert_equal "The poll was succesfully updated.", flash[:notice]
    @poll.reload
    assert_equal "Updated Poll", @poll.title
    assert_equal "restricted", @poll.poll_type
    assert_equal "closed", @poll.status
    assert_equal 14, @poll.duration
    assert_equal "Option 1 Updated", @poll.poll_options.first.title
    assert_equal "Option 2 Updated", @poll.poll_options.second.title
  end
end