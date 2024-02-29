module ApplicationHelper
  def flash_bg_color(type)
    case type
    when 'alert'
      'bg-red-100'
    when 'notice'
      'bg-blue-100'
    else
      # TODO: report in system log
      'bg-green-100'
    end
  end

  def flash_text_color(type)
    case type
    when 'alert'
      'text-red-700'
    when 'notice'
      'text-blue-700'
    else
      # TODO: report in system log
      'text-green-700'
    end
  end

  def admin_or_owner?(user)
    user.organization_owner?(user.organization) || user.has_role?(:admin, user.organization)
  end

  # Used to return the current user's organization id
  # Use case: setting sidebar menu items
  def organization_id
    current_user.organization.id if user_signed_in?
  end

  def resource_status(resource)
    if resource.draft?
      # When the resource is still a draft
      return '<span class="bg-blue-100 text-blue-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded-full dark:bg-blue-900 dark:text-blue-300">draft</span>'.html_safe
    end

    if resource.published?
      # When the resource is published
      return '<span class="bg-purple-100 text-purple-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded-full dark:bg-purple-900 dark:text-purple-300">published</span>'.html_safe
    end

    if resource.opened?
      # When the resource is opened (accessible to others than its creator or admins)
      return '<span class="bg-green-100 text-green-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded-full dark:bg-green-900 dark:text-green-300">opened</span>'.html_safe
    end

    if resource.closed?
      # When the resource is closed
      return '<span class="bg-red-100 text-red-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded-full dark:bg-red-900 dark:text-red-300">closed</span>'.html_safe
    end

    if resource.archived?
      # When the resource is archived
      return '<span class="bg-orange-100 text-orange-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded-full dark:bg-orange-900 dark:text-orange-300">archived</span>'.html_safe
    end

    # Default in case we do not cover this type
    '<span class="bg-gray-100 text-gray-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded-full dark:bg-gray-900 dark:text-gray-300">?</span>'.html_safe
  end

  def resource_type(resource)
    if resource.universal?
      # User is not confirmed
      return '<span class="bg-sky-100 text-sky-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded-full dark:bg-sky-900 dark:text-sky-300">universal</span>'.html_safe
    end

    if resource.restricted?
      # User is not confirmed
      return '<span class="bg-blue-100 text-blue-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded-full dark:bg-blue-900 dark:text-blue-300">organization</span>'.html_safe
    end

    if resource.invite_only?
      # User is blocked on the platform
      return '<span class="bg-purple-100 text-purple-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded-full dark:bg-purple-900 dark:text-purple-300">invite only</span>'.html_safe
    end

    # If non of the above, the user is active
    '<span class="bg-red-100 text-red-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded-full dark:bg-red-900 dark:text-red-300">error</span>'.html_safe
  end
end
