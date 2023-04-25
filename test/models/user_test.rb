# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  accepted_invitation_on :datetime
#  blocked                :boolean          default(FALSE), not null
#  confirmed              :boolean          default(FALSE), not null
#  confirmed_at           :datetime
#  email                  :string           not null
#  failed_attempts        :integer          default(0), not null
#  invited                :boolean          default(FALSE), not null
#  invited_at             :datetime
#  level                  :integer          default(0)
#  locked                 :boolean          default(FALSE), not null
#  locked_at              :datetime
#  password_digest        :string
#  provider               :string
#  time_zone              :string
#  uid                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  sash_id                :integer
#
# Indexes
#
#  index_users_on_blocked    (blocked)
#  index_users_on_email      (email) UNIQUE
#  index_users_on_invited    (invited)
#  index_users_on_level      (level)
#  index_users_on_locked     (locked)
#  index_users_on_provider   (provider)
#  index_users_on_sash_id    (sash_id)
#  index_users_on_time_zone  (time_zone)
#  index_users_on_uid        (uid) UNIQUE
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:john)
  end

  test 'valid user' do
    assert @user.valid?
  end

  test 'invalid without email' do
    @user.email = nil
    refute @user.valid?, 'user is valid without an email'
    assert_not_nil @user.errors[:email], 'no validation error for email present'
  end

  test 'email format validation' do
    @user.email = 'invalid_email'
    refute @user.valid?, 'user is valid with an invalid email format'
    assert_not_nil @user.errors[:email], 'no validation error for email format present'
  end

  test 'email uniqueness validation' do
    @duplicate_user = @user.dup
    @user.save
    refute @duplicate_user.valid?, 'user is valid with a duplicate email'
    assert_not_nil @duplicate_user.errors[:email], 'no validation error for email uniqueness present'
  end

  test 'password length validation' do
    new_user = User.new(email: 'test@example.com', password: 'short')
    refute new_user.valid?, 'user is valid with a short password'
    assert_not_nil new_user.errors[:password], 'no validation error for password length present'
  end

  test 'authenticate user' do
    assert @user.authenticate('password123'), 'failed to authenticate user with valid password'
    refute @user.authenticate('wrong_password'), 'authenticated user with invalid password'
  end

  # Add more tests for other functionalities as needed
end
