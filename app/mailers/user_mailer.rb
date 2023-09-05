class UserMailer < ApplicationMailer
  default from: User::MAILER_FROM_EMAIL

  def confirmation(user_id, confirmation_token)
    @user = User.find(user_id)
    @confirmation_token = confirmation_token

    mail(
      to: @user.email, 
      subject: 'THEPEW: Account Confirmation Instructions')
  end

  def password_reset(user_id, password_reset_token)
    @user = User.find(user_id)
    @password_reset_token = password_reset_token

    mail(
      to: @user.email, 
      subject: 'THEPEW: Password Reset Instructions')
  end

  def welcome(user_id)
    @user = User.find(user_id)
    mail(
      to: @user.email,
      subject: 'THEPEW: Welcome'
    )
  end

  def password_change_confirmation(user_id)
    @user = User.find(user_id)
    mail(
      to: @user.email,
      subject: 'THEPEW: Password changed'
    )
  end

  def invite(user_id, invitation_token)
    @user = User.find(user_id)
    @invitation_token = invitation_token
    mail(
      to: @user.email,
      subject: "We're thrilled to welcome you to THEPEW! "
    )
  end
end
