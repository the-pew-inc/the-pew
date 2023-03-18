# == Schema Information
#
# Table name: topics
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  event_id    :uuid
#  question_id :uuid
#  room_id     :uuid
#  user_id     :uuid
#
# Indexes
#
#  index_topics_on_event_id     (event_id)
#  index_topics_on_name         (name)
#  index_topics_on_question_id  (question_id)
#  index_topics_on_room_id      (room_id)
#  index_topics_on_user_id      (user_id)
#
require "test_helper"

class TopicTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
