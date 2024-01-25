# This defines the generic policies applies to a resource (Poll, Event, Room, Survey, etc.)
# At the moment Event are not fully aligned with the new convention and may remain outside
# of this generic policy.

class ResourcePolicy < ApplicationPolicy
  # As a user I can access the resources I created and I have been made admin on.
  def show?
    user_is_resource_creator_or_admin? ||
      resource_is_universal? ||
      (resource_is_restricted? && (user_belongs_to_organization? || user_invited_to_resource?)) ||
      (resource_is_invite_only? && user_invited_to_resource?)
  end

  # As a user I can delete the resources I created.
  def destroy?
    user_is_resource_creator?
  end

  # As a user I can edit the resource I created or I have been made admin on.
  def update?
    user_is_resource_creator_or_admin? && user_has_active_subscription?
  end

  def edit?
    update? && user_has_active_subscription?
  end

  # Depending on the resource the method may differ, but we need something generic to let a user list the resources the user created or is admin on.
  # This will likely need more context to be fully fleshed out.
  # For now, let's assume there's a common field named "user_id" on the resources that maps to the creator.
  def index?
    user_is_resource_creator_or_admin?
  end

  def new?
    user_has_active_subscription?
  end

  private

  def user_is_resource_creator_or_admin?
    user_is_resource_creator? || user_has_role?(:admin, record)
  end

  def user_is_resource_creator?
    record.respond_to?(:user_id) && user&.id == record.user_id
  end

  def user_has_role?(role, resource)
    user&.has_role?(role, resource)
  end

  def user_belongs_to_organization?
    user&.organization_id == record.organization_id
  end

  def resource_is_universal?
    record.respond_to?(:universal?) && record.universal?
  end

  def resource_is_restricted?
    record.respond_to?(:restricted?) && record.restricted?
  end

  def resource_is_invite_only?
    record.respond_to?(:invite_only?) && record.invite_only?
  end

  def user_invited_to_resource?
    ResourceInvite.exists?(
      invitable: record,
      email: user.email
    )
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      # Resources that the user created
      resources_created_by_user = scope.where(user_id: user.id)

      # Resources for which the user has been granted the admin role
      roles = user.roles.where(name: 'admin', resource_type: scope.name)
      resource_ids_user_is_admin_on = roles.map(&:resource_id)
      resources_user_is_admin_on = scope.where(id: resource_ids_user_is_admin_on)

      # Combine both sets of resources
      combined_resources = resources_created_by_user.or(resources_user_is_admin_on)

      # Order and eagerly load associated users
      combined_resources.order(created_at: :desc).includes(:user)
    end
  end
end
