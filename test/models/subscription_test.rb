# == Schema Information
#
# Table name: subscriptions
#
#  id                   :uuid             not null, primary key
#  active               :boolean          default(FALSE), not null
#  current_period_end   :datetime
#  current_period_start :datetime
#  interval             :string           not null
#  status               :string           not null
#  stripe_plan          :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  customer_id          :string           not null
#  organization_id      :uuid             not null
#  subscription_id      :string
#
# Indexes
#
#  index_subscriptions_on_active              (active)
#  index_subscriptions_on_current_period_end  (current_period_end)
#  index_subscriptions_on_customer_id         (customer_id)
#  index_subscriptions_on_interval            (interval)
#  index_subscriptions_on_organization_id     (organization_id)
#  index_subscriptions_on_status              (status)
#  index_subscriptions_on_stripe_plan         (stripe_plan)
#  index_subscriptions_on_subscription_id     (subscription_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
