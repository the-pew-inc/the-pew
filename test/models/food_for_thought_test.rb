# == Schema Information
#
# Table name: food_for_thoughts
#
#  id              :uuid             not null, primary key
#  sponsor_url     :string
#  sponsored       :boolean          default(FALSE), not null
#  sponsored_by    :string
#  sponsored_utm   :string
#  summary         :string
#  title           :string           not null
#  url             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  event_id        :uuid
#  organization_id :uuid
#
# Indexes
#
#  index_food_for_thoughts_on_event_id         (event_id)
#  index_food_for_thoughts_on_organization_id  (organization_id)
#  index_food_for_thoughts_on_sponsor_url      (sponsor_url)
#  index_food_for_thoughts_on_sponsored        (sponsored)
#  index_food_for_thoughts_on_sponsored_by     (sponsored_by)
#

# test/models/food_for_thought_test.rb
require "test_helper"
require "active_job/test_helper"

class FoodForThoughtTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @food_for_thought_one = food_for_thoughts(:one)
    @food_for_thought_two = food_for_thoughts(:two)
  end

  test "validates presence of title" do
    food_for_thought = food_for_thoughts(:one)
    food_for_thought.title = nil

    assert_not food_for_thought.valid?
    assert_includes food_for_thought.errors[:title], "can't be blank"
  end

  test "validates presence of summary" do
    food_for_thought = food_for_thoughts(:one)
    food_for_thought.summary = nil

    assert_not food_for_thought.valid?
    assert_includes food_for_thought.errors[:summary], "can't be blank"
  end

  test "validates URL format" do
    food_for_thought = food_for_thoughts(:one)
    food_for_thought.url = "invalid-url"

    assert_not food_for_thought.valid?
    assert_includes food_for_thought.errors[:url], "is not a valid URL"

    food_for_thought.url = "https://example.com"

    assert food_for_thought.valid?
  end

  test "validates presence of either URL or article" do
    food_for_thought = FoodForThought.new(title: "My Food for Thought")
    food_for_thought.valid?
    assert_not_includes food_for_thought.errors[:base], "URL and article cannot both be present"
  end
end
