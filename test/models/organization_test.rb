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
#  stripe_customer_id      :string
#
# Indexes
#
#  index_organizations_on_country             (country)
#  index_organizations_on_dns_txt             (dns_txt) UNIQUE
#  index_organizations_on_domain              (domain) UNIQUE
#  index_organizations_on_domain_verified     (domain_verified)
#  index_organizations_on_sso                 (sso)
#  index_organizations_on_stripe_customer_id  (stripe_customer_id) UNIQUE
#
require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  def setup
    @organization = organizations(:one)
  end

  test 'valid organization' do
    assert @organization.valid?, @organization.errors.full_messages.inspect
  end

  test 'invalid without name' do
    @organization.name = nil
    refute @organization.valid?, 'organization is valid without a name'
    assert_not_nil @organization.errors[:name], 'no validation error for name present'
  end

  test 'invalid with a short name' do
    @organization.name = 'AB'
    refute @organization.valid?, 'organization is valid with a short name'
    assert_not_nil @organization.errors[:name], 'no validation error for short name present'
  end

  test 'invalid with a long name' do
    @organization.name = 'A' * 121
    refute @organization.valid?, 'organization is valid with a long name'
    assert_not_nil @organization.errors[:name], 'no validation error for long name present'
  end

  test 'invalid without unique domain' do
    another_organization = organizations(:two)
    another_organization.domain = @organization.domain
    refute another_organization.valid?, 'organization is valid with a non-unique domain'
    assert_not_nil another_organization.errors[:domain], 'no validation error for non-unique domain present'
  end

  test 'dns_txt generation' do
    new_organization = Organization.new(name: 'New Org', domain: 'new.org')
    new_organization.valid?
    assert_not_nil new_organization.dns_txt, 'dns_txt not generated for the new organization'
  end

  test 'full_dns_txt' do
    expected_full_dns_txt = "thepew-domain-verification=" + @organization.dns_txt
    assert_equal expected_full_dns_txt, @organization.full_dns_txt, 'full_dns_txt method not returning the correct value'
  end
end
