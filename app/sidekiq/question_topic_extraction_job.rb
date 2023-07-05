# app/sidekiq/question_topic_extraction_job.rb

# Description: used to extract the topic covered by a question.

class QuestionTopicExtractionJob
  include Sidekiq::Job

  require "openai"

  def perform(question)
    # Initialize an openAI client
    client = OpenAI::Client.new

    # Parse the question
    qh = JSON.parse(question)
    # puts "## Question ##"
    # puts qh

    # Extracting key values from the question
    room_id = qh.dig("room_id")
    question_id = qh.dig("id")
    question_title = qh.dig("title")
    user_id = qh.dig("user_id")

    # Find the event id
    event_id = Room.select(:event_id).find(room_id).event_id
    puts "## Event id: #{event_id}"

    # Extracting the topic from the question using openAI
    pr = PromptRetrieverService.retrieve("question-topic-extraction", nil, {title: question_title})
    # puts "## PROMPT ##"
    # puts pr.inspect

    messages = JSON.parse(pr[:messages])

    params = {
      model: pr[:model],
      messages: messages,
      temperature: 0.7,
      user: qh.dig("user_id")
    }

    # puts params

    response = client.chat(
      parameters: params
      )

    # puts response

    topics = response.dig("choices", 0, "message","content")
    topics = topics.split(", ")
    topics.map{ |word| word.strip.chomp(".") }
    puts "TOPICS IS ARRAY? #{topics.kind_of?(Array)}"
    puts "QUESTION: #{question_title}"
    puts "TOPICS AS ARRAY: #{topics}"
    if topics.kind_of?(Array)
      topics.each do |topic|
        param = {
          event_id: event_id,
          question_id: question_id,
          room_id: room_id,
          user_id: user_id,
          description: "Question: #{question_title}",
          name: topic
        }
        Topic.upsert(param , unique_by: [:question_id, :room_id, :user_id])
      end
    end
  end
end
