class ModerateQuestionJob
  include Sidekiq::Job

  require "openai"

  def perform(question)
    # Initialize an openAI client
    client = OpenAI::Client.new

    # Parse the question
    qh = JSON.parse(question)

    # Extract the question id & title
    qid = qh.dig("id")
    question_title = qh.dig("title")

    # Check for prohibited data
    # prohibited data: email addresses, domain, website
    prohibited_content = ModerationService.detect_prohibited_content(question_title)
    if prohibited_content
      # Handle prohibited content
      Question.update(qid, { status: :rejected, 
        rejection_cause: :inapropriate,
        tone: :negative,
        ai_response: nil})

      # Notify the user that their question was rejected
      Message.create(user_id: qh.dig("user_id"), title: "Question Rejected", content: "Your question: #{question_title} has been rejected by ModBot", level: :alert)

      raise StandardError, prohibited_content
    end

    # Send the question to openAI for moderation and wait for the response
    response = client.moderations(parameters: { input: question_title })  

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
      # Defaulting the tone to negative as the rejection case is negative
      Question.update(qid, { status: :rejected, 
                                            rejection_cause: cause,
                                            tone: :negative,
                                            ai_response: response})

      # Notify the user that their question was rejected
      Message.create(user_id: qh.dig("user_id"), title: "Question Rejected", content: "Your question: #{question_title} has been rejected by ModBot", level: :alert)
    else
      # The question is approved by the automatic moderation
      # Updating its status to :approved
      Question.update(qid, {status: :approved, ai_response: response})


      # Calling the QUestionProcessingJob where most of the question analysis is performed
      # This is a single call to reduce the Moderation Worker processing time.
      QuestionProcessingJob.perform_async(question)
    end

    # Broadcasting the updated question
    qb = Question.find(qid)
    Broadcasters::Questions::Updated.new(qb).call
  end
end
