# app/services/moderation_service.rb
class ModerationService
  # Define regular expressions for email addresses and website domains
  EMAIL_REGEX = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/
  DOMAIN_REGEX = /\b(?:https?:\/\/)?(?:www\.)?([a-zA-Z0-9.-]+(?:\.[a-zA-Z]{2,})+)\b/

  # Detects prohibited content in the input string.
  #
  # Returns a message indicating the type of prohibited content found,
  # or nil if no prohibited content is detected.
  def self.detect_prohibited_content(input)
    if input.match?(EMAIL_REGEX)
      return 'Email addresses are prohibited.'
    end

    if input.match?(DOMAIN_REGEX)
      return 'Website domains are prohibited.'
    end

    return nil
  end
end

input_string = 'Hello, please contact me at john@example.com or visit www.example.com or mydomain.com or app.example.com or app.secret-server.stanford.edu.'
prohibited_content = ModerationService.detect_prohibited_content(input_string)

if prohibited_content
  puts "Prohibited content detected: #{prohibited_content}"
else
  puts "Input string is valid."
end
