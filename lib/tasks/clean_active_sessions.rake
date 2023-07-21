# Description:
# A set of functions to be run periodically to clean up the Ative_Sessions table

namespace :clean_active_sessions do
  # Usage:
  #   - rake clean_active_sessions:clean
  #   - rake "clean_active_sessions:clean[false]"
  desc 'Remove session that are older than 20 days'
  task :clean, [:dry_run] => :environment do |_t, args|
    start_at= Time.now.utc
    failed_list = []
    session_count = 0
    dry_run = true unless args[:dry_run] == 'false'

    Rails.logger.error "[clean_active_sessions:clean] Starting at #{start_at}."
    puts("[#{Time.now.utc}] Running clean session :: INI#{' (dry_run activated)' if dry_run}")

    ActiveSession.where('active_sessions.created_at <= ?', 2.days.ago).find_each do |session|
      Rails.logger.error "[clean_active_sessions:clean] Deleting Session: #{session.id}#{' (dry_run activated)' if dry_run}."
      
      session.destroy! unless dry_run

      session_count += 1

    rescue StandardError => e
      failed_list.push({ session_id: session.id, reason: session.inspect })
        
      Rails.logger.error "[clean_active_sessions:clean] session_id: #{session.id} failed to update user name."
      Rails.logger.error "[clean_active_sessions:clean] session_id: #{session.id} failed reason: #{e.inspect}"
    end

    if failed_list.count > 0
      Rails.logger.info "[clean_active_sessions:clean] Failed list: #{failed_list}"
      p "[#{Time.now.utc}] [clean_active_sessions:clean] Failed list: #{failed_list}"
    end

    # End the task
    # Compute task duration
    end_at= Time.now.utc
    duration = ((end_at - start_at) / 60.seconds).to_i

    # Display closing messages and report to Rails logger for centralized logs
    Rails.logger.error "[clean_active_sessions:clean] Ending at #{end_at}. Sessions terminated: #{member_count} in #{duration}"
    puts("[#{Time.now.utc}] Running clean session :: END#{' (dry_run activated)' if dry_run}")
  end
end
