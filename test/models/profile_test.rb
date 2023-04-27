# == Schema Information
#
# Table name: profiles
#
#  id         :uuid             not null, primary key
#  mode       :integer          default("light"), not null
#  nickname   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_profiles_on_mode     (mode)
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  def setup
    @profile = profiles(:one)
  end

  test "should be valid" do
    assert @profile.valid?
  end

  test "user_id should be present" do
    @profile.user_id = nil
    assert_not @profile.valid?
  end

  test "nickname should be present" do
    @profile.nickname = "     "
    assert_not @profile.valid?
  end

  test "nickname should not be too short" do
    @profile.nickname = "a" * 2
    assert_not @profile.valid?
  end

  test "nickname should not be too long" do
    @profile.nickname = "a" * 41
    assert_not @profile.valid?
  end

  test "avatar should be present" do
    @profile.avatar.attach(io: File.open(Rails.root.join('test', 'fixtures', 'files', 'test-avatar.jpeg')), filename: 'test-avatar.png', content_type: 'image/png')
    assert @profile.valid?
  end

  test "avatar should be a valid content type" do
    @profile.avatar.attach(io: File.open(Rails.root.join('test', 'fixtures', 'files', 'test-avatar.pdf')), filename: 'test-avatar.pdf', content_type: 'application/pdf')
    assert_not @profile.valid?
  end

  test "avatar should not be too large" do
    @profile.avatar.attach(io: File.open(Rails.root.join('test', 'fixtures', 'files', 'test-avatar.jpeg')), filename: 'test-avatar.png', content_type: 'image/png')
    assert @profile.valid?
    @profile.avatar.attach(io: File.open(Rails.root.join('test', 'fixtures', 'files', 'large-avatar.jpg')), filename: 'large-avatar.png', content_type: 'image/png')
    assert_not @profile.valid?
  end
end
