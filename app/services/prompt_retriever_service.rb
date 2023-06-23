# app/services/prompt_retriever_service.rb
module PromptRetrieverService

  # Retrieve the title and prompt for a given label and organization ID (with fallback)
  #
  # @param label [String] The label of the prompt to retrieve
  # @param organization_id [String, nil] The organization ID (optional)
  # @return [Hash, nil] A hash with :title and :prompt if a prompt is found, nil otherwise
  def self.retrieve(label, organization_id = nil)
    prompt = Prompt.find_by(label: label, organization_id: organization_id)

    # Fallback in case we have no prompt when passing a label AND an organization_id
    if organization_id && prompt.nil?
      prompt = Prompt.find_by(label: label, organization_id: nil)
    end

    return unless prompt

    {
      title: prompt.title,
      prompt: prompt.prompt
    }
  end
end
