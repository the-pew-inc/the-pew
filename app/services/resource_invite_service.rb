# app/services/resource_invite_service.rb
class ResourceInviteService
  attr_reader :invited_users, :resource, :sender

  def initialize(invited_users, sender_id, resource)
    @invited_users = invited_users # Serialized JSON
    @resource      = resource      # this could be a Poll, Survey, Event, etc.
    @sender_id     = sender_id     # User sending the invitation (should be current_user)
    generateResourceJSON()
  end

  # Used in the create method of a resource controller
  def create
    if !@resource.universal?
      # Sending the task to a Sidekiq job [Model must be formatted as JSON]
      # @invited_users is already a JSON at this stage.
      ResourceInviteJob.perform_async(@invited_users, @sender_id, @resource_json)
    end
  end

  # Used in the update method of a resource controller
  def update
    if JSON.parse(@invited_users).count > 0
      # Sending the task to a Sidekiq job [Model must be formatted as JSON]
      # What the job does:
      # * Check for new user(s) and send proper invitation(s)
      # * Check for removed user(s) and remove them from the ResourceInvite
      if !@resource.universal?
        ResourceInviteUpdateJob.perform_async(@invited_users, @sender_id, @resource_json)
      end
    else
      # The user removed all invitations ;-)
      ResourceInvite.destroy_all(invitable: @resource)
    end
  end

  private

  def getResourceTitle
    case @resource.class.name
    when 'Event'
      @resource.name
    when 'Poll', 'Survey'
      @resource.title
    else
      Rails.logger.error "Cannot extract name or title from: #{@resource.class.name} / Unsupported resource type"
    end
  end

  def generateResourceJSON
    @resource_json = {
            "title": getResourceTitle(),
            "invitable_id": @resource.id,
            "invitable_type": @resource.class.name
    }.to_json
  end
  
end
