# frozen_string_literal: true

# app/policies/import_policy.rb

class ImportPolicy
  attr_reader :user, :organization

  def initialize(user, organization)
    @user = user
    @organization = organization
  end

  def allowed?
    user.organization.active_subscription? && user.has_role?(:allowed_role, organization)
  end
end
