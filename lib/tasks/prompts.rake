require 'aws-sdk-s3'

namespace :prompts do

  # Usage:
  #   Used to upload the a .yml file contaning the prompts to be uploaded to the 
  #   prompts table to a bucket.
  #   - rake "prompts:upload_with_path[db/seeds/my_prompts.yml]"
  desc "Upload and update prompts from a specified .yml file"
  task :upload_with_path, [:filepath] => :environment do |_, args|
    filepath = args[:filepath] || 'prompts.yml'

    prompts_data = YAML.load_file(Rails.root.join(filepath))

    # Connect to the DigitalOcean Space
    s3_client = Aws::S3::Client.new(
      region: 'your_space_region',
      access_key_id: 'your_access_key',
      secret_access_key: 'your_secret_access_key',
      endpoint: 'https://your_space_name.your_space_region.digitaloceanspaces.com'
    )

    # Upload the prompts file to the DigitalOcean Space
    s3_client.put_object(
      bucket: 'your_space_name',
      key: File.basename(filepath),
      body: YAML.dump(prompts_data)
    )

    puts "Uploaded prompts from #{filepath} to DigitalOcean Space"
  end

  # Usage:
  #   Used to upload the a .yml file contaning the prompts to be uploaded to the 
  #   prompts table to a bucket.
  #   - rake "prompts:import_from_space[filepath]"
  desc "Create or update prompts from a YAML file"
  task :import_from_space, [:filepath] => :environment do |_, args|
    filepath = args[:filepath] || 'prompts.yml'

    # Connect to the DigitalOcean Space
    s3_client = Aws::S3::Client.new(
      region: 'your_space_region',
      access_key_id: 'your_access_key',
      secret_access_key: 'your_secret_access_key',
      endpoint: 'https://your_space_name.your_space_region.digitaloceanspaces.com'
    )

    # Retrieve the prompts file from the DigitalOcean Space
    file_response = s3_client.get_object(bucket: 'your_space_name', key: filepath)
    prompts_data = YAML.load(file_response.body.read)

    prompts_created = 0
    prompts_updated = 0

    prompts_data.each do |label, prompt_data|
      prompt = Prompt.find_or_initialize_by(label: label)
      if prompt.new_record?
        prompts_created += 1
      else
        prompts_updated += 1
      end
      prompt.update(prompt_data)
    end

    puts "Prompts imported from DigitalOcean Space: #{filepath}"
    puts "Prompts created: #{prompts_created}"
    puts "Prompts updated: #{prompts_updated}"
  end
  
end
