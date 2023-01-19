class Account < ApplicationRecord  
  # enable rolify on the Account class
  resourcify

  # Tracking changes
  has_paper_trail

  # Callbacks
  before_save :generate_dns_txt, if: :will_save_change_to_domain?
  before_validation :clean_domain, if: :will_save_change_to_domain?

  # has_many :members
  has_many :users,   through: :members
  
  has_one_attached :logo

  has_rich_text    :description

  validates :website, url: { allow_nil: true, schemes: ['https'] }
  validates :name,   presence: true, length: { minimum: 3, maximum: 120 }
  validates :logo,   content_type: ['image/png', 'image/jpeg', 'image/jpg', 'image/gif'],
                     size: { between: 1.kilobyte..5.megabytes, message: 'is not given between size' }

  # SSO related field
  validates :domain,  uniqueness: true, 
                      fully_qualified_domain: true,
                      length: { minimum: 3, maximum: 120 }
  validates :dns_txt, uniqueness: true, length: { is: 63 }

  # Generate a unique TXT entry
  def generate_dns_txt
    self.dns_txt = random_unique_string if self.domain_changed? 
  end

  # Display the full dns text 
  # This includes the prefix (27 characters) and the unique 63 character string stored in the database
  def full_dns_txt
    prefix = "thepew-domain-verification=" # 27 characters
    prefix + self.dns_txt
  end

  private

  # Generates a unique 63 character and case sensitive string
  def random_unique_string
    rus = ""
    loop do
      rus = SecureRandom.hex(63) # or whatever you chose like UUID tools
      break unless self.class.exists?(dns_txt: rus)
    end
    rus
  end

  # This method removes http and https://, potential trailing / and carriage returns, line feeds, spaces
  # from the domain name
  # It is called before validating the model and only if the domain name has changed
  def clean_domain
    self.domain = self.domain.gsub(/(http|https):\/\/|\/$/, '').gsub(/[\r\n\s]/, '')
  end
end