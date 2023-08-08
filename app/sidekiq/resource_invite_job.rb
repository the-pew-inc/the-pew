class ResourceInviteJob
  include Sidekiq::Job

  def perform(invited_users, sender, resource)
    invited_users = JSON.parse(invited_users)
    
    invited_users.each do |invited|
      case invited['type']
      when 'group'
        group_invite(invited['id'], sender, resource)
      when 'new_email'
        email = invited['label']
        if valid_email?(email)
          ResourceInvite.create(email: email, 
            group_id: nil,
            invitable: resource, 
            organization_id: sender.organization.id, 
            recipient_id: nil, 
            sender_id: sender.id)
          send_invite(email, resource, sender)
        end
      when 'user'
        user = User.find(invited['id'])
        if user
          ResourceInvite.create(email: user.email, 
            group_id: nil,
            invitable: resource, 
            organization_id: sender.organization.id, 
            recipient_id: user.id, 
            sender_id: sender.id)
          send_invite(user.email, resource, sender)
        end
      when 'invite'
        email = invited['label']
        if valid_email?(email)
          ResourceInvite.create(email: email, 
            group_id: nil,
            invitable: resource, 
            organization_id: sender.organization.id, 
            recipient_id: nil, 
            sender_id: sender.id)
          send_invite(invite.email, resource, sender)
        end
      else
        Rails.logger.error "Unsupported invite type #{invited['type']}"
      end
    end
  end

  private

  def send_invite(email, resource, sender)
    ResourceInviteMailer.invite(email, resource, sender).deliver_later
  end

  def group_invite(group_id, sender, resource)
    group = Group.find(group_id)
    
    if group
      group_memberships = group.group_memberships
        
      group_memberships.each do |membership|
        user = membership.user
        # Create ResourceInvite for this user with polymorphic association
        ResourceInvite.create(email: user.email, 
                              group_id: group_id,
                              invitable: resource, 
                              organization_id: sender.organization.id, 
                              recipient_id: user.id, 
                              sender_id: sender.id)
        # Send the invitation email to the invited user
        send_invite(user.email, resource, sender)
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
