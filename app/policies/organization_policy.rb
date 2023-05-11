class OrganizationPolicy < ApplicationPolicy
  def show?
    user_is_owner? || user.has_role?(:admin, record)
  end

  def update?
    show?
  end

  alias_method :edit?, :update?

  def manage_users?
    user.has_role?(:admin, record) || user.member.owner?
  end

  private

  def user_is_owner?
    record.members.where(user: user, owner: true).exists?
  end
end