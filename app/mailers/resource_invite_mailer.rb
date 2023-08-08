class ResourceInviteMailer < ApplicationMailer
  def invite(email, record)
    @email = email
    @record = record

    mail(to: @email, subject: 'You are invited!')
  end
end
