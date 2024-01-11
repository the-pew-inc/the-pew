# == Schema Information
#
# Table name: active_sessions
#
#  id             :uuid             not null, primary key
#  ip_address     :string
#  remember_token :string           not null
#  user_agent     :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :uuid             not null
#
# Indexes
#
#  index_active_sessions_on_ip_address      (ip_address)
#  index_active_sessions_on_remember_token  (remember_token) UNIQUE
#  index_active_sessions_on_user_agent      (user_agent)
#  index_active_sessions_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#
# test/models/active_session_test.rb

require 'test_helper'

class ActiveSessionTest < ActiveSupport::TestCase
  def setup
    @active_session_one = active_sessions(:one)
    @active_session_two = active_sessions(:two)
  end

  test 'fixture sessions should be valid' do
    assert @active_session_one.valid?
    assert @active_session_two.valid?
  end

  test 'sessions should have unique remember tokens' do
    assert_not_equal @active_session_one.remember_token, @active_session_two.remember_token
  end

  test 'session should be linked to a user' do
    assert_not_nil @active_session_one.user_id
    assert_not_nil @active_session_two.user_id
  end

  test 'session should have an IP address' do
    assert_not_nil @active_session_one.ip_address
    assert_not_nil @active_session_two.ip_address
  end

  test 'session should have a user agent' do
    assert_not_nil @active_session_one.user_agent
    assert_not_nil @active_session_two.user_agent
  end

  # Additional tests can be added as necessary
end
