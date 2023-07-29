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
