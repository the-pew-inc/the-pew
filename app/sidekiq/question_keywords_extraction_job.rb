class QuestionKeywordsExtractionJob
  include Sidekiq::Job

  require "openai"

  def perform(question)
    # Initialize an openAI client
    client = OpenAI::Client.new

    # Parse the question
    qh = JSON.parse(question)

    # Use GTP 3.5 Chat to extract the relevant keywords from the question
    response = client.chat(
      parameters: {
          # model: "gpt-3.5-turbo",
          model: "gpt-4",
          messages: [
            { role: "system", content: 'Given a short conversational sentence, extract up to 10 meaningful keywords without expressing any opinions or using words that are not present in the sentence. If the sentence is a basic question like "what is this?", "why is this?", or "how could it be?", or if the sentence does not contain sufficient information to extract meaningful keywords, return an empty string "". Otherwise, return a comma-separated string of up to 10 keywords without any additional formatting.' },
            { role: "user", content: "Extract keywords from this text:\n\n" + qh.dig("title")}
          ],
          temperature: 0.7,
          user: qh.dig("user_id")
      })
    keywords = response.dig("choices", 0, "message","content")
    keywords = keywords.split(", ")
    keywords.map{ |word| word.strip.chomp(".") }
    # puts "KEYWORD IS ARRAY? #{keywords.kind_of?(Array)}"
    # puts "QUESTION: #{qh.dig("title")}"
    # puts "KEYWORDS AS ARRAY: #{keywords}"
    if keywords.kind_of?(Array)
      Question.update(qh.dig("id"), { keywords: keywords })
    end
  end
end
