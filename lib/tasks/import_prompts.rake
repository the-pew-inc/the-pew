# lib/tasks/import_prompts.rake
require 'octokit'

namespace :prompts do
  desc "Import prompts from YAML file in a private GitHub repository"
  task import: :environment do
    # Retrieves prompts from a YAML file in a private GitHub repository and imports them into the database.

    # Environment Variables:
    #   - GITHUB_REPO: The repository name in the format 'username/repo'.
    #   - FILE_PATH: The path to the YAML file in the repository.
    #   - GITHUB_TOKEN: Personal access token with repo access for authentication.

    # Usage: 
    # rake prompts:import
    # GITHUB_REPO=your_username/your_repo FILE_PATH=path/to/your_file.yaml GITHUB_TOKEN=your_github_token rake prompts:import

    repository = ENV['GITHUB_REPO'] || raise("Repository not provided. Please set the 'GITHUB_REPO' environment variable.")
    file_path = ENV['FILE_PATH'] || raise("File path not provided. Please set the 'FILE_PATH' environment variable.")
    github_token = ENV['GITHUB_TOKEN'] || raise("GitHub token not provided. Please set the 'GITHUB_TOKEN' environment variable.")

    client = Octokit::Client.new(access_token: github_token)
    file_content = client.contents(repository, path: file_path).content
    prompts_data = YAML.safe_load(Base64.decode64(file_content))

    prompts_data.each do |prompt_data|
      prompt = Prompt.new(
        label: prompt_data['label'],
        title: prompt_data['title'],
        organization_id: prompt_data['organization_id'],
        model: prompt_data['model'],
        messages: prompt_data['messages'],
        functions: prompt_data['function'],
        function_call: prompt_data['function_call']
      )

      if prompt.save
        puts "Prompt with label '#{prompt.label}' imported successfully."
      else
        puts "Failed to import prompt with label '#{prompt.label}'. Errors: #{prompt.errors.full_messages.join(', ')}"
      end
    end
  end
end

