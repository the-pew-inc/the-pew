class User < ApplicationRecord
  rolify strict: true
  # We do not save the password, but the password diget after generating it using Argon2
  attr_accessor :password
  attr_accessor :current_password

  # Callbacks
  after_create :send_confirmation_email!
  before_save  :downcase_email, if: :will_save_change_to_email?
  before_save  :generate_password_digest

  # Mailer configuration
  MAILER_FROM_EMAIL = '<The Pew!> no-reply@thepew.co'
  CONFIRMATION_TOKEN_EXPIRATION = 1.day
  PASSWORD_RESET_TOKEN_EXPIRATION = 20.minutes

  # Relations
  has_many :active_sessions, dependent: :destroy
  has_one  :profile,         dependent: :destroy
  has_many :events,          dependent: :destroy
  has_one  :account,         through:   :members,   required: false
  accepts_nested_attributes_for :profile

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
  
end
