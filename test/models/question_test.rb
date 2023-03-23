# == Schema Information
#
# Table name: questions
#
#  id              :uuid             not null, primary key
#  ai_response     :jsonb
#  anonymous       :boolean          default(FALSE), not null
#  rejection_cause :integer
#  status          :integer          default("asked"), not null
#  title           :string           not null
#  tone            :integer          default("undefined"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#  parent_id       :uuid
#  room_id         :uuid             not null
#  user_id         :uuid             not null
#
# Indexes
#
#  index_questions_on_anonymous            (anonymous)
#  index_questions_on_organization_id      (organization_id)
#  index_questions_on_parent_id            (parent_id)
#  index_questions_on_rejection_cause      (rejection_cause)
#  index_questions_on_room_id              (room_id)
#  index_questions_on_status               (status)
#  index_questions_on_tone                 (tone)
#  index_questions_on_user_id              (user_id)
#  index_questions_on_user_id_and_room_id  (user_id,room_id)
#  index_questions_on_user_id_and_status   (user_id,status)
#
# Foreign Keys
#
#  fk_rails_...  (room_id => rooms.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  def setup
    @question = questions(:first)
  end

  %i[title].each do |attr|
    test "#{attr} must be present" do
      eval "@question.#{attr} = nil"
      assert_not @question.valid?
    end
  end
end
