# == Schema Information
#
# Table name: members
#
#  id              :uuid             not null, primary key
#  owner           :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#  user_id         :uuid             not null
#
# Indexes
#
#  index_members_on_organization_id  (organization_id)
#  index_members_on_owner            (owner)
#  index_members_on_user_id          (user_id)
#
require "test_helper"

class MemberTest < ActiveSupport::TestCase
  def setup
    @john = users(:john)
    @jane = users(:jane)
    @organization = organizations(:one)
  end

  test "should not save member without user" do
    member = Member.new(organization: @organization)
    assert_not member.save
  end

  test "should not save member without organization" do
    member = Member.new(user: @john)
    assert_not member.save
  end

  test "should save member with user and organization" do
    member = Member.new(user: @john, organization: @organization)
    assert member.save
  end

  def test_should_have_one_owner_for_each_organization
    organization = organizations(:one)
    assert organization.valid?
  
    member1 = members(:john)
    assert member1.valid?
  
    member2 = members(:jane)
    assert member2.valid?
  
    # Check that there is exactly one owner for the organization
    assert_equal 1, organization.members.where(owner: true).count
  
    # Check that both members are part of the organization
    assert_includes organization.members, member1
    assert_includes organization.members, member2
  end

end
