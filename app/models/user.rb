# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  accepted_invitation_on :datetime
#  blocked                :boolean          default(FALSE), not null
#  confirmed              :boolean          default(FALSE), not null
#  confirmed_at           :datetime
#  email                  :string           not null
#  failed_attempts        :integer          default(0), not null
#  invited                :boolean          default(FALSE), not null
#  invited_at             :datetime
#  level                  :integer          default(0)
#  locked                 :boolean          default(FALSE), not null
#  locked_at              :datetime
#  password_digest        :string
#  provider               :string
#  time_zone              :string
#  uid                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  sash_id                :integer
#
# Indexes
#
#  index_users_on_blocked    (blocked)
#  index_users_on_email      (email) UNIQUE
#  index_users_on_invited    (invited)
#  index_users_on_level      (level)
#  index_users_on_locked     (locked)
#  index_users_on_provider   (provider)
#  index_users_on_sash_id    (sash_id)
#  index_users_on_time_zone  (time_zone)
#  index_users_on_uid        (uid) UNIQUE
#
class User < ApplicationRecord

  rolify strict: true
  
  # We do not save the password, but the password diget after generating it using Argon2
  attr_accessor :password
  attr_accessor :current_password

  # Callbacks
  after_create  :create_and_attach_to_organization
  after_create  :send_confirmation_email!
  before_save   :downcase_email, if: :will_save_change_to_email?
  before_save   :generate_password_digest

  # Mailer configuration
  MAILER_FROM_EMAIL = 'ThePew no-reply@thepew.io'
  CONFIRMATION_TOKEN_EXPIRATION = 1.day
  PASSWORD_RESET_TOKEN_EXPIRATION = 20.minutes

  # Relations
  has_many :notifications,   as: :recipient, dependent: :destroy # enable Noticed
  has_many :active_sessions, dependent: :destroy
  has_many :attendances,     dependent: :destroy
  has_many :visits,          class_name: "Ahoy::Visit"
  has_many :actions,         class_name: 'Ahoy::Event'
  has_one  :profile,         dependent: :destroy
  accepts_nested_attributes_for :profile, allow_destroy: true
  has_many :events,          dependent: :destroy
  has_many :questions,       dependent: :destroy
  has_many :votes,           dependent: :destroy
  has_many :polls,           dependent: :destroy
  has_many :poll_answers,    dependent: :destroy
  has_many :poll_options,    dependent: :destroy

  # Managing organization membership (one to many through Member)
  has_one  :member
  has_one  :organization,    through: :member, required: false

  # To enable bullk upload via an excel spreadsheet
  has_one_attached :import_file
  has_many         :import_results, dependent: :destroy

  # Connect the user to their Merit
  has_merit

  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6, maximum: 35 }, on: :create, if: -> { !invited }

  ## Functions

  # Authenticate the user (aka validates the password)
  def authenticate(password)
    require('argon2')
    Argon2::Password.verify_password(password, password_digest)
  end

  # Update the confirmation status for this user
  def confirm!
    update_columns(confirmed_at: Time.current, confirmed: true)
  end

  # Block the user
  def block!
    update_columns(blocked: true)
  end

  # Unblock the user
  def unblock!
    update_columns(blocked: false)
  end

  def lock!
    update_columns(locked_at: Time.current, locked: true)
  end

  def unlock!
    update_columns(locked: false, locked_at: nil, failed_attempts: 0)
  end

  # Send a password reset email to the user
  def send_password_reset_email!
    # If the user was invited, the user should not be able to bypass the invitation flow 
    # by resetting their password, unless they have accepted the invitation what translated to
    # accepted_invitation_on is different from nil
    if !self.invited || self.accepted_invitation_on != nil
      password_reset_token = signed_id(purpose: :reset_password, expires_in: PASSWORD_RESET_TOKEN_EXPIRATION)
      UserMailer.password_reset(self.id, password_reset_token).deliver_later
    end
  end

  # Send a confirmation email to the user
  def send_confirmation_email!
    # If the user was invited, the user should not be able to bypass the invite flow 
    # by accepting a confirmation email.
    # Users invited to join an organization are automatically confirmed as the invite to
    # join the organization plays the role of a confirmation email.
    if !self.invited
      confirmation_token = signed_id(purpose: :email_confirmation, expires_in: CONFIRMATION_TOKEN_EXPIRATION)
      UserMailer.confirmation(self.id, confirmation_token).deliver_later
    end
  end

  # Used to send an invite to join an Organization
  # Invitates are valid for 3 days
  def send_invite!
    invitation_token = signed_id(purpose: :invite, expires_in: 3.days)
    UserMailer.invite(self.id, invitation_token).deliver_later
  end

  def invited!
    self.confirm!
    update_columns(accepted_invitation_on: Time.current)
  end

  # Method used to confir that a user is the owner of a given organization
  def organization_owner?(organization)
    member = Member.find_by(user_id: id, organization_id: organization.id)
    member&.owner?
  end

  # PRIVATE METHODS #
  private

  # Make sure we save all emails in lowercase
  def downcase_email
    self.email = email.downcase
  end

  # Hash the password using Argon2
  def generate_password_digest
    require('argon2')
    self.password_digest = Argon2::Password.create(password) if password.present?
  end

  # Method called only when an existing user changes their email address.
  def change_email
    send_confirmation_email!
    self.confirmed = false
    self.confirmed_at = nil
  end

  def create_and_attach_to_organization
    # Only attached a user to a new organization if this user is not invited to join an
    # existing organization
    if !self.invited 
      # Creating a default organization
      @default_organization = Organization.create!({name: '__default__'})

      # Attach user to the default account
      @member = Member.new()
      @member.user_id = self.id
      @member.organization_id = @default_organization.id
      @member.owner = true
      @member.save
    else
      #TODO Should return an error pointing to the invitation
    end
  end
  
end
