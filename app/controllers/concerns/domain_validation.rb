# app/controllers/concerns/domain_validation.rb
module DomainValidation
  extend ActiveSupport::Concern

  VERIFICATION_STRING = "thepew-domain-verification=".freeze

  # Method used to verify that the TXT entry saved in the Organizations table is
  # properly attached to the TXT record of the DNS for that domain
  # domain is passed as a String
  # return true when a TXT record with the DNS TXT value is found in the DNS servers
  # return false is no TXT record is found in the DNS servers
  def valid? domain
    require "resolv"
    dns_obj = Resolv::DNS.new( :nameserver => ['8.8.8.8', '8.8.4.4'] )

    resp = dns_obj.getresources domain, Resolv::DNS::Resource::IN::TXT
    resp_array = resp.map { |r| r.data.to_s }

    dns_txt = Organization.where(domain: domain).select(:dns_txt).first

    if dns_txt.nil?
      # Return false when there is no dns txt value in the datbase and report the error
      logger.error "No DNS TXT for ${domain}"
      return false
    else 
      # Store the verification string into value and look for it in the TXT entries returned by the DNS server
      value = VERIFICATION_STRING + dns_txt

      # Return true if value was in the array, false otherwise
      return resp_array.include? value
    end

  end
end