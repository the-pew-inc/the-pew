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
    @profile = profiles(:first)
  end

  %i[nickname].each do |attr|
    test "#{attr} must be present" do
      eval "@profile.#{attr} = nil"
      assert_not @profile.valid?
    end
  end
end
