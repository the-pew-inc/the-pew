# in app/services/vote_counter_service.rb
class VoteCounterService
  # This service object method takes a poll as a parameter and returns a count of votes
  # grouped by poll option title and choice.
  # 
  # @param poll [Poll]
  # @return [Hash] A hash with the count of votes for each poll option and choice.
  def self.count_by_poll_option_and_choice(poll)
    votes = Vote.joins("JOIN poll_options ON votes.votable_id = poll_options.id AND votes.votable_type = 'PollOption'")
      .where(poll_options: { id: poll.poll_option_ids, status: PollOption.statuses[:approved] })
      .group('poll_options.title')
      .group(:choice)
      .count
    
    grouped_votes = votes.group_by { |k, _| k[0] } # Group by the poll option title

    grouped_votes.each do |option, counts|
      total = counts.map { |_, v| v || 0 }.reduce(0, :+)
      votes[[option, 'total']] = total
    end
    
    # Convert the hash to a double array [][] in order to be able to
    # properly serialized the votes results to an ActiveJob used by
    # TurboStream delay
    convert_table_data(votes, poll)
  end

  # Fetches all votable IDs (associated with PollOptions) for a specific user on a particular poll.
  #
  # This method is used to efficiently fetch all votes made by a user on a particular poll.
  # The votable IDs correspond to the IDs of the PollOptions that the user has voted on. 
  # The result can be used to indicate visually on the UI which options a user has voted for.
  #
  # @param user [User] The user for whom to fetch the votes.
  # @param poll [Poll] The poll on which to fetch the user's votes.
  #
  # @return [Array<Integer>] An array of IDs corresponding to the PollOptions that the user has voted on.
  def self.user_votes_for_poll(user, poll)
    Vote.joins("JOIN poll_options ON votes.votable_id = poll_options.id AND votes.votable_type = 'PollOption'")
    .where(user: user, votable: poll.poll_options)
    .pluck('poll_options.title', 'votes.choice')
    .to_h
  end

  private
  def self.convert_table_data(raw_table_data, poll)
    new_table_data = {}

    # Initialize each poll_option title with a zeroed vote hash
    poll.poll_options.each do |option|
      new_table_data[option.title] = { 'up_vote' => 0, 'down_vote' => 0, 'neutral' => 0, 'total' => 0 }
    end

    
    raw_table_data.each do |(option, choice), count|
      new_table_data[option] ||= {}
      new_table_data[option][choice] = count
    end
    
    new_table_data
  end
end
