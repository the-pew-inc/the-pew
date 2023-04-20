# There is one service class per action: Created, Updated and Deleted
# The service class can be called anywhere, including in the console, as soon as a
# proper user object is passed.
#
class Broadcasters::Users::Updated
  attr_reader :question

  def initialize(user)
    @user = user
    @organization = @user.organization
    @current_user = Current.user
  end

  def call
    Turbo::StreamsChannel.broadcast_replace_later_to @organization.id, 
      target: "user_#{@user.id}", 
      partial: "users/user", 
      locals: { user: @user, current_user: @current_user }
  end

end
