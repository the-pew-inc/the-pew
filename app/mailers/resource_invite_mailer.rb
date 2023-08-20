class ResourceInviteMailer < ApplicationMailer
  default from: User::MAILER_FROM_EMAIL
  
  def invite(resource)
    @resource = JSON.parse(resource)

    @resource_url = root_url 
    if @resource['invitable_type'].downcase == 'event'
      @resource_url += "rooms/#{@resource['invitable_id']}/questions"
    else
      @resource_url += @resource['invitable_type'].downcase.pluralize + "/" + @resource['invitable_id']
    end

    mail(to: @resource['email'], subject: 'You are invited!')
  end
end
