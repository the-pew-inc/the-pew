# Description:
# A set of functions used to manage account creation and account owner creation / invitation
# IMPORTANT NOTICE: the organization and organization owner MUST NOT ALREADY EXIST in the
# system.
namespace :onboard do

  # Usage:
  #   Used to create the owner of an organization and the organization.
  #   Once successfuly created, the user receives and email to finalize the registration
  #   - rake "onboard:create_first_user_and_org[test@test.com, ACME Inc., https://acme.com, acme.com]"
  desc 'Create first user (owner) and org'
  task :create_first_user_and_org, [:email, :org_name, :org_website, :domain] => :environment do |_t, args|

    puts("[#{Time.now.utc}] Running create_first_user_and_org :: INI")

    # Making sure that the organization does not already exist
    @organization = Organization.find_by(name: args[:org_name])
    if @organization
      puts("[#{Time.now.utc}] An organization with name: #{args[:org_name]} already exist in the database")
      end_task(-1)
    end

    # Creating the organization
    @organization = Organization.new
    @organization.name = args[:org_name]
    @organization.website = args[:org_website]
    @organization.domain = args[:domain]

    if @organization.save!
      # Creating the owner
      @user = User.new
      @user.email = args[:email]
      @user.invited_at = Time.current
      @user.invited = true

      if @user.save!
        # Connecting the user to the organization
        Member.create!(organization_id: @organization.id, user_id: @user.id, owner: true)

        # Sending the invitation to the user
        puts("[#{Time.now.utc}] Sending invitation to organization owner")
        @user.send_invite!
      else
        puts("[#{Time.now.utc}] Failed to create user wil email #{args[:email]}")
        end_task(-1)
      end
    else
      puts("[#{Time.now.utc}] Failed to create #{args[:org_name]}")
      end_task(-1)
    end
    
    end_task
  end

  def end_task(status = 0)
    puts("[#{Time.now.utc}] Running create_first_user_and_org :: END")
    exit(status)
  end
end
