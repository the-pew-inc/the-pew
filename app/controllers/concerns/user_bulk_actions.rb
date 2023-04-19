# app/controllers/concerns/user_bulk_actions.rb

# Description: a set of methods to manipulate arrays of users
# Mainly used by the users_controler#bulk_update
#
module UserBulkActions
  extend ActiveSupport::Concern

  # PATCH accounts/
  # Used to update a bulk of users all at once.
  # Supported operations:
  # - Delete
  # - Block
  # - Promote Admin (assign as organization admin)
  # - Demote Admin (remove from organization admin)
  def bulk_update
    logger.debug "ACTION: #{params[:commit]} / #{params[:value]}"
    logger.debug "PARAMS: #{params[:bulk_action]}"
    logger.debug "USER_IDS: #{params[:user_ids]} / #{params[:user_ids].nil?}"
    # Return if no user is selected
    # if params[:user_ids].nil?
    #   logger.debug "WE HAVE NO USER SELECTED!!!"
    #   head :unprocessable_entity
    #   return true
    # end

    logger.debug "WE HAVE USERS, SELECTING THE RIGHT ACTION:"
    case params[:bulk_action]
    when "promote"
      logger.debug "PROMOTE"
      bulk_promote(params[:user_ids])
    when "demote"
      logger.debug "DEMOTE"
    when "block"
      logger.debug "BLOCK"
      bulk_block(params[:user_ids])
    when "unblock"
      logger.debug "UNBLOCK"
      bulk_unblock(params[:user_ids])
    when "delete"
      logger.debug "DELETE"
    else
      # TODO log an error before return
      logger.error "Unsupported bulk_action: #{params[:bulk_action]}"
      head :bad_request
      return true
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
    logger.debug "MAKE ADMIN"
    # Implementation code here
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
    # Implementation code here
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
    logger.debug "IN BULK_BLOCK"
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
    logger.debug "IN BULK_UNBLOCK"
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