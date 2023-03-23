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
    reasons = response.dig("results", 0, "categories")
    if flagged
      # The question is rejected by the automatic moderation
      cause = :other
      reasons = response.dig("results", 0, "categories")
      reasons.each do |reason|
        if reason[0] == "sexual" && reason[1] == true
          cause = :explicit
        end
        if reason[0] == "hate" && reason[1] == true
          cause = :offensive
        end
        if reason[0] == "violence" && reason[1] == true
          cause = :offensive
        end
        if reason[0] == "self-harm" && reason[1] == true
          cause = :explicit
        end
        if reason[0] == "sexual/minors" && reason[1] == true
          cause = :offensive
        end
        if reason[0] == "hate/threatening" && reason[1] == true
          cause = :offensive
        end
        if reason[0] == "violence/graphic" && reason[1] == true
          cause = :inapropriate
        end
      end

      # Update the question with rejected status
      Question.update(question.dig("id"), {status: :rejected, rejection_cause: cause, ai_response: response})

      # Notify the user that their question was rejected
      Message.create(user_id: question.dig("user_id"), title: "Question Rejected", content: "Your question: #{question.dig("title")} has been rejected by ModBot", level: :alert)
    else
      # The question is approved by the automatic moderation
      Question.update(question.dig("id"), {status: :approved, ai_response: response})
    end
  end
end
