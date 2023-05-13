class UserPolicy < ApplicationPolicy
  
  def index?
    allowed?
  end

  def delete_user?
    allowed?
  end

  def resend_invite?
    allowed?
  end

  def block?
    allowed?
  end

  def unlock?
    allowed?
  end

  def bulk_update?
    allowed?
  end

  def search_users?
    allowed?
  end

  private

  def allowed?
    user.has_role?(:admin, record.organization) || record.member.owner?
  end
end