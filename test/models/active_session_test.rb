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
require 'test_helper'

class ActiveSessionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
