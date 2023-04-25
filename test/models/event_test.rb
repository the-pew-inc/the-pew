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
  setup do
    @event = events(:one)
    @event_invalid_end_date = events(:two)
  end

  test 'valid event' do
    assert @event.valid?
  end

  test 'invalid end date' do
    refute @event_invalid_end_date.valid?
    assert_not_nil @event_invalid_end_date.errors[:end_date], 'no validation error for end date present'
  end

  test 'name length validation' do
    @event.name = 'a' * 251
    refute @event.valid?
    assert_not_nil @event.errors[:name], 'no validation error for name length present'
  end

  test 'start and end date presence' do
    @event.start_date = nil
    @event.end_date = nil
    refute @event.valid?
    assert_not_nil @event.errors[:start_date], 'no validation error for start date presence'
    assert_not_nil @event.errors[:end_date], 'no validation error for end date presence'
  end

  test 'generates unique short_code' do
    short_code = @event.short_code
    new_event = @event.dup
    new_event.short_code = nil
    new_event.save
    refute_equal short_code, new_event.short_code, 'short_code should be unique'
  end

  test 'sets organization_id based on user_id' do
    new_event = @event.dup
    new_event.organization_id = nil
    new_event.save
    assert_equal new_event.organization_id, '8c5e36bb-6163-4d07-8a7e-9f13e77d6e40', 'organization_id should be set based on user_id'
  end
end
