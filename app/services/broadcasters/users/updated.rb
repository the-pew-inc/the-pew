# There is one service class per action: Created, Updated and Deleted
# The service class can be called anywhere, including in the console, as soon as a
# proper user object is passed.
#
class Broadcasters::Users::Created
  attr_reader :question

  def initialize(user)
    @user = user
    @organization = @user.organization
  end

  def call
    Turbo::StreamsChannel.broadcast_update_later_to @organization.id, target: "settings_users", partial: "users/user", locals: { question: @user }
  end

end
