# == Schema Information
#
# Table name: questions
#
#  id              :uuid             not null, primary key
#  ai_response     :jsonb
#  anonymous       :boolean          default(FALSE), not null
#  keywords        :string           default([]), is an Array
#  rejection_cause :integer
#  status          :integer          default("asked"), not null
#  title           :string           not null
#  tone            :integer          default("undefined"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid
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
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  test "title should be present and have length between 3 and 250 characters" do
    question = Question.new(user: users(:john), room: rooms(:one), organization_id: organizations(:one).id)

    # Test for a valid title
    question.title = "This is a valid title"
    assert question.valid?

    # Test for a title that is too short
    question.title = "a" * 2
    assert_not question.valid?

    # Test for a title that is too long
    question.title = "a" * 251
    assert_not question.valid?
  end

  test "approved_questions_for_room should return approved and answered questions for the given room" do
    room_one = rooms(:one)
    approved_questions = room_one.questions.where(status: [:approved, :answered, :beinganswered])
    assert_equal approved_questions, Question.approved_questions_for_room(room_one)
  end

  test "asked_questions_for_room should return asked questions for the given room" do
    room_one = rooms(:one)
    asked_questions = room_one.questions.where(status: :asked)
    assert_equal asked_questions, Question.asked_questions_for_room(room_one)
  end

  test "vote_count should return the total number of votes for a question" do
    question = questions(:one)
    assert_equal 2 - 1, question.vote_count
  end
  
  test "up_votes should return the total number of up votes for a question" do
    question = questions(:one)
    assert_equal 2, question.up_votes
  end
  
  test "down_votes should return the total number of down votes for a question" do
    question = questions(:one)
    assert_equal(-1, question.down_votes)
  end

  test "name should return the user's nickname if anonymous is false" do
    question = questions(:one)
    assert_equal question.user.profile.nickname, question.name
  end

  test "name should return 'User wished to remain anonymous' if anonymous is true" do
    question = questions(:two)
    assert_equal "User wished to remain anonymous", question.name
  end

  test "email should return the user's email if anonymous is false" do
    question = questions(:one)
    assert_equal question.user.email, question.email
  end

  test "email should return 'User does not want to share their email' if anonymous is true" do
    question = questions(:two)
    assert_equal "User does not want to share their email", question.email
  end

  test "testing question deletion" do
    assert_difference('Question.count', -1) do
      question = questions(:one)
      question.destroy
    end
  end
end

