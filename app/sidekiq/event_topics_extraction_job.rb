class EventTopicsExtractionJob
  include Sidekiq::Job

  require "openai"

  def perform(event)
    # Initialize an openAI client
    client = OpenAI::Client.new

    # Fetch all the questions from an event

    # Aggregate the questions in one document

    # Extract the topics from the questions with openAI
  end
end
