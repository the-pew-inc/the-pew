class Event < ApplicationRecord
  include Rails.application.routes.url_helpers

  # enable rolify on the Event class
  resourcify

  before_validation :set_values
  before_save :set_duration
  after_create :generate_qr_code

  belongs_to :user
  has_many :rooms, dependent: :destroy

  has_one_attached :qr_code

  validates :name, presence: true, length: { minimum: 5, maximum: 250 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate  :end_date_is_after_start_date

  enum status: { draft: 0, published: 10, opened: 20, closed: 30, archived: 40 }

  # Universal: everyone can see questions, asking question requires an account
  # Restricted: seeing and asking questions require an account
  # Invite_only: seeing and asking questions require an account and an invitation
  enum event_type: { universal: 10, restricted: 20, invite_only: 30 }, _default: 10

  # Set of triggers to broadcast CRUD to the display
  after_create_commit do
    # broadcast_prepend_to :events, target: "events", partial: "events/event", locals: { event: self }
    broadcast_prepend_to [Current.user.id, :events], target: "events", partial: "events/event", locals: { event: self }
  end

  after_update_commit do
    broadcast_update_to [Current.user.id, :events], partial: "events/event", locals: { event: self }
  end

  after_destroy_commit do
    broadcast_remove_to [Current.user.id, :events]
  end

  private

  # TODO: remove this method once the system becomes more stable
  def set_values
    self.end_date = start_date
    self.short_code = generate_pin # should only be called when status is opened (or published) and removed for all otehr statuses
  end

  def generate_qr_code
    qr_url = url_for(controller: 'events',
                     action: 'show',
                     id: id,
                     only_path: false,
                     host: 'localhost:3000',
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
