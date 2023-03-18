# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  blocked         :boolean          default(FALSE), not null
#  confirmed       :boolean          default(FALSE), not null
#  confirmed_at    :datetime
#  email           :string           not null
#  failed_attempts :integer          default(0), not null
#  locked          :boolean          default(FALSE), not null
#  locked_at       :datetime
#  password_digest :string
#  provider        :string
#  uid             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_blocked   (blocked)
#  index_users_on_email     (email) UNIQUE
#  index_users_on_locked    (locked)
#  index_users_on_provider  (provider)
#  index_users_on_uid       (uid) UNIQUE
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  %i[email password].each do |attr|
    test "#{attr} must be present" do
      eval "@user.#{attr} = nil"
      assert_not @user.valid?
    end
  end

  # test "roles and assignments" do
  #   should have_many(:assignments)
  #   should have_many(:roles).through(:assignments)
  # end

  # test "user should have role" do
  #   assert_not(@subject.role? :admin)

  #   @subject.roles << Role.new(name: 'admin')

  #   assert(@subject.role? :admin)
  # end
end
