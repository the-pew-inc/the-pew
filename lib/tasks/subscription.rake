# frozen_string_literal: true

# lib/tasks/subscriptions.rake

namespace :subscriptions do
  desc 'Create a subscription'
  task :create, %i[organization_id subscription_id] => :environment do |_task, args|
    # Ensures both arguments are present
    raise ArgumentError, 'Missing organization_id' unless args[:organization_id].present?
    raise ArgumentError, 'Missing subscription_id' unless args[:subscription_id].present?

    organization_id = args[:organization_id]
    subscription_id = args[:subscription_id]

    # Create a new subscription with default values
    subscription = Subscription.create(
      organization_id:,
      subscription_id:,
      customer_id: SecureRandom.uuid,
      stripe_plan: 'plan_Go3J712345678901234567890',
      status: 'active',
      interval: 'monthly',
      active: true,
      current_period_start: Time.zone.now,
      current_period_end: 1.month.from_now
    )

    if subscription.persisted?
      puts "Subscription (ID: #{subscription_id}) created successfully for Organization ID: #{organization_id}."
    else
      puts "Failed to create subscription: #{subscription.errors.full_messages.join(', ')}"
    end
  end
end
