# frozen_string_literal: true

# app/policies/import_policy.rb

class ImportPolicy < ApplicationPolicy
  # attr_reader :user, :organization

  # def initialize(user, organization)
  #   @user = user
  #   @organization = organization
  # end

  def allowed?
    # user_has_active_subscription? && user.has_role?(:admin, user.organization)
    user_has_active_subscription?
  end
end
