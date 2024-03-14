# == Schema Information
#
# Table name: connectors
#
#  id           :uuid             not null, primary key
#  author       :string
#  enabled      :boolean          default(FALSE), not null
#  github       :string
#  name         :string           not null
#  redirect_url :string           not null
#  settings     :jsonb            not null
#  tags         :string           default([]), is an Array
#  verified     :boolean          default(FALSE), not null
#  version      :string
#  website      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_connectors_on_enabled   (enabled)
#  index_connectors_on_name      (name) UNIQUE
#  index_connectors_on_tags      (tags) USING gin
#  index_connectors_on_verified  (verified)
#

require 'test_helper'

class ConnectorTest < ActiveSupport::TestCase
  setup do
    @connector_one = connectors(:one)
    unless @connector_one.valid?
      puts @connector_one.errors.full_messages
    end
    @connector_two = connectors(:two)
  end

  test 'should be valid' do
    assert @connector_one.valid?
    # assert @connector_two.valid?
  end

  test 'name should be present' do
    @connector_two.name = ''
    assert_not @connector_one.valid?
  end

  test 'version should be present' do
    @connector_two.version = ''
    assert_not @connector_one.valid?
  end

  test 'logo should be of valid content type jpg' do
    file = file_fixture('test_image.jpg')
    @connector_one.logo.attach(io: File.open(file), filename: 'test_image.jpg', content_type: 'image/jpeg')
    assert @connector_one.valid?
  end
  
  test 'logo should be of valid content type png' do
    file = file_fixture('test_image.png')
    @connector_one.logo.attach(io: File.open(file), filename: 'test_image.png', content_type: 'image/png')
    assert @connector_one.valid?
  end
  
  test 'logo should be of valid content type gif' do
    file = file_fixture('test_image.gif')
    @connector_one.logo.attach(io: File.open(file), filename: 'test_image.gif', content_type: 'image/gif')
    assert @connector_one.valid?
  end
  
  test 'logo should be of valid content type pdf (false)' do
    file = file_fixture('test_document.pdf')
    @connector_one.logo.attach(io: File.open(file), filename: 'test_document.pdf', content_type: 'application/pdf')
    assert_not @connector_one.valid?
  end
  
  test 'logo size should be within limits' do
    file = file_fixture('oversize_test_image.jpg')
    @connector_one.logo.attach(io: File.open(file), filename: 'oversize_test_image.jpg', content_type: 'image/jpeg')
    assert @connector_one.valid?, @connector_one.errors.full_messages.to_sentence
  end

  # Add more tests as needed
end
