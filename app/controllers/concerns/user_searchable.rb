module UserSearchable
  extend ActiveSupport::Concern

    def search_users
      if params[:q].present?
        query = params[:q]
        blocked = params[:blocked].present? && params[:blocked] == 'true'
        locked = params[:locked].present? && params[:locked] == 'true'
  
        @searched_users = User.joins(:member)
                          .where(members: { organization_id: current_user.organization.id })
                          .search(query)
                          .where(blocked: blocked)
                          .where(locked: locked)
                          .includes(:profile)
                          .limit(5)
      else
        @searched_users = User.none
      end
      render layout: false
    end
end