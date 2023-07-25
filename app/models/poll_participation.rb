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
    where(user: user, poll: poll).exists?
  end
end
