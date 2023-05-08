# == Schema Information
#
# Table name: polls
#
#  id              :uuid             not null, primary key
#  add_option      :boolean          default(TRUE), not null
#  duration        :integer
#  max_answers     :integer
#  max_votes       :integer
#  num_answers     :integer
#  num_votes       :integer
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

  test "should not allow num_answers to be greater than the number of poll options" do
    poll = Poll.new(
      title: "New Poll",
      poll_type: "universal",
      status: "opened",
      num_answers: 3, # should not be greater than the number of poll options
      organization: organizations(:one),
      user: users(:john)
    )
    poll.poll_options.build(title: "Option 1")
    poll.poll_options.build(title: "Option 2")
    
    assert_not poll.save
    assert_equal ["cannot be greater than the number of poll options"], poll.errors[:num_answers]
  end

  test "should not allow max_answers to be greater than the number of poll options" do
    poll = Poll.new(
      title: "New Poll",
      poll_type: "universal",
      status: "opened",
      max_answers: 3, # should not be greater than the number of poll options
      organization: organizations(:one),
      user: users(:john)
    )
    poll.poll_options.build(title: "Option 1")
    poll.poll_options.build(title: "Option 2")
    
    assert_not poll.save
    assert_equal ["cannot be greater than the number of poll options"], poll.errors[:max_answers]
  end

  test "should not allow num_answers and max_answers to both be greater than 0" do
    poll = Poll.new(
      title: "New Poll",
      poll_type: "universal",
      status: "opened",
      num_answers: 2,
      max_answers: 2, # should not allow both to be greater than 0
      organization: organizations(:one),
      user: users(:john)
    )
    poll.poll_options.build(title: "Option 1")
    poll.poll_options.build(title: "Option 2")
    
    assert_not poll.save
    assert_equal ["either strict or flexible when setting values for the number or options a user can vote for"], poll.errors[:base]
  end

  test "should allow num_answers and max_answers to both be nil" do
    poll = Poll.new(
      title: "New Poll",
      poll_type: "universal",
      status: "opened",
      organization: organizations(:one),
      user: users(:john)
    )
    poll.poll_options.build(title: "Option 1")
    poll.poll_options.build(title: "Option 2")
    
    assert poll.save
    assert_nil poll.num_answers
    assert_nil poll.max_answers
  end

  test "should allow num_answers and max_answers to be 0 and convert to nil" do
    poll = Poll.new(
      title: "New Poll",
      poll_type: "universal",
      status: "opened",
      num_answers: 0,
      max_answers: 0,
      organization: organizations(:one),
      user: users(:john)
    )
    poll.poll_options.build(title: "Option 1")
    poll.poll_options.build(title: "Option 2")
    
    assert poll.save
    assert_nil poll.num_answers
    assert_nil poll.max_answers
  end
end
