# frozen_string_literal: true

class EmbeddedComponent < ViewComponent::Base
  def initialize(path:, label:)
    @path = path
    @label = label
  end

end
