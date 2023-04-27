# == Schema Information
#
# Table name: votes
#
#  id           :bigint           not null, primary key
#  choice       :integer          default("cancel")
#  votable_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid             not null
#  votable_id   :uuid             not null
#
# Indexes
#
#  index_votes_on_user_id  (user_id)
#  index_votes_on_votable  (votable_type,votable_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  def setup
    @user = users(:john)
    @question = questions(:one)
    @vote = votes(:one)
    @upvote = votes(:one)
    @downvote = votes(:two)
    @cancelvote = votes(:four)
  end

  test 'vote should be valid' do
    assert @vote.valid?
  end

  test 'user id should be present' do
    @vote.user_id = nil
    assert_not @vote.valid?
  end

  test 'votable id should be present' do
    @vote.votable_id = nil
    assert_not @vote.valid?
  end

  test 'votable type should be present' do
    @vote.votable_type = nil
    assert_not @vote.valid?
  end

  test 'choice should be present' do
    vote = votes(:one)
    vote.choice = :up_vote
    assert vote.valid?
  end

  test 'voted should upvote if choice is up_vote' do
    assert @upvote.up_vote?
  end

  test 'voted should downvote if choice is down_vote' do
    assert @downvote.down_vote?
  end

  test 'voted should cancel if choice is cancel' do
    assert @cancelvote.cancel?
  end

end
