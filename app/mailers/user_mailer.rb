class UserMailer < ApplicationMailer
  default from: User::MAILER_FROM_EMAIL

  def confirmation(user, confirmation_token)
    @user = user
    @confirmation_token = confirmation_token

    mail(
      to: @user.email, 
      subject: 'THEPEW: Account Confirmation Instructions')
  end

  def password_reset(user, password_reset_token)
    @user = user
    @password_reset_token = password_reset_token

    mail(
      to: @user.email, 
      subject: 'THEPEW: Password Reset Instructions')
  end

  def welcome(user)
    @user = user
    mail(
      to: @user.email,
      subject: 'THEPEW: Welcome'
    )
  end

  def password_change_confirmatiom(user)
    @user = user
    mail(
      to: @user.email,
      subject: 'THEPEW: Password changed'
    )
  end

  def invite(user, invitation_token)
    @user = user
    @invitation_token = invitation_token
    mail(
      to: @user.email,
      subject: "We're thrilled to welcome you to THEPEW! "
    )
  end
end
