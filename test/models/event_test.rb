# == Schema Information
#
# Table name: events
#
#  id              :uuid             not null, primary key
#  allow_anonymous :boolean          default(FALSE), not null
#  always_on       :boolean          default(FALSE), not null
#  duration        :integer
#  end_date        :datetime         not null
#  event_type      :integer          not null
#  name            :string           not null
#  short_code      :string
#  start_date      :datetime         not null
#  status          :integer          default("draft"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#  user_id         :uuid             not null
#
# Indexes
#
#  index_events_on_allow_anonymous  (allow_anonymous)
#  index_events_on_always_on        (always_on)
#  index_events_on_event_type       (event_type)
#  index_events_on_organization_id  (organization_id)
#  index_events_on_short_code       (short_code)
#  index_events_on_status           (status)
#  index_events_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    logger.debug "Calling setup"
    @event = events(:one)
    logger.debug "End setup"
  end

  test "event belongs to a user" do
    assert_equal users(:one), @event.user
  end
end
