# == Schema Information
#
# Table name: connectors
#
#  id          :uuid             not null, primary key
#  author      :string
#  description :text
#  github      :string
#  name        :string           not null
#  version     :string           not null
#  website     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class ConnectorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
