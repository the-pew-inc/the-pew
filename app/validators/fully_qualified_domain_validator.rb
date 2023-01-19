class FullyQualifiedDomainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A(?!http:\/\/|https:\/\/|www\.|localhost)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(\/[^\s]*)?\z/i
      record.errors[attribute] << (options[:message] || "is not a fully qualified domain name")
    end
    if value =~ /\A(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\z/
      record.errors[attribute] << (options[:message] || "is not a domain name but an IP address")
    end
  end
end