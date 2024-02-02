# frozen_string_literal: true

# lib/tasks/stripe_sync.rake

# Description:
# A set of tasks to synchronize data from Stripe to the database.

namespace :stripe_sync do
  desc 'Synchronize plans from Stripe'
  task sync_plans: :environment do
    Stripe::Product.list(active: true).each do |stripe_product|
      # puts '=== Product: '
      # puts "#{stripe_product.inspect}"

      # Fetching plans associated with the product
      Stripe::Plan.list(product: stripe_product.id, active: true).each do |stripe_plan|
        # puts '=== Plan: '
        # puts "#{stripe_plan.inspect}"

        plan = Plan.find_or_initialize_by(stripe_product_id: stripe_product.id)

        stripe_price_mo_id = plan.stripe_price_mo || nil
        stripe_price_y_id = plan.stripe_price_y || nil
        monthly_price = plan.price_mo
        yearly_price = plan.price_y

        case stripe_plan.interval
        when 'month'
          stripe_price_mo_id = stripe_plan.id
          monthly_price = stripe_plan.amount / 100.0 if stripe_plan.amount
        when 'year'
          stripe_price_y_id = stripe_plan.id
          yearly_price = stripe_plan.amount / 100.0 if stripe_plan.amount
        else
          # Handle unexpected interval value
          puts("Warning: Unexpected interval value '#{stripe_plan.interval}' for Stripe plan ID #{stripe_plan.id}")
        end

        # Update the plan details
        plan.update!(
          label: stripe_product.name,
          price_mo: monthly_price,
          price_y: yearly_price,
          stripe_price_mo: stripe_price_mo_id,
          stripe_price_y: stripe_price_y_id,
          active: stripe_plan.active,
          features: { access_support: true }
          # Add other attributes as needed
        )
      end
    end
    puts 'Stripe plans synchronized successfully.'
  end
end
