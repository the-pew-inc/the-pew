class EventPolicy < ApplicationPolicy
  def show?
    universal_or_owner_admin? || user_belongs_to_organization?
  end

  def update?
    universal_or_owner_admin? || user_belongs_to_organization?
  end

  def destroy?
    universal_or_owner_admin? || user_belongs_to_organization?
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
      if user.has_role?(:admin, user.organization) || user.member.owner?
        # Case 1: User is an owner or an organization admin
        org_events_ids = scope.where(organization_id: user.member.organization_id).pluck(:id)
        admin_events_ids = Event.with_role(:admin, user).pluck(:id)
        scope.where(id: org_events_ids + admin_events_ids)
      else
        # Case 2: User is neither an owner nor an organization admin
        user_events_ids = scope.where(user_id: user.id).pluck(:id)
        admin_events_ids = Event.with_role(:admin, user).pluck(:id)
        scope.where(id: user_events_ids + admin_events_ids)
      end
    end
  end

  private

  def universal_or_owner_admin?
    if record.universal? || user_is_owner_or_admin?
      true
    else
      false
    end
  end

  def user_is_owner_or_admin?
    if user 
      user.has_role?(:admin, record.organization) || 
      record.organization.members.where(user_id: user.id, owner: true).exists?
    else
      false
    end
  end

  def user_belongs_to_organization?
    if record.restricted?
      user.organization_id == record.organization_id
    else
      true
    end
  end

  def user_created_event?
    if user
      record.user_id == user.id
    else
      false
    end
  end
end
