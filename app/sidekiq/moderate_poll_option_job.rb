class ModeratePollOptionJob
  include Sidekiq::Job

  require "openai"

  def perform(poll_option)
    # Initialize an openAI client
    client = OpenAI::Client.new

    # Parse the PollOption
    qh = JSON.parse(poll_option)

    # Extract the poll_option id & title
    poll_option_id = qh.dig("id")
    poll_id = qh.dig("poll_id")
    poll_option_title = qh.dig("title")
    user_id = qh.dig("user_id")


    # Check for prohibited data
    # prohibited data: email addresses, domain, website
    prohibited_content = ModerationService.detect_prohibited_content(poll_option_title)
    if prohibited_content
      # Handle prohibited content
      PollOption.update(poll_option_id, { status: :rejected })

      # Notify the user that their question was rejected
      Message.create(user_id: qh.dig("user_id"), title: "Poll Option Rejected", content: "Your poll option: #{poll_option_title} has been rejected by ModBot", level: :alert)

      raise StandardError, prohibited_content
    end

    # Send the question to openAI for moderation and wait for the response
    response = client.moderations(parameters: { input: poll_option_title })

    # Process the response from openAI
    flagged = response.dig("results", 0, "flagged")
    if flagged
      # Update the PollOption with rejected status
      PollOption.update(poll_option_id, { status: :rejected })

      # Notify the user that their question was rejected
      Message.create(user_id: qh.dig("user_id"), title: "Poll Option Rejected", content: "Your poll option: #{poll_option_title} has been rejected by ModBot", level: :alert)
    else
      # The PollOption is approved by the automatic moderation
      # Updating its status to :approved
      PollOption.update(poll_option_id, { status: :approved })
    end

    # Broadcasting the updated question
    poll = Poll.find(poll_id)
    user = User.find(user_id)
    Broadcasters::Votes::Updated.new(poll, user).call
  end
end
