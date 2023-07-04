class QuestionKeywordsExtractionJob
  include Sidekiq::Job

  require "openai"
  require "yaml"
  require_relative "../services/prompt_retriever_service.rb"

  def perform(question)
    # Initialize an openAI client
    client = OpenAI::Client.new

    # Parse the question
    qh = JSON.parse(question)

    question_title = qh.dig("title")
    # Use Chat GPT to extract the relevant keywords from the question
    pr = PromptRetrieverService.retrieve("question-keyword-extraction", nil, {title: question_title})
    # puts "## PROMPT ##"
    # puts pr.inspect

    messages = JSON.parse(pr[:messages])

    params = {
      model: pr[:model],
      messages: messages,
      temperature: 0.7,
      user: qh.dig("user_id")
    }

    puts params

    response = client.chat(
      parameters: params
      )

    puts response
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
