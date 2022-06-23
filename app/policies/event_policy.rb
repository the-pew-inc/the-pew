class EventPolicy < ApplicationPolicy
  class Scope < Scope
    def update?
      user.id == current_user.id
    end

    def destroy?
      user.id == current_user.id
    end

  end
end
