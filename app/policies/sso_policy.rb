# frozen_string_literal: true

# app/policies/sso_policy.rb

class SsoPolicy
  attr_reader :user, :organization

  def initialize(user, organization)
    @user = user
    @organization = organization
  end

  def allowed?
    user.organization.active_subscription? && user.has_role?(:allowed_role, organization)
  end
end
