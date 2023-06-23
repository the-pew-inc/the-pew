require 'test_helper'
require_relative '../../app/services/prompt_retriever_service.rb'

class PromptRetrieverServiceTest < ActiveSupport::TestCase
  test "should retrieve prompt by label and organization ID" do
    prompt_data = PromptRetrieverService.retrieve("prompt-one-label", "8c5e36bb-6163-4d07-8a7e-9f13e77d6e40")
    assert_not_nil prompt_data
    assert_equal "Prompts one description", prompt_data[:title]
    assert_equal "A bogus prompt to be used for testing purpose only", prompt_data[:prompt]
  end

  test "should fallback to retrieve prompt without organization ID" do
    prompt_data = PromptRetrieverService.retrieve("prompt-two-label")
    assert_not_nil prompt_data
    assert_equal "Prompts two description", prompt_data[:title]
    assert_equal "A bogus prompt to be used for testing purpose only and this is for prompts two so we do not have any organization", prompt_data[:prompt]
  end

  test "should return nil when prompt is not found" do
    prompt_data = PromptRetrieverService.retrieve("non-existent-label", "8c5e36bb-6163-4d07-8a7e-9f13e77d6e40")
    assert_nil prompt_data
  end
end
