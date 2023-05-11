module EventsHelper

  def event_creator(event)
    # if user_signed_in? && event.user_id == Current.user.id
    if event.user_id == Current.user.id
      'you'
    else
      event.user.profile.nickname.strip
    end
  end

end
