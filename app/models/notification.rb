class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true

  after_create_commit :broadcast_to_recipient

  def broadcast_to_recipient
    broadcast_remove(
      recipient,
      :notifications,
      target: 'notificationBellDot'
    )
    broadcast_append_later_to(
      recipient,
      :notifications,
      target: 'notificationBellButton',
      html: '<span id="notification-dot" class="top-1 left-5 absolute w-3.5 h-3.5 bg-red-400 border-2 border-white dark:border-gray-800 rounded-full"></span>'.html_safe
    )
  end

end
