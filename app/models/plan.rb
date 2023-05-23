# == Schema Information
#
# Table name: plans
#
#  id                :uuid             not null, primary key
#  active            :boolean          default(FALSE), not null
#  features          :jsonb            not null
#  label             :string           not null
#  max_seats         :integer          default(1), not null
#  min_seats         :integer          default(1), not null
#  price_mo          :decimal(10, 3)
#  price_y           :decimal(10, 3)
#  stripe_price_mo   :string
#  stripe_price_y    :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  stripe_product_id :string           not null
#
# Indexes
#
#  index_plans_on_active             (active)
#  index_plans_on_stripe_product_id  (stripe_product_id) UNIQUE
#
class Plan < ApplicationRecord
  
  validates :stripe_product_id, presence: true
end
