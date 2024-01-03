# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id             :uuid             not null, primary key
#  params         :jsonb
#  read_at        :datetime
#  recipient_type :string           not null
#  type           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  recipient_id   :bigint           not null
#
# Indexes
#
#  index_notifications_on_read_at    (read_at)
#  index_notifications_on_recipient  (recipient_type,recipient_id)
#
class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true

  after_create_commit :broadcast_to_recipient

  def broadcast_to_recipient
    # TODO: add the code to refresh notifications on the navigation bar
  end
end
