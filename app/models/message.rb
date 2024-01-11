# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id         :uuid             not null, primary key
#  content    :text
#  level      :integer          default("info"), not null
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_messages_on_level    (level)
#  index_messages_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Message < ApplicationRecord
  has_noticed_notifications

  belongs_to :user

  after_create_commit :notify_user

  enum level: { alert: 0, info: 10, success: 20, notice: 30, warning: 40, error: 50 }

  def notify_user
    MessageNotification.with(message: self).deliver_later(user)
  end
end
