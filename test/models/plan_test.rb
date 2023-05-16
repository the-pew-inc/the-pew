# == Schema Information
#
# Table name: plans
#
#  id                :uuid             not null, primary key
#  active            :boolean          not null
#  currency          :string           default("USD"), not null
#  features          :jsonb            not null
#  label             :string           not null
#  price             :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  stripe_product_id :string
#  subscription_id   :uuid             not null
#
# Indexes
#
#  index_plans_on_active             (active)
#  index_plans_on_currency           (currency)
#  index_plans_on_stripe_product_id  (stripe_product_id)
#  index_plans_on_subscription_id    (subscription_id)
#
# Foreign Keys
#
#  fk_rails_...  (subscription_id => subscriptions.id)
#
require "test_helper"

class PlanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
