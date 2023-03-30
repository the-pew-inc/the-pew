class QuestionProcessingJob
  include Sidekiq::Job

  def perform(question)
    # Extract key elements from the question such as Tone, Keywords
    # Topics are extracted via a cron job

    # Extract Tone from the quesstion
    QuestionToneJob.perform_async(question)
  
    # Extract Keywords from the question
    QuestionKeywordsExtractionJob.perform_async(question)
  end
end
