# == Schema Information
#
# Table name: subscriptions
#
#  id                     :uuid             not null, primary key
#  active                 :boolean          default(FALSE), not null
#  current_period_end     :date
#  current_period_start   :date
#  period                 :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  organization_id        :uuid             not null
#  plan_id                :uuid             not null
#  stripe_subscription_id :string
#
# Indexes
#
#  index_subscriptions_on_active                  (active)
#  index_subscriptions_on_current_period_end      (current_period_end)
#  index_subscriptions_on_organization_id         (organization_id)
#  index_subscriptions_on_period                  (period)
#  index_subscriptions_on_plan_id                 (plan_id)
#  index_subscriptions_on_stripe_subscription_id  (stripe_subscription_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (plan_id => plans.id)
#
require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
