# There is one service class per action: Created, Updated and Deleted
# The service class can be called anywhere, including in the console, as soon as a
# proper user object is passed.
#
class Broadcasters::Users::Deleted
  attr_reader :question

  def initialize(user, organization)
    @user = user
    @organization = organization
  end

  def call
    Turbo::StreamsChannel.broadcast_remove_to @organization.id, target: @user 
    Turbo::StreamsChannel.broadcast_update_later_to  @organization.id, target: "users-counter", html: @organization.members.count
  end

end
