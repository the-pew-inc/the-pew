# frozen_string_literal: true

# app/models/concerns/subscribable.rb

module Subscribable
  extend ActiveSupport::Concern

  included do
    has_one :subscription
  end

  # Check if the organization has an active subscription
  def active_subscription?
    subscription.present? && subscription.active?
  end
end
