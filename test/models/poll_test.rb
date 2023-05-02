# == Schema Information
#
# Table name: polls
#
#  id              :uuid             not null, primary key
#  add_option      :boolean          default(TRUE), not null
#  duration        :integer
#  participants    :integer          default(0), not null
#  poll_type       :integer          not null
#  status          :integer          not null
#  title           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#  user_id         :uuid             not null
#
# Indexes
#
#  index_polls_on_organization_id  (organization_id)
#  index_polls_on_poll_type        (poll_type)
#  index_polls_on_status           (status)
#  index_polls_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class PollTest < ActiveSupport::TestCase
  test "should create a new poll" do
    poll = Poll.new(
      title: "New Poll",
      poll_type: "universal",
      status: "opened",
      duration: 7,
      organization: organizations(:one),
      user: users(:john)
    )
    poll.poll_options.build(title: "Option 1")
    poll.poll_options.build(title: "Option 2")
    
    assert poll.save
    assert_equal "New Poll", poll.title
    assert_equal "universal", poll.poll_type
    assert_equal "opened", poll.status
    assert_equal 7, poll.duration
    assert_equal organizations(:one), poll.organization
    assert_equal users(:john), poll.user
  end
end
