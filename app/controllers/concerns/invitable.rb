module Invitable
  extend ActiveSupport::Concern

  def fetch_invited_users(resource)
    # Return the invited users if needed
    # See Notion for the correct format.
    invited_users = []
    if !resource.universal?
      # Remove fron invites the users from a group (that means group_id AND email not null) 
      # to only keep the group_id
      invites = resource.resource_invites.where.not('group_id IS NOT NULL AND email IS NOT NULL')
      
      # Format the @invited_user entries as per the requirements
      # Only one catch: we do not check for type invite as this would require a few more
      # queries on the database. As this information is not that important at this stage we
      # merge types user and invite together.
      invites.each do |invite|
        # Testing if this is a group (aka group_id is not null)
        if invite.group_id.present?
          invited_users << { id: invite.group_id, type: "group", label: invite.group.name }
          next # Move to next invite record
        end

        # Testing if this is a new user (email is present but there is no recipient_id)
        if invite.email.present? && invite.recipient_id.nil?
          invited_users << { id: "", type: "new_user", label: invite.email }
          next # Move to next invite record
        end

        # Testing if this is a  user (email and recipient_id not null)
        # or a user extracted from ResourceInvite (in that case the recipient_id will contain an invite id)
        # For now we will fallback to the type user
        if invite.email.present? && invite.recipient_id.present?
          invited_users << { id: invite.recipient_id, type: "user", label: invite.email }
        end
      end
      
    end

    # Return a formated or empty array of invited users
    invited_users
  end

end