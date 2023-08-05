module UserSearchable
  extend ActiveSupport::Concern

    # Searches for users in the current user's organization based on a search query.
    #
    # The `:q` param is used to determine the search query. This method utilizes a custom search
    # method on the User model to find users based on this query. It only considers users who 
    # belong to the same organization as the currently logged-in user.
    #
    # In order to prevent unnecessary database queries, it also eager loads the `:profile` 
    # association for the searched users. It also limits the search results to the top 5 matches.
    #
    # If no search query is provided, it will return an empty ActiveRecord::Relation.
    #
    # This method is intended to be used for an autocomplete feature, and it renders the associated 
    # view without a layout.
    #
    # @return [void]
    def search_users
      if params[:q].present?
        query = params[:q]
        # blocked = params[:blocked].present? && params[:blocked] == 'true'
        # locked = params[:locked].present? && params[:locked] == 'true'
  
        @searched_users = User.joins(:member)
                          .where(members: { organization_id: current_user.organization.id })
                          .search(query)
                          # .where(blocked: blocked)
                          # .where(locked: locked)
                          .includes(:profile)
                          .limit(5)
      else
        @searched_users = User.none
      end
      render layout: false
    end


    # search_users_and_groups_for_invites searches for users, groups, and previously sent resource invites based on the provided query.
    # 
    # This action looks up:
    # - Users within the current organization excluding those who have already received invites from the current user.
    # - Groups based on their name.
    # - Previous resource invites sent by other users within the same organization.
    # 
    # The results are then collated and rendered as a JSON response comprising an array of objects.
    # Each object represents either a user, group, or a previous resource invite. They are characterized by 
    # the attributes `type`, `name`, `email`, and `id`. 
    # 
    # If no results are found or if no query is provided, an empty array is returned.
    def search_users_and_groups_for_invites
      results = []
      
      if params[:q].present?
        query = params[:q]
    
        # Search users
        searched_users = User.joins(:member)
                             .where(members: { organization_id: current_user.organization.id })
                             .search(query) 
                             .includes(:profile)
                             .limit(5)
        
        searched_users.each do |user|
          results << {
            type: :user,
            name: user.profile&.name,
            email: user.email,
            id: user.id
          }
        end
    
        # Search groups
        searched_groups = Group
                          .where("user_id = ? OR (group_type = ? AND organization_id = ?)", current_user.id, Group.group_types[:organization], current_user.organization.id)
                          .search(query)
                          .limit(5)
    
        searched_groups.each do |group|
          results << {
            type: :group,
            name: group.name,
            id: group.id
          }
        end

        # Search resource invites
        searched_invites = ResourceInvite.search(query)
                          .where(sender_id: current_user.id)
                          .limit(5)

        searched_invites.each do |invite|
          results << {
          type: :invite,
          name: nil,
          email: invite.email,
          id: nil
          }
        end
      end
    
      render json: results
    end
    
end