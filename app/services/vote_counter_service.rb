# in app/services/vote_counter_service.rb
class VoteCounterService
  # This service object method takes a poll as a parameter and returns a count of votes
  # grouped by poll option title and choice.
  # 
  # @param poll [Poll]
  # @return [Hash] A hash with the count of votes for each poll option and choice.
  def self.count_by_poll_option_and_choice(poll)
    votes = Vote.joins("JOIN poll_options ON votes.votable_id = poll_options.id AND votes.votable_type = 'PollOption'")
      .where(poll_options: { id: poll.poll_option_ids })
      .group('poll_options.title')
      .group(:choice)
      .count
    
    grouped_votes = votes.group_by { |k, _| k[0] } # Group by the poll option title

    grouped_votes.each do |option, counts|
      total = counts.map { |_, v| v || 0 }.reduce(0, :+)
      votes[[option, 'total']] = total
    end
    
    # votes  # return the updated hash
    # Change to an [][] 
    convert_table_data(votes)
  end

  private
  def self.convert_table_data(raw_table_data)
    new_table_data = {}
    
    raw_table_data.each do |(option, choice), count|
      new_table_data[option] ||= {}
      new_table_data[option][choice] = count
    end
    
    new_table_data
  end
end
