class QuestionToneJob
  include Sidekiq::Job

  require "openai"

  def perform(question)
    # Initialize an openAI client
    client = OpenAI::Client.new

    # Parse the question
    qh = JSON.parse(question)

    # Passing the question to davinci for sentiment analysis
    response = client.completions(
      parameters: {
          model: "text-davinci-003",
          prompt: "Classify the sentiment in the following question: " + qh.dig("title"),
          temperature: 0,
          max_tokens: 60,
          top_p: 1.0,
          frequency_penalty: 0.0,
          presence_penalty: 0.0
      }
    )
    
    # Save the detected tone in the tone column of the question
    # Default to :undefined in case the tone is not properly identified by openAI
    response["choices"].map { |c| update_query_tone(qh.dig("id"), c["text"]) }
    
  end

  private

  def update_query_tone(id, tone)
    Question.update(id, { tone: tone(tone) })
  end

  def tone(tone)
    puts "QUESTION TONE IS: #{tone}"
    case tone.strip
    when "Neutral"
      return :neutral
    when "Positive"
      return :positive
    when "Negative"
      return :negative
    else
      return :undefined
    end
  end
end
