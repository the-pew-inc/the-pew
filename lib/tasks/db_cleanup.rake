# Description:
# A set of functions to be run periodically to clean up the database (postgres)

namespace :db_cleanup do

  # Usage:
  #   - rake db_cleanup:remove_orphan_members_and_accounts
  #   - rake "db_cleanup:remove_orphan_members_and_accounts[false]"
  desc 'Remove accounts that have no user'
  task :remove_orphan_members_and_accounts, [:dry_run] => :environment do |_t, args|
    dry_run = true unless args[:dry_run] == 'false'

    puts("[#{Time.now.utc}] Running remove_orphan_members_and_accounts :: INI#{' (dry_run activated)' if dry_run}")

    # List all the rows in members which do not have a matching user
    # In order to avoid deleting objects that are freshly created and might still be in review
    # it has been decided to only check objects for which the created_at value is greater or equal
    # to 7 days from the current date.
    @members = Member.where("created_at >= ?", 7.days.ago).where.not(user_id: User.select(:id))

    @members.each do |member|
      # Delete the orphan account
      Account.destroy!(member.id)

      # Delete the orphan member entry
      Member.destroy!(member.id)
    end
    

    puts("[#{Time.now.utc}] Running remove_orphan_members_and_accounts :: END#{' (dry_run activated)' if dry_run}")
  end

  # Usage:
  #   - rake db_cleanup:remove_orphan_accounts
  #   - rake "db_cleanup:remove_orphan_accounts[false]"
  desc 'Remove accounts that have no user'
  task :remove_orphan_accounts, [:dry_run] => :environment do |_t, args|
    dry_run = true unless args[:dry_run] == 'false'

    puts("[#{Time.now.utc}] Running remove_orphan_accounts :: INI#{' (dry_run activated)' if dry_run}")

    # List all the rows in members which do not have a matching user
    # In order to avoid deleting objects that are freshly created and might still be in review
    # it has been decided to only check objects for which the created_at value is greater or equal
    # to 7 days from the current date.
    @accounts = Account.where("created_at >= ?", 7.days.ago).where.not(account_id: Member.select(:account_id))

    @accounts.each do |account|
      # Delete the orphan account
      Account.destroy!(account.id)
    end
    

    puts("[#{Time.now.utc}] Running remove_orphan_accounts :: END#{' (dry_run activated)' if dry_run}")
  end


  # Usage:
  #   - rake db_cleanup:remove_orphan_members
  desc "Remove members without a matching user"
  task remove_orphan_members: :environment do
    batch_size = 1000

    # Fetch all member ids that don't have a matching user
    orphan_members = Member.left_outer_joins(:user).where(users: { id: nil })

    # Remove orphan members in batches
    removed_count = 0
    orphan_members.in_batches(of: batch_size) do |batch|
      removed_count += batch.delete_all
    end

    # Output the number of removed members
    puts "#{removed_count} orphan members removed."
  end

end
