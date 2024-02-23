# frozen_string_literal: true

# == Schema Information
#
# Table name: poll_answers
#
#  id             :uuid             not null, primary key
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  poll_id        :uuid             not null
#  poll_option_id :uuid             not null
#  user_id        :uuid             not null
#
# Indexes
#
#  index_poll_answers_on_poll_id         (poll_id)
#  index_poll_answers_on_poll_option_id  (poll_option_id)
#  index_poll_answers_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class PollAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :poll
  belongs_to :poll_option

  has_rich_text :text_answer

  has_many_attached :document_answers
end
