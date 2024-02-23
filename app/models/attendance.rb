# frozen_string_literal: true

# == Schema Information
#
# Table name: attendances
#
#  id         :uuid             not null, primary key
#  end_time   :datetime
#  start_time :datetime         not null
#  status     :integer          default("offline"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :uuid             not null
#  room_id    :bigint
#  user_id    :uuid             not null
#
# Indexes
#
#  index_attendances_on_event_id  (event_id)
#  index_attendances_on_room_id   (room_id)
#  index_attendances_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :room

  validates :start_time, presence: true

  enum status: {
    offline: 0,
    online: 10,
    away: 20
  }
end
