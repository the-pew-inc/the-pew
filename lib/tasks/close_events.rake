# Description:
# A rake task to close events that are required close after a certain time

namespace :close_events do

  # Usage:
  #   - rake close_events:close_events
  #   - rake "close_events:close_events[false]"
  desc 'Close events'
  task :close_events, [:dry_run] => :environment do |_t, args|
    dry_run = true unless args[:dry_run] == 'false'

    puts("[#{Time.now.utc}] Running close_events :: INI#{' (dry_run activated)' if dry_run}")

    # List all the opened events and can be closed, meaning the always_on flag is set to false
    # Only event with a status of `opened` are affected.
    # Current rule is to close an event 24h after its end_date.
    @events = Event.where("always_on = false AND end_date < ?", 1.days.ago).opened

    @events.each do |event|
      # Closing the event
      event.closed!

      # Removing the PIN
      event.pin = nil

      # Removing the QR code
      event.qr_code.purge
    end
    
    puts("[#{Time.now.utc}] Running close_events :: END#{' (dry_run activated)' if dry_run}")
  end

end
