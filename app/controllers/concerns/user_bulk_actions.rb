# app/controllers/concerns/user_bulk_actions.rb

# Description: a set of methods to manipulate arrays of users
# Mainly used by the users_controler#bulk_update
#
module UserBulkActions
  extend ActiveSupport::Concern
  include Pundit

  # PATCH accounts/
  # Used to update a bulk of users all at once.
  # Supported operations:
  # - Delete
  # - Block
  # - Promote Admin (assign as organization admin)
  # - Demote Admin (remove from organization admin)
  def bulk_update
    authorize current_user, :bulk_update?
    
    # Return if no user is selected
    # if params[:user_ids].nil?
    #   logger.debug "WE HAVE NO USER SELECTED!!!"
    #   head :unprocessable_entity
    #   return true
    # end

    case params[:bulk_action]
    when "promote"
      bulk_promote(params[:user_ids])
    when "demote"
      bulk_demote(params[:user_ids])
    when "block"
      bulk_block(params[:user_ids])
    when "unblock"
      bulk_unblock(params[:user_ids])
    when "delete"
      bulk_delete(params[:user_ids])
    else
      logger.error "Unsupported bulk_action: #{params[:bulk_action]}"
      head :bad_request
      return true
    end

    # Broadcast the changes
    users = User.find( params.fetch(:user_ids, []).compact )
    users.each do |user|
      Broadcasters::Users::Updated.new(user).call
    end
    
  end


  private
  # Private: Promotes an array of users to organization admins.
  #
  # user_ids - An Array of Integer user IDs to be promoted.
  #
  # Examples
  #
  #   bulk_promote([1, 2, 3])
  #   # => 3
  #
  # Returns the number of modified objects.
  def bulk_promote(user_ids)
    users = User.where(id: params.fetch(:user_ids, []).compact)
    organization = current_user.organization
    users.each do |user|
      user.add_role(:admin, organization) if !user.has_role?(:admin, organization)
    end
  end

  # Private: Demotes an array of organization admins to regular users.
  #
  # user_ids - An Array of Integer user IDs to be demoted.
  #
  # Examples
  #
  #   demote([4, 5, 6])
  #   # => 3
  #
  # Returns the number of modified objects.
  def bulk_demote(user_ids)
    users = User.where(id: params.fetch(:user_ids, []).compact)
    organization = current_user.organization
    users.each do |user|
      user.remove_role(:admin, organization) if user.has_role?(:admin, organization)
    end
  end

  # Private: Blocks an array of users.
  #
  # user_ids - An Array of Integer user IDs to be blocked.
  #
  # Examples
  #
  #   bulk_block([7, 8, 9])
  #   # => 3
  #
  # Returns the number of modified objects.
  def bulk_block(user_ids)
    c = User.where(id: params.fetch(:user_ids, []).compact).update_all(blocked: true)
    return c
  end

  # Private: Unblocks an array of users.
  #
  # user_ids - An Array of Integer user IDs to be unblocked.
  #
  # Examples
  #
  #   bulk_unblock([10, 11, 12])
  #   # => 3
  #
  # Returns the number of modified objects.
  def bulk_unblock(user_ids)
    c = User.where(id: params.fetch(:user_ids, []).compact).update_all(blocked: false)
    return c
  end

  # Private: Deletes an array of users.
  #
  # user_ids - An Array of Integer user IDs to be deleted.
  #
  # Examples
  #
  #   delete([13, 14, 15])
  #   # => 3
  #
  # Returns the number of modified objects.
  def bulk_delete(user_ids)
    # Implementation code here
  end

end