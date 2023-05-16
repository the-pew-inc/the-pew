# == Schema Information
#
# Table name: subscriptions
#
#  id                   :uuid             not null, primary key
#  active               :boolean          default(FALSE), not null
#  current_period_end   :date
#  current_period_start :date
#  period               :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  organization_id      :uuid             not null
#  stripe_id            :string
#
# Indexes
#
#  index_subscriptions_on_active              (active)
#  index_subscriptions_on_current_period_end  (current_period_end)
#  index_subscriptions_on_organization_id     (organization_id)
#  index_subscriptions_on_period              (period)
#  index_subscriptions_on_stripe_id           (stripe_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Subscription < ApplicationRecord
  belongs_to :organization
  has_many   :subcription_transactions
end
