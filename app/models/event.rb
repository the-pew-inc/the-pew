class Event < ApplicationRecord
  include Rails.application.routes.url_helpers

  # enable rolify on the Event class
  resourcify

  # Tracking changes
  has_paper_trail

  before_validation :set_values

  belongs_to :user
  has_many   :rooms, dependent: :destroy

  has_one_attached :qr_code

  validates :name, presence: true, length: { minimum: 3, maximum: 250 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate  :end_date_is_after_start_date

  enum status: { draft: 0, published: 10, opened: 20, closed: 30, archived: 40 }

  # Universal: everyone can see questions, asking question requires an account
  # Restricted: seeing and asking questions require an account
  # Invite_only: seeing and asking questions require an account and an invitation
  enum event_type: { universal: 10, restricted: 20, invite_only: 30 }, _default: 10

  private

  # TODO: remove this method once the system becomes more stable
  def set_values
    self.end_date = start_date
    self.short_code = generate_pin # should only be called when status is opened (or published) and removed for all otehr statuses
    logger.info "set_values / short_code: #{self.short_code}"

    set_duration

    generate_qr_code
  end

  def generate_qr_code
    logger.info "generate_qr_code / short_code: #{self.short_code}"
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
    self.duration = (end_date - start_date).to_i
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
