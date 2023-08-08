# app/services/resource_invite_service.rb
class ResourceInviteService
  attr_reader :invited_users, :resource, :sender

  def initialize(invited_users, sender, resource)
    @invited_users = invited_users # Serialized JSON
    @resource = resource  # this could be a Poll, Survey, Event, etc.
    @sender = sender      # User sending the invitation (should be current_user)
  end

  # Used in the create method of a resource controller
  def create
    ResourceInviteJob.perform_async(@invited_users, @resource, @sender)
  end

  # Used in the update method of a resource controller
  def update
    if @invited_users.count > 0
      # Sending the task to a Sidekiq job
      # What the job does:
      # * Check for new user(s) and send proper invitation(s)
      # * Check for removed user(s) and remove them from the ResourceInvite
      ResourceInviteUpdateJob.perform_async(@invited_users, @resource, @sender)
    else
      # The user removed all invitations ;-)
      ResourceInvite.destroy_all(invitable: resource)
    end
  end
  
end
