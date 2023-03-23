class ModerateQuestionJob
  include Sidekiq::Job

  require "openai"

  def perform(question)
    # Initialize an openAI client
    client = OpenAI::Client.new

    # Parse the question
    question = JSON.parse(question)

    # Send the question to openAI for moderation and wait for the response
    response = client.moderations(parameters: { input: question.dig("title") })  
    
    # Process the response from openAI
    flagged = response.dig("results", 0, "flagged")
    if flagged
      # The question is rejected by the automatic moderation
      reasons = response.dig("results", 0, "categories")
      reasons.each do |reason|
        
      end
      # Update the question with rejected status
      Question.update(question.dig("id"), {status: :rejected, rejection_cause: :other, ai_response: response})

      # Notify the user that their question was rejected
    else
      # The question is approved by the automatic moderation
      Question.update(question.dig("id"), {status: :approved, ai_response: response})
    end
  end
end
