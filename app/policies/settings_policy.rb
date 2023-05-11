class SettingsPolicy < ApplicationPolicy
  def index?
    user.has_role?(:admin, record) || user.organization_owner?(record)
  end
end
