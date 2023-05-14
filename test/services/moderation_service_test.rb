require 'minitest/autorun'
require_relative '../../app/services/moderation_service'

class ModerationServiceTest < Minitest::Test
  def test_detect_prohibited_content_with_email
    input_string = 'Contact me at john@example.com'
    result = ModerationService.detect_prohibited_content(input_string)
    assert_equal 'Email addresses are prohibited.', result
  end

  def test_detect_prohibited_content_with_domain
    input_string = 'Visit our website at www.example.com'
    result = ModerationService.detect_prohibited_content(input_string)
    assert_equal 'Website domains are prohibited.', result
  end

  def test_detect_prohibited_content_with_valid_input
    input_string = 'Hello, this is a valid input'
    result = ModerationService.detect_prohibited_content(input_string)
    assert_nil result
  end
end