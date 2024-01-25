# frozen_string_literal: true

class EventPolicy < ResourcePolicy
  def stats?
    user_created_event? || user.has_role?(:admin, record)
  end

  def export?
    user_created_event? || user.has_role?(:admin, record)
  end

  private

  def user_created_event?
    if user
      record.user_id == user.id
    else
      false
    end
  end
end
