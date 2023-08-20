class ResourceInviteUpdateJob
  include Sidekiq::Job

  # @param invited_users [Array<Hash>] The list of users/groups invited to the resource.
  # @param sender [User] The user sending the invite.
  # @param resource [ActiveRecord::Base] The resource (like Poll, Survey, Event) for which users/groups are invited.
  def perform(invited_users, sender, resource)
    # Invited users (received from the UI)
    invited_users = JSON.parse(invited_users)
    # Remove duplicates based on the label attribute
    invited_users.uniq! { |user| user["label"] }

    resource = JSON.parse(resource)

    # Fetch from the database a list of the already invited users and groups
    invites = ResourceInvite.where(invitable_id: resource['invitable_id'], invitable_type: resource['invitable_type'])
    filtered_invites = invites.to_a # Convert to array to work with 

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
          # invites.where(group_id: group_id).destroy_all
          filtered_invites.reject! { |invite| invite.group_id == group_id }
        else
          new_invites_users << invited
        end
      when 'new_email', 'invite'
        email = invited['label']
        if valid_email?(email)
          # Check if email is already in invites
          # If so remove the entry(ies) with this email from invites
          if valid_email?(email) && invites.exists?(email: email)
            # invites.where(email: email).destroy_all
            filtered_invites.reject! { |invite| invite.email == email }
          else
            new_invites_users << invited
          end
        end
      when 'user'
        user = User.find(invited['id'])
        # Check if user is already in invites
        # If so remove the entry(ies) with this user from invites
        if user && invites.exists?(recipient_id: user.id)
          # invites.where(recipient_id: user.id).destroy_all
          filtered_invites.reject! { |invite| invite.recipient_id == user.id }
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
    ResourceInviteJob.perform_async(new_invites_users.to_json, sender, resource.to_json) if new_invites_users.length > 0

    # invites should now only contains the groups and users which have
    # been removed from the resource by the organizer.
    # We can now remove them from ResourceInvite to match the organizer list.
    if filtered_invites.length > 0
      # Extract group_ids from filtered_invites
      group_ids_to_remove = filtered_invites.select { |invite| invite.group_id }.map(&:group_id)

      # Extract recipient_ids (user ids) from filtered_invites
      user_ids_to_remove = filtered_invites.select { |invite| invite.recipient_id }.map(&:recipient_id)

      # Remove ResourceInvites by group_ids
      ResourceInvite.where(group_id: group_ids_to_remove, invitable_id: resource['invitable_id'], invitable_type: resource['invitable_type']).destroy_all if group_ids_to_remove.any?

      # Remove ResourceInvites by user (recipient) ids
      ResourceInvite.where(recipient_id: user_ids_to_remove, invitable_id: resource['invitable_id'], invitable_type: resource['invitable_type']).destroy_all if user_ids_to_remove.any?

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
