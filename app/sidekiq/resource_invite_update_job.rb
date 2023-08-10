class ResourceInviteUpdateJob
  include Sidekiq::Job

  # @param invited_users [Array<Hash>] The list of users/groups invited to the resource.
  # @param sender [User] The user sending the invite.
  # @param resource [ActiveRecord::Base] The resource (like Poll, Survey, Event) for which users/groups are invited.
  def perform(invited_users, sender, resource)
    # Invited users (received from the UI)
    invited_users = JSON.parse(invited_users)

    # Invited users for the same resource (fetch from db)
    invites = ResourceInvite.where(invitable: resource)

    new_invites_users = []
    
    # Scan all the invited_users
    # If a user (email) or group (group_id) is already in the invites collection we simply
    # remove it from the invites collection.
    # If a user (email) or group (group_id) is not in the invites collection we place it into 
    # new_invites_users array which contains object of type {id:, type:, label: }
    # the new_invites_users array is then passed to the ResourceInviteJob to invite the new users.
    invited_users.each do |invited|
      case invited['type']
      when 'group'
        group_id = invited['id']
        # Check if group_id is already in invites
        # If so remove all entries from invites which have this group_id (group and users)
        if invites.exists?(group_id: group_id)
          invites.where(group_id: group_id).destroy_all
        else
          new_invites_users << invited
        end
      when 'new_email', 'invite'
        email = invited['label']
        if valid_email?(email)
          # Check if email is already in invites
          # If so remove the entry(ies) with this email from invites
          if valid_email?(email) && invites.exists?(email: email)
            invites.where(email: email).destroy_all
          elsif valid_email?(email)
            new_invites_users << invited
          end
        end
      when 'user'
        user = User.find(invited['id'])
        # Check if user is already in invites
        # If so remove the entry(ies) with this user from invites
        if user && invites.exists?(user: user)
          invites.where(user: user).destroy_all
        elsif user
          new_invites_users << invited
        end
      else
        # In case we received an incorrect type, report it as an error
        Rails.logger.error "Unsupported invite type #{invited['type']}"
      end
    end

    # Call ResourceInviteJob to invite the new users
    # but first make sure that the new_invites_users can be passed to Sidekiq
    ResourceInviteJob.perform_async(new_invites_users.to_json, sender, resource)

    # invites should now only contains the groups and users which have
    # been removed from the resource by the organizer.
    # We can now remove them from ResourceInvite to match the organizer list.
    invites.each do |invite|
      case invite['type']
      when 'group'
        # Delete all users and group with group_id equal to invite['id']
        # Make sure to do it for this resource as a group and users part of this group
        # can be invited for multiple resources.
        ResourceInvite.where(invitable: resource, group_id: group_id).destroy_all
      when 'user'
        # Remove from ResourceInvite using the User.id from invite['id']
        ResourceInvite.where(invitable: resource, recipient_id: invite['id']).destroy_all
      when 'invite', 'new_email'
        # Remove from ResourceInvite using the email address from label
        email = invite['label']
        ResourceInvite.where(invitable: resource, email: email).destroy_all
      else
        Rails.logger.error "Unsupported type #{invited['type']} cannot remove #{invited.inspect} from ResourceInvite"
      end
    end
  end

  private

  # @param email [String] Email address to validate.
  # @return [Boolean] true if the email is valid, false otherwise.
  def valid_email?(email)
    # A basic email regex to check if email format is valid
    email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  end
end
