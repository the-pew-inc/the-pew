# There is one service class per action: Created, Updated and Deleted
# The service class can be called anywhere, including in the console, as soon as a
# proper user object is passed.
#
class Broadcasters::Users::Created
  attr_reader :question

  def initialize(user)
    @user = user
    @current_user = Current.user
    @organization = @current_user.organization
  end

  def call
    Turbo::StreamsChannel.broadcast_append_later_to @organization.id, target: "user-list", partial: "users/user", locals: { user: @user, current_user: @current_user }
    Turbo::StreamsChannel.broadcast_update_later_to @organization.id, target: "users-counter", html: @user.organization.members.count
  end

end