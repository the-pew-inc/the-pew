# frozen_string_literal: true

# app/policies/sso_policy.rb

class SsoPolicy < ApplicationPolicy
  # attr_reader :user, :organization

  # def initialize(user, organization)
  #   @user = user
  #   @organization = organization
  # end

  def allowed?
    # user_has_active_subscription? && user.has_role?(:admin, record)
    user_has_active_subscription?
  end
end
