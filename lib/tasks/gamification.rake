# Description:
# A set of functions used to update the user profile and other gamification features
namespace :gamification do

  # Usage:
  #   - rake gamification:update_pewpoints
  #   - rake "gamification:update_pewpoints[false]"
  desc 'Update user PEW Points'
  task :update_pewpoints, [:dry_run] => :environment do |_t, args|
    dry_run = true unless args[:dry_run] == 'false'

    puts("[#{Time.now.utc}] Running update_pewpoints :: INI#{' (dry_run activated)' if dry_run}")

    # Get a list of users
    User.all.each do |user|
      # Set @pew_points value to 0 for this user
      pew_points = 0

      # List all non rejected question for that user
      user.questions.not_rejected.each do |question|
        # Add +1 for each asked question
        pew_points = pew_points + 1

        # Add +1 for each upvote
        votes = question.votes 
        if votes.count > 0
          c = votes.group(:choice).count
          pew_points = pew_points + c['up_vote']
        end
      end

      # Update the user's profile
      profile = user.profile
      profile.update!(pew_points: pew_points)

    end
    
    puts("[#{Time.now.utc}] Running update_pewpoints :: END#{' (dry_run activated)' if dry_run}")
  end

  
end
