class ResourceInviteJob
  include Sidekiq::Job

  # ResourceInviteJob's perform method.
  #
  # This method is responsible for processing invitations based on the provided
  # parameters. It parses the JSON representations of invited users and the resource,
  # then processes each invited user based on their type (group, new_email, user, invite).
  # For each valid invitation, it creates a ResourceInvite record and sends an email invitation.
  #
  # @param invited_users_json [String] A JSON string representation of the users to be invited.
  #   Expected format:
  #   [
  #     {"type": "user", "id": "some-uuid", "label": "some-label"},
  #     ...
  #   ]
  #
  # @param sender_id [String] The UUID of the user who initiated the invitation.
  #
  # @param resource_json [String] A JSON string representation of the resource to which users are invited.
  #   Expected format:
  #   {
  #     "title": "some title",
  #     "invitable_id": "some-uuid",
  #     "invitable_type": "Poll" // or "Event", "Survey", etc.
  #   }
  #
  # @return [void]
  #
  # @raise [JSON::ParserError] If there's an issue parsing the JSON strings.
  # @raise [ActiveRecord::RecordNotFound] If a user or group is not found in the database.
  def perform(invited_users, sender_id, resource)
    invited_users = JSON.parse(invited_users)
    resource      = JSON.parse(resource)
    
    # Fetching the user who initiated the invitation: aka sender
    @sender = User.find(sender_id)
    
    invited_users.each do |invited|
      case invited['type']
      when 'group'
        group_invite(invited['id'], resource)
      when 'new_email'
        email = invited['label']
        if valid_email?(email)
          invitation = ResourceInvite.create(email: email, 
            group_id: nil,
            invitable_id: resource['invitable_id'],
            invitable_type: resource['invitable_type'],
            organization_id: @sender.organization.id, 
            recipient_id: nil, 
            sender_id: @sender.id)
          send_invite(resource, invitation)
        end
      when 'user'
        user = User.find(invited['id'])
        if user
          invitation = ResourceInvite.create(email: user.email, 
            group_id: nil,
            invitable_id: resource['invitable_id'],
            invitable_type: resource['invitable_type'],
            organization_id: @sender.organization.id, 
            recipient_id: user.id, 
            sender_id: @sender.id)
          send_invite(resource, invitation)
        end
      when 'invite'
        email = invited['label']
        if valid_email?(email)
          invitation = ResourceInvite.create(email: email, 
            group_id: nil,
            invitable_id: resource['invitable_id'],
            invitable_type: resource['invitable_type'],
            organization_id: @sender.organization.id, 
            recipient_id: nil, 
            sender_id: @sender.id)
          send_invite(resource, invitation)
        end
      else
        Rails.logger.error "Unsupported invite type #{invited['type']}"
      end
    end
  end

  private

  def send_invite(resource, invitation)
    resource['email'] = invitation['email'] # Email receiving the invitation
    resource['nickname'] = @sender.profile.nickname # Name of the person inviting (sender)

    # Serializing the JSON &
    # Sending to the mailer for async processing
    ResourceInviteMailer.invite(resource.to_json).deliver_later
  end

  def group_invite(group_id, resource)
    group = Group.find(group_id)
    
    if group
      group_memberships = group.group_memberships
        
      group_memberships.each do |membership|
        user = membership.user
        # Create ResourceInvite for this user with polymorphic association
        invitation = ResourceInvite.create(email: user.email, 
                              group_id: group_id,
                              invitable_id: resource['invitable_id'],
                              invitable_type: resource['invitable_type'],
                              organization_id: @sender.organization.id, 
                              recipient_id: user.id, 
                              sender_id: @sender.id)
        # Send the invitation email to the invited user
        send_invite(resource, invitation)
      end
    end
  end

  # @param email [String] Email address to validate.
  # @return [Boolean] true if the email is valid, false otherwise.
  def valid_email?(email)
    # A basic email regex to check if email format is valid
    email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  end
end
