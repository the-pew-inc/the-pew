# == Schema Information
#
# Table name: food_for_thoughts
#
#  id              :uuid             not null, primary key
#  sponsored       :boolean          default(FALSE), not null
#  sponsored_by    :string
#  sponsored_utm   :string
#  summary         :string           not null
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
#  index_food_for_thoughts_on_sponsored        (sponsored)
#  index_food_for_thoughts_on_sponsored_by     (sponsored_by)
#
require "test_helper"

class FoodForThoughtTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
