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

  # Usage:
  #   Used to create a user, the user profile and make this user a member of an organization
  #   - rake "onboard:create_organization_user[org_id, test@test.com, nickname]"
  desc 'Create a user and associate this user with an existing organization'
  task :create_organization_user, [:organization_id, :email, :nickname] => :environment do |_t, args|
    begin
      puts("[#{Time.now.utc}] Running create_organization_user :: INI")

      organization = Organization.find(args[:organization_id])
      unless organization
        puts("[#{Time.now.utc}] Organization with ID #{args[:organization_id]} not found.")
        end_task(-1)
      end

      user = User.find_or_initialize_by(email: args[:email])
      user.profile ||= Profile.new # Create a profile if it doesn't exist
      user.profile.nickname = args[:nickname]

      if user.save
        member = Member.find_or_initialize_by(user: user, organization: organization)
        member.owner = false # You can set this to true if this user should be the owner
        member.save
        puts("[#{Time.now.utc}] User #{user.email} has been created and added to organization #{organization.name} as a member.")
        puts("[#{Time.now.utc}] User #{user.email} ID is: #{user.id}")
        end_task(0)
      else
        puts("[#{Time.now.utc}] Failed to create user. Errors: #{user.errors.full_messages.join(', ')}")
        end_task(-1)
      end
    rescue => e
      puts("[#{Time.now.utc}] An error occurred: #{e.message}")
      end_task(-1)
    end
  end

  # Usage:
  #   Used to assign the admin role for a user who is already a member of an organization
  #   - rake "onboard:make_org_admin[org_id, test@test.com]"
  desc 'Make a user admin of an organization'
  task :make_org_admin, [:organization_id, :email] => :environment do |_t, args|
    begin
      puts("[#{Time.now.utc}] Running make_org_admin :: INI")

      organization = Organization.find(args[:organization_id])
      user = User.find_by(email: args[:email])

      unless organization
        puts("[#{Time.now.utc}] Organization with ID #{args[:organization_id]} not found.")
        end_task(-1)
      end

      unless user
        puts("[#{Time.now.utc}] User with email #{args[:email]} not found.")
        end_task(-1)
      end

      unless user.has_role?(:admin, organization)
        user.add_role(:admin, organization)
        puts("[#{Time.now.utc}] User #{user.email} is now an admin of organization #{organization.name}.")
      else
        puts("[#{Time.now.utc}] User #{user.email} is already an admin of organization #{organization.name}.")
      end

      end_task(0)
    rescue => e
      puts("An error occurred: #{e.message}")
      end_task(-1)
    end
  end

  def end_task(status = 0)
    puts("[#{Time.now.utc}] Running create_first_user_and_org :: END")
    exit(status)
  end
end
