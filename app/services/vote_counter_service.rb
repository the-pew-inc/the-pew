# in app/services/vote_counter_service.rb
class VoteCounterService
  # This service object method takes a poll as a parameter and returns a count of votes
  # grouped by poll option title and choice.
  # 
  # @param poll [Poll]
  # @return [Hash] A hash with the count of votes for each poll option and choice.
  def self.count_by_poll_option_and_choice(poll)
    Vote.joins("JOIN poll_options ON votes.votable_id = poll_options.id AND votes.votable_type = 'PollOption'")
      .where(poll_options: { id: poll.poll_option_ids })
      .group('poll_options.title')
      .group(:choice)
      .count
  end
end
