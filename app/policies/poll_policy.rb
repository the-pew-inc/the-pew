class PollPolicy < ApplicationPolicy
  def show?
    user_created_poll_or_admin? || record.universal? || (record.restricted? && user_belongs_to_organization?)
  end

  def index?
    user_created_poll_or_admin? || user.organization.has_role?(:admin, user)
  end

  def update?
    user_created_poll_or_admin?
  end
  alias_method :destroy?, :update?

  private

  def user_created_poll_or_admin?
    user && (record.user_id == user.id || user.has_role?(:admin, record))
  end

  def user_belongs_to_organization?
    user.organization.id == record.organization_id
  end
end
