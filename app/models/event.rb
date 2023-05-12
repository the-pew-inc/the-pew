# == Schema Information
#
# Table name: events
#
#  id              :uuid             not null, primary key
#  allow_anonymous :boolean          default(FALSE), not null
#  always_on       :boolean          default(FALSE), not null
#  duration        :integer
#  end_date        :datetime         not null
#  event_type      :integer          not null
#  name            :string           not null
#  short_code      :string
#  start_date      :datetime         not null
#  status          :integer          default("draft"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#  user_id         :uuid             not null
#
# Indexes
#
#  index_events_on_allow_anonymous  (allow_anonymous)
#  index_events_on_always_on        (always_on)
#  index_events_on_event_type       (event_type)
#  index_events_on_organization_id  (organization_id)
#  index_events_on_short_code       (short_code)
#  index_events_on_status           (status)
#  index_events_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Event < ApplicationRecord
  include Rails.application.routes.url_helpers

  # enable rolify on the Event class
  resourcify

  # Tracking changes
  has_paper_trail

  before_validation :set_values

  belongs_to :user
  belongs_to :organization
  has_many   :attendances, dependent: :destroy
  has_many   :rooms,       dependent: :destroy

  # QR Code of the event
  has_one_attached :qr_code

  # Description (optional) / Used to extract topics and intends from questions by
  # offering a better context to openAI
  has_rich_text :description

  validates :name,       presence: true, length: { minimum: 3, maximum: 250 }
  validates :start_date, presence: true
  validates :end_date,   presence: true
  validate  :end_date_is_after_start_date

  enum status: { draft: 0, published: 10, opened: 20, closed: 30, archived: 40 }

  # Universal: everyone can see questions, asking question requires an account
  # Restricted: seeing and asking questions require an account
  # Invite_only: seeing and asking questions require an account and an invitation
  enum event_type: { universal: 10, restricted: 20, invite_only: 30 }, _default: 10

  private

  # Note: If the way end_date is defined in the set_values method changes,
  # make sure to implement a corresponding test to check if the validation
  # for end_date being before start_date is working correctly.
  def set_values    
    self.end_date = start_date
    self.short_code = generate_pin if self.short_code.nil?
    self.organization_id = Member.where(user_id: self.user_id).first.organization_id if self.organization_id.nil?

    set_duration

    generate_qr_code if self.short_code_changed?
  end

  def generate_qr_code
    qr_url = url_for(
      controller: 'events',
      action: 'event',
      host: ENV['DEFAULT_URL'] || 'localhost:3000',
      pin: short_code,
      only_path: false,
      protocol: 'https',
      source: 'from_qr'
    )

    qr_code.attach(QrGenerator.call(qr_url))
  end

  def set_duration
    self.duration = (end_date - start_date).to_i if start_date.present? && end_date.present?
  end

  def end_date_is_after_start_date
    return if end_date.blank? || start_date.blank?

    errors.add(:end_date, 'cannot be before the start date') if end_date < start_date
  end

  # Generate a unique pin for the event
  def generate_pin
    # loop do
    #   pin = 6.times.map{rand(10)}.join
    #   break pin unless Event.exists?(short_code: pin)
    # end
    6.times.map { rand(10) }.join
  end
end
