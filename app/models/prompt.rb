# == Schema Information
#
# Table name: prompts
#
#  id              :uuid             not null, primary key
#  function_call   :string
#  functions       :text
#  label           :string(50)       not null
#  messages        :text             not null
#  model           :string
#  title           :string(150)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid
#
# Indexes
#
#  index_prompts_on_label_and_organization_id  (label,organization_id) UNIQUE
#  index_prompts_on_model                      (model)
#  index_prompts_on_organization_id            (organization_id)
#
class Prompt < ApplicationRecord
  validates :label,    presence: true, length: { minimum: 3, maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :title,    presence: true, length: { minimum: 3, maximum: 150 }
  validates :messages, presence: true

  # Prompts table is used to saved prompts that are used by AI to extract critical information.
  # labels is the name of the prompt
  # title is a short description of the prompts
  # message is formatted as openAI message

  # Retrieves the messages with dynamic parameter replacement
  #
  # @param params [Hash] The parameters used to replace placeholders in the message
  # @return [String] The message with placeholders replaced by corresponding parameter values
  def get_messages(params = {})
    replaced_messages = messages.dup
  
    params.each do |key, value|
      escaped_value = value.to_s.gsub(/["\\]/, '\\\\\0')
      replaced_messages.gsub!("%{#{key}}", escaped_value)
    end
  
    replaced_messages
  end  

end
