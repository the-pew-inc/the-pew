<<<<<<< HEAD
# == Schema Information
#
# Table name: organizations
#
#  id                 :uuid             not null, primary key
#  country            :string
#  dns_txt            :string
#  domain             :string
#  domain_verified    :boolean          default(FALSE), not null
#  domain_verified_at :datetime
#  name               :string
#  sso                :boolean          default(FALSE), not null
#  website            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_organizations_on_country          (country)
#  index_organizations_on_dns_txt          (dns_txt) UNIQUE
#  index_organizations_on_domain           (domain) UNIQUE
#  index_organizations_on_domain_verified  (domain_verified)
#  index_organizations_on_sso              (sso)
#
=======
>>>>>>> 9aab7f0 (Renaming Account into Organization)
class Organization < ApplicationRecord  
  # enable rolify on the Account class
  resourcify

  # Tracking changes
  has_paper_trail

  # Callbacks
<<<<<<< HEAD
  before_validation :generate_dns_txt, if: :will_save_change_to_domain?
  before_validation :clean_domain, if: :will_save_change_to_domain?

  has_many :members
=======
  before_save :generate_dns_txt, if: :will_save_change_to_domain?
  before_validation :clean_domain, if: :will_save_change_to_domain?

  # has_many :members
>>>>>>> 9aab7f0 (Renaming Account into Organization)
  has_many :users,   through: :members
  
  has_one_attached :logo

  has_rich_text    :description

  validates :website, url: { allow_nil: true, schemes: ['https'] }
  validates :name,   presence: true, length: { minimum: 3, maximum: 120 }
  validates :logo,   content_type: ['image/png', 'image/jpeg', 'image/jpg', 'image/gif'],
                     size: { between: 1.kilobyte..5.megabytes, message: 'is not given between size' }

  # SSO related field
<<<<<<< HEAD
  validates :domain,  uniqueness: true,
                      allow_nil: true,
                      fully_qualified_domain: true,
                      length: { minimum: 3, maximum: 120 }
  validates :dns_txt, uniqueness: true, length: { is: 126 }, allow_nil: true

  # Display the full dns text 
  # This includes the prefix (27 characters) and the unique 126 character string stored in the database
=======
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
>>>>>>> 9aab7f0 (Renaming Account into Organization)
  def full_dns_txt
    prefix = "thepew-domain-verification=" # 27 characters
    prefix + self.dns_txt
  end

  private

<<<<<<< HEAD
  # Generate a unique TXT entry
  def generate_dns_txt
    self.dns_txt = random_unique_string if self.domain_changed?
  end

  # Generates a unique 126 character long and case sensitive string
=======
  # Generates a unique 63 character and case sensitive string
>>>>>>> 9aab7f0 (Renaming Account into Organization)
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
<<<<<<< HEAD
end
=======
end
>>>>>>> 9aab7f0 (Renaming Account into Organization)
