namespace :update_query_key_insights do

  # Usage:
  #   - rake update_query_key_insights:update_tone
  #   - rake "update_query_key_insights:update_tone[false]"
  desc 'Update queries with missing tone'
  task :update_tone, [:dry_run] => :environment do |_t, args|
    dry_run = true unless args[:dry_run] == 'false'

    puts("[#{Time.now.utc}] Running update_tone :: INI#{' (dry_run activated)' if dry_run}")

    Question.undefined.each do |question|
      puts("Updating tone for question id: #{question.id} title: #{question.title} #{' (dry_run activated)' if dry_run}")
      QuestionToneJob.perform_async(question.to_json) unless dry_run
    end

    puts("[#{Time.now.utc}] Running update_tone :: END#{' (dry_run activated)' if dry_run}")
  end

  # Usage:
  #   - rake update_query_key_insights:update_keywords
  #   - rake "update_query_key_insights:update_keywords[false]"
  desc 'Update queries with missing keywords'
  task :update_keywords, [:dry_run] => :environment do |_t, args|
    dry_run = true unless args[:dry_run] == 'false'

    puts("[#{Time.now.utc}] Running update_keywords :: INI#{' (dry_run activated)' if dry_run}")

    questions = Question.where("keywords = '{}'").not_rejected

    questions.each do |question|
      puts("Updating keywords for question id: #{question.id} title: #{question.title} #{' (dry_run activated)' if dry_run}")
      QuestionKeywordsExtractionJob.perform_async(question.to_json) unless dry_run
    end

    puts("[#{Time.now.utc}] Running update_keywords :: END#{' (dry_run activated)' if dry_run}")
  end

end
