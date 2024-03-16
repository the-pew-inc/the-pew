# frozen_string_literal: true

# app/services/payload_handler.rb

# The PayloadHandler module is designed to provide utility functions for handling
# payloads that are encoded and signed. This module can be used throughout the
# application to ensure consistent handling of such payloads, particularly for
# tasks such as decoding and verifying the integrity of signed payloads received
# from external services or sent within the application.

module PayloadHandler
  # Makes the following methods callable on the module itself, while also making them
  # private when included in another class. This provides a clean utility-based
  # approach for handling signed payloads with encapsulated functionality.

  module_function

  # Decodes and verifies a signed payload using Rails' ActiveSupport::MessageVerifier.
  # This method ensures that the payload hasn't been tampered with and returns
  # the original data as a JSON-parsed object.
  #
  # @param signed_payload [String] The Base64 encoded and signed payload to decode and verify.
  # @return [Hash, nil] The decoded and verified payload as a Ruby hash, or nil if verification fails.
  def decode_signed_payload(signed_payload)
    verifier = ActiveSupport::MessageVerifier.new(Rails.application.secrets.secret_key_base)
    decoded_payload = Base64.urlsafe_decode64(signed_payload)
    original_payload = verifier.verify(decoded_payload)
    JSON.parse(original_payload)
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    Rails.logger.error("Invalid signature for signed payload: #{signed_payload}")
    nil
  end

  # Signs the provided payload with Rails' ActiveSupport::MessageVerifier, using the application's
  # secret_key_base. This method ensures the integrity and authenticity of the payload, making it
  # secure for transmission or storage. The signed payload is then Base64 encoded to ensure safe
  # transport through URLs or HTTP headers.
  #
  # @param payload [Hash] The payload to be signed, which can be a string or a hash.
  #                               Hashes are converted to JSON strings before signing.
  # @return [String] A Base64 encoded string representing the signed version of the input payload.
  def sign_payload(payload)
    verifier = ActiveSupport::MessageVerifier.new(Rails.application.secrets.secret_key_base)
    signed_token = verifier.generate(payload)
    Base64.urlsafe_encode64(signed_token)
  end
end
