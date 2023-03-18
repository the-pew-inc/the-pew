# frozen_string_literal: true

class DashboardQuestionTableComponent < ViewComponent::Base
  renders_one  :header
  renders_many :questions

end
