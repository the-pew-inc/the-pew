# app/components/dashboard_counter_component.rb

# frozen_string_literal: true

# @param title [String] 
# @param total [Integer] 
# @param icon  [Integer] 
# @param icon_color [Integer] 
# @param link [String] 
# @param positive [Integer] 
# @param neutral [Integer] 
# @param negative [Integer] 
# @param background_color [String] 

# Examples
# DashboardCounterComponent.new()
# DashboardCounterComponent.new()
class DashboardCounterComponent < ViewComponent::Base
  def initialize(title:, total:, icon:, icon_color:, link:nil, positive:0, neutral:0, negative:0, background_color:)

    @title = title.capitalize
    @total = total       # Sum of positive, negative, neutral must be equal to the total
    @icon = icon         # Icon to be displayed next to the title (svg format)
    @icon_color = icon_color # Tailwind color passed as text-{color}-{value}
    @link = link         # In case the icon should open a new page
    @positive = compute_percentage(total, positive)  # % of positive questions from the total
    @neutral  = compute_percentage(total, neutral)   # % of neutral questions from the total
    @negative = compute_percentage(total, negative)  # % of negative questions from the total
    @background_color = background_color # Tailwind color passed as bg-{color}-{value}

  end

  private

  def compute_percentage(total, value)
    if total > 0
      ((value.to_f / total) * 100).round
    end
  end

end
