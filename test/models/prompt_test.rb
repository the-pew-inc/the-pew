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
require 'test_helper'

class PromptTest < ActiveSupport::TestCase
  def setup
    @prompt = prompts(:one)
  end

  test "should be valid with valid attributes" do
    assert @prompt.valid?
  end

  test "should not be valid without a label" do
    @prompt.label = nil
    assert_not @prompt.valid?
  end

  test "should not be valid with a label shorter than 3 characters" do
    @prompt.label = "ab"
    assert_not @prompt.valid?
  end

  test "should not be valid with a label longer than 50 characters" do
    @prompt.label = "a" * 51
    assert_not @prompt.valid?
  end

  test "should not be valid with a duplicate label (case-insensitive)" do
    duplicate_prompt = @prompt.dup
    duplicate_prompt.label = @prompt.label.upcase
    @prompt.save
    assert_not duplicate_prompt.valid?
  end

  test "should not be valid without a title" do
    @prompt.title = nil
    assert_not @prompt.valid?
  end

  test "should not be valid with a title shorter than 3 characters" do
    @prompt.title = "ab"
    assert_not @prompt.valid?
  end

  test "should not be valid with a title longer than 50 characters" do
    @prompt.title = "a" * 51
    assert_not @prompt.valid?
  end
end

