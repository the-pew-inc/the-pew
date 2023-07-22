# Description:
# A rake task to close events that are required close after a certain time

namespace :close_events do

  # Usage:
  #   - rake close_events:close_events
  #   - rake "close_events:close_events[false]"
  desc 'Close events'
  task :close_events, [:dry_run] => :environment do |_t, args|
    start_at= Time.now.utc
    dry_run = true unless args[:dry_run] == 'false'
    failed_list = []
    event_closed_count = 0

    Rails.logger.error "[close_events] Starting at #{start_at}."
    puts("[#{Time.now.utc}] Running close_events :: INI#{' (dry_run activated)' if dry_run}")

    # List all the opened events and can be closed, meaning the always_on flag is set to false
    # Only event with a status of `opened` are affected.
    # Current rule is to close an event 24h after its end_date.
    @events = Event.where("always_on = false AND end_date < ?", 1.days.ago).opened

    puts("[#{Time.now.utc}] Events to be closed: #{@events.count}")
    
    # If there is no event to be closed we simply exit the task.
    if @events.count > 0 then
      @events.each do |event|
        # Closing the event
        event.closed!
  
        # Removing the PIN
        event.pin = nil

        # Updating the event
        event.update!

        # Update the counter
        event_closed_count += 1

      # Rescue used to log errors and report to Rails looger
      rescue StandardError => e
        failed_list.push({ event_id: event.id, reason: event.inspect })
          
        Rails.logger.error "[close_events] event_id: #{event.id} failed to update user name."
        Rails.logger.error "[close_events] event_id: #{event.id} failed reason: #{e.inspect}"
      end

      if failed_list.count > 0
        Rails.logger.info "[close_events] Failed list: #{failed_list}"
        p "[#{Time.now.utc}] [close_events] Failed list: #{failed_list}"
      end

      puts("[#{Time.now.utc}] #{event_closed_count} events have been closed")
    end

    # End the task
    # Compute task duration
    end_at= Time.now.utc
    duration = ((end_at - start_at) / 60.seconds).to_i
    # Display closing messages and report to Rails logger for centralized logs
    Rails.logger.error "[close_events] Ending at #{end_at}. Closed #{event_closed_count} event(s) in #{duration}"
    puts("[#{Time.now.utc}] Running close_events :: duration: #{duration} :: END#{' (dry_run activated)' if dry_run}")
    puts("[#{Time.now.utc}] Running close_events :: END#{' (dry_run activated)' if dry_run}")
  end

end
