# There is one service class per action: Created, Updated and Deleted
# The service class can be called anywhere, including in the console, as soon as a
# proper poll object is passed.
# Exanple: 
#
# @poll = Poll.first
# Broadcasters::Votes::Updated.new(@poll).call
class Broadcasters::Votes::Updated
  attr_reader :poll

  def initialize(poll)
    @poll = poll
  end

  def call
    @table_data = VoteCounterService.count_by_poll_option_and_choice(@poll)
    Turbo::StreamsChannel.broadcast_update_later_to  @poll, target: "poll-results", partial: "polls/poll_stats", locals: { poll: @poll, table_data: @table_data }
  end

end