# Description:
# A set of functions to be run periodically to clean up the Ative_Sessions table

namespace :clean_active_sessions do
  # Usage:
  #   - rake clean_active_sessions:clean
  #   - rake "clean_active_sessions:clean[false]"
  desc 'Remove session that are older than 20 days'
  task :clean, [:dry_run] => :environment do |_t, args|
    dry_run = true unless args[:dry_run] == 'false'

    puts("[#{Time.now}] Running clean session :: INI#{' (dry_run activated)' if dry_run}")

    ActiveSession.where('active_sessions.created_at <= ?', 20.days.ago).find_each do |session|
      puts("Deleting Session: #{session.id}#{' (dry_run activated)' if dry_run}")
      session.destroy! unless dry_run
    end

    puts("[#{Time.now}] Running clean session :: END#{' (dry_run activated)' if dry_run}")
  end
end
