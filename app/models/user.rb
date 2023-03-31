# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  blocked         :boolean          default(FALSE), not null
#  confirmed       :boolean          default(FALSE), not null
#  confirmed_at    :datetime
#  email           :string           not null
#  failed_attempts :integer          default(0), not null
#  level           :integer          default(0)
#  locked          :boolean          default(FALSE), not null
#  locked_at       :datetime
#  password_digest :string
#  provider        :string
#  time_zone       :string
#  uid             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  sash_id         :integer
#
# Indexes
#
#  index_users_on_blocked    (blocked)
#  index_users_on_email      (email) UNIQUE
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

  # Managing organization membership (one to many through Member)
  has_one  :member
  has_one  :organization,    through: :member, required: false

  # Connect the user to their Merit
  has_merit

  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6, maximum: 35 }, on: :create

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

  # Send a password reset email to the user
  def send_password_reset_email!
    password_reset_token = signed_id(purpose: :reset_password, expires_in: PASSWORD_RESET_TOKEN_EXPIRATION)
    UserMailer.password_reset(self, password_reset_token).deliver_later
  end

  # Send a confirmation email to the user
  def send_confirmation_email!
    confirmation_token = signed_id(purpose: :email_confirmation, expires_in: CONFIRMATION_TOKEN_EXPIRATION)
    UserMailer.confirmation(self, confirmation_token).deliver_later
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
    # Creating a default account
    # TODO: connect users to existing account via SSO or other mechanisms to support invitation
    @default_organization = Organization.create!({name: '__default__'})

    logger.info @default_organization.inspect

    # Attach user to the default account
    @member = Member.new()
    @member.user_id = self.id
    @member.organization_id = @default_organization.id
    @member.owner = true
    @member.save
  end
  
end
