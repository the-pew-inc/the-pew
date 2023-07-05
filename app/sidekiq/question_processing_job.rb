# app/sidekiq/question_processing_job.rb
class QuestionProcessingJob
  include Sidekiq::Job

  def perform(question)
    # Extract Tone from the question
    QuestionToneJob.perform_async(question)

    # Extract the status from the question JSON
    question_status = JSON.parse(question)['status']

    # Check if the question status is not "rejected"
    if question_status != "rejected"
      # Extract Keywords from the question
      QuestionKeywordsExtractionJob.perform_async(question)

      # Extract Topic from the question
      QuestionTopicExtractionJob.perform_async(question)
    end
  end
end
