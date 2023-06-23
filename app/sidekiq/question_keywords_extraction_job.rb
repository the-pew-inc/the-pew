class QuestionKeywordsExtractionJob
  include Sidekiq::Job

  require "openai"
  require_relative "../services/prompt_retriever_service.rb"

  def perform(question)
    # Initialize an openAI client
    client = OpenAI::Client.new

    # Parse the question
    qh = JSON.parse(question)

    # Use GTP 4 Chat to extract the relevant keywords from the question
    pr = PromptRetrieverService.retrieve("question-keyword-extraction", nil)
    puts "## PROMPT ##"
    puts pr
    response = client.chat(
      parameters: {
          model: "gpt-4",
          messages: [
            { role: "system", content: pr[:prompt] },
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
