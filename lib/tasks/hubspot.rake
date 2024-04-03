# frozen_string_literal: true

# lib/tasks/hubspot.rake

namespace :hubspot do
  desc 'Test retrieval of HubSpot'
  task test_retrieval: :environment do
    puts 'Retrieving HubSpot'
    Hubspot::AppService.retrieve_main
    puts 'Retrieval complete'
  end
end
