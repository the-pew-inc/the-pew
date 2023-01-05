# Description:
# A set of functions to be to clean the cache
# Example: this can be run as part of a job after deploying a new version to production

namespace :clean_cache do

  # Usage:
  #   - rake clean_cache:clear
  desc "Clearing Rails cache"
  task :clear => :environment do
    Rails.cache.clear
  end
end
