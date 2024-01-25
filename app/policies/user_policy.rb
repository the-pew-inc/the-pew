class UserPolicy < ApplicationPolicy
  def index?
    admin_or_owner?
  end

  def delete_user?
    admin_or_owner?
  end

  def resend_invite?
    admin_or_owner?
  end

  def block?
    admin_or_owner?
  end

  def unlock?
    admin_or_owner?
  end

  def bulk_update?
    admin_or_owner?
  end

  def search_users?
    admin_or_owner?
  end

  private

  def admin_or_owner?
    user_has_admin_role? || user_is_organization_owner?
  end

  def user_has_admin_role?
    user.has_role?(:admin, record.organization)
  end

  # Checking if the user (the one performing the action) is an owner of the organization
  # that the record (the user being acted upon) belongs to
  def user_is_organization_owner?
    organization = record.organization
    Member.where(user_id: user.id, organization_id: organization.id, owner: true).exists?
  end
end
