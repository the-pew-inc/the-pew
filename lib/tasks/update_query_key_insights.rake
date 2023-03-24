namespace :update_query_key_insights do

  # Usage:
  #   - rake update_query_key_insights:update_queries
  #   - rake "update_query_key_insights:update_queries[false]"
  desc 'Update queries with missing information'
  task :update_queries, [:dry_run] => :environment do |_t, args|
    dry_run = true unless args[:dry_run] == 'false'

    puts("[#{Time.now.utc}] Running remove_orphan_blobs :: INI#{' (dry_run activated)' if dry_run}")

    Question.undefined.each do |question|
      puts("Updating tone for question id: #{question.id} title: #{question.title} #{' (dry_run activated)' if dry_run}")
      QuestionToneJob.perform_async(question.to_json) unless dry_run
    end

    puts("[#{Time.now.utc}] Running remove_orphan_blobs :: END#{' (dry_run activated)' if dry_run}")
  end

end
