# == Schema Information
#
# Table name: prompts
#
#  id              :uuid             not null, primary key
#  function        :string
#  label           :string(50)       not null
#  model           :string           default("gpt-3.5"), not null
#  prompt          :text             not null
#  title           :string(50)       not null
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
  validates :label, presence: true, length: { minimum: 3, maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :title, presence: true, length: { minimum: 3, maximum: 50 }

  # Prompts table is used to saved prompts that are used by AI to extract critical information.
  # labels is the name of the prompt
  # title is a short description of the prompts
  # prompt is the prompt ;-)
  # some organization may require specific prompts

end
