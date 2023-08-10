class ResourceInviteMailer < ApplicationMailer
  def invite(resource, invitation)
    @resource = resource
    @invitation = invitation

    mail(to: @invitation.email, subject: 'You are invited!')
  end
end
