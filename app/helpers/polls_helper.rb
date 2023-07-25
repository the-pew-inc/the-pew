module PollsHelper

  def voting_guide_message(num_votes, max_votes)
    if max_votes.present?
      if num_votes.present? && num_votes < max_votes
        "Please select at least #{num_votes} out of #{max_votes} options below"
      else
        "Please express your opinion for #{pluralize(max_votes, "option")}"
      end
    elsif num_votes.present?
      "Please express your opinion for at least #{pluralize(num_votes, "option")}"
    end
  end

end
