class EventPolicy < ApplicationPolicy
  def show?
    user_is_owner_or_admin? || user_created_event? || user.has_role?(:admin, record)
  end

  def update?
    show?
  end

  def destroy?
    user_is_owner_or_admin? || user_created_event?
  end

  def index?
    user_is_owner_or_admin? || user_created_event? || user.has_role?(:admin, record)
  end

  def stats?
    index?
  end

  def export?
    index?
  end

  alias_method :edit?, :update?

  class Scope < Scope
    def resolve
      if user.has_role?(:admin, scope.first.organization) || scope.first.organization.members.where(user: user, owner: true).exists?
        scope.all
      else
        scope.where(user_id: user.id).or(scope.with_role(:admin, user))
      end
    end
  end

  private

  def user_is_owner_or_admin?
    user.has_role?(:admin, record.organization) || 
    record.organization.members.where(user_id: user.id, owner: true).exists?
  end

  def user_created_event?
    record.user_id == user.id
  end
end
