# == Schema Information
#
# Table name: organizations
#
#  id                      :uuid             not null, primary key
#  country                 :string
#  dns_txt                 :string
#  domain                  :string
#  domain_verified         :boolean          default(FALSE), not null
#  domain_verified_at      :datetime
#  failed_attempts_timeout :integer          default(900), not null
#  max_failed_attempts     :integer          default(5), not null
#  name                    :string
#  sso                     :boolean          default(FALSE), not null
#  website                 :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_organizations_on_country          (country)
#  index_organizations_on_dns_txt          (dns_txt) UNIQUE
#  index_organizations_on_domain           (domain) UNIQUE
#  index_organizations_on_domain_verified  (domain_verified)
#  index_organizations_on_sso              (sso)
#
require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
