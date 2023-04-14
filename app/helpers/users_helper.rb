module UsersHelper

  def user_status(user)
    if user.invited && user.accepted_invitation_on.nil?
      # User is not confirmed
      return '<div class="h-2.5 w-2.5 rounded-full bg-blue-500 mr-2"></div> Invited'.html_safe
    end

    if !user.confirmed
      # User is not confirmed
      return '<div class="h-2.5 w-2.5 rounded-full bg-purple-500 mr-2"></div> Unconfirmed'.html_safe
    end

    if user.blocked
      # User is blocked on the platform
      return '<div class="h-2.5 w-2.5 rounded-full bg-red-500 mr-2"></div> Blocked'.html_safe
    end

    if user.locked
      # Too many failed logins -> The user is currently locked out of the platform
      return '<div class="h-2.5 w-2.5 rounded-full bg-orange-500 mr-2"></div> Locked'.html_safe
    end

    # If non of the above, the user is active
    return '<div class="h-2.5 w-2.5 rounded-full bg-green-500 mr-2"></div> Active'.html_safe
  end


  def user_roles(user)
    member = Member.find_by(user_id: user.id, organization: user.organization.id)
    if member.owner
      return '<span class="bg-blue-100 text-blue-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded-full dark:bg-blue-900 dark:text-blue-300">Owner</span>'.html_safe
    end
  end
end
