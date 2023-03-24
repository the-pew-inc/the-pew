module DashboardsHelper

  def question_status_tone_sum(status_tones, status = nil, tone)
    # If the user has no question... or none of them as a tone, we return 0
    return 0 if status_tones.count == 0

    # When the user has at least one question with a tone
    if status.nil?
      # Compute for the total for a given tone (status == nil)
      sum = status_tones.reduce(0) do |acc, (key, value)|
        if key[1] == tone
          acc + value
        else
          acc
        end
      end
      return sum
    else
      # Sum of a tone for a specific status
      return status_tones[[status, tone]]
    end
  end
end