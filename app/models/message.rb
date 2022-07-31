class Message < ApplicationRecord
  has_noticed_notifications

  belongs_to :user

  after_create_commit :notify_user

  enum level: { alert: 0, info: 10, success: 20, notice: 30, warning: 40, error: 50 }

  def notify_user
    MessageNotification.with(message: self).deliver_later(user)
  end

end
