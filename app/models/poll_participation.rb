# frozen_string_literal: true

# == Schema Information
#
# Table name: poll_participations
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  poll_id    :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_poll_participations_on_poll_id  (poll_id)
#  index_poll_participations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class PollParticipation < ApplicationRecord
  belongs_to :user
  belongs_to :poll

  # Determines if a user has already participated in a specific poll.
  #
  # @param user [User] The user to check participation for.
  # @param poll [Poll] The poll to check participation in.
  #
  # @return [Boolean] Returns true if the user has participated in the poll, false otherwise.
  #
  # @example Check if a user has participated in a poll
  #   PollParticipation.participated?(current_user, @poll)
  #   #=> true if the user has participated, false otherwise.
  def self.participated?(user, poll)
    where(user:, poll:).exists?
  end
end
