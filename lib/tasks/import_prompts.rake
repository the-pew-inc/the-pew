require 'octokit'
require 'base64'
require 'json'

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

    # Decode the base64 string
    decoded_content = Base64.decode64(file_content)

    # Parse the YAML data
    prompts_data = YAML.safe_load(decoded_content)

    prompts_data.each do |prompt_key, prompt_data|
      label = prompt_data['label']
      organization_id = prompt_data['organization_id']
      
      prompt = Prompt.find_or_initialize_by(label: label, organization_id: organization_id)

      prompt.title = prompt_data['title']
      prompt.model = prompt_data['model']
      prompt.messages = parse_messages(prompt_data['messages'])
      prompt.functions = parse_functions(prompt_data['functions'])
      prompt.function_call = prompt_data['function_call']

      if prompt.persisted?
        prompt.save
        puts "Prompt with label '#{prompt.label}' updated successfully."
      else
        prompt.save
        puts "Prompt with label '#{prompt.label}' imported successfully."
      end
    end
  end

  # Parse the messages field based on the format
  def self.parse_messages(messages)
    if messages.is_a?(Array)
      # Newer format with separate roles and content for each message
      parsed_messages = []
      messages.each do |message|
        parsed_messages << {
          role: message['role'],
          content: message['content']
        }
      end
      parsed_messages.to_json
    else
      # Older format with a single prompt message
      [{ role: 'prompt', content: messages }].to_json
    end
  end

  # Parse the functions field
  def self.parse_functions(functions)
    return nil if functions.nil?

    parsed_functions = []

    functions.each do |function|
      parsed_functions << {
        name: function['name'],
        description: function['description'],
        parameters: function['parameters']
      }
    end

    parsed_functions.to_json
  end
end
