module QuestionsHelper
  # Used in _question.html.erb and _sub_question.html.erb
  # Display the question status
  def question_status(question)
    case question.status
    when 'asked'
      content_tag(:span, "in review" , class: "bg-gray-100 text-gray-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-gray-700 dark:text-gray-300")
    when 'approved'
      content_tag(:span, "approved" , class: "bg-blue-100 text-blue-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-blue-200 dark:text-blue-800")
    when 'answered'
      content_tag(:span, "answered" , class: "bg-green-100 text-green-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-green-200 dark:text-green-900")
    when 'rejected'
      rejection_cause(question)
    when 'beinganswered'
      content_tag(:span, "being answered" , class: "bg-indigo-100 text-indigo-800 text-xs font-semibold mr-2 px-2.5 py-0.5 rounded dark:bg-indigo-200 dark:text-indigo-900")
    else
      # TODO: report error
      content_tag(:span, "invalid status" , class:"bg-yellow-100 text-yellow-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-yellow-200 dark:text-yellow-900")
    end
  end

  # Used in your_questions#show, your_question#index, dahsboard#show
  # Display the question status in a flowbite bordered badge
  def display_question_status(status)
    case status
    when 'approved'
      content_tag(:span, "Approved" , class: "bg-blue-100 text-blue-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-gray-700 dark:text-blue-400 border border-blue-400")
    when 'asked'
      content_tag(:span, "Pending" , class: "bg-yellow-100 text-yellow-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-gray-700 dark:text-yellow-300 border border-yellow-300")
    when 'beinganswered'
      content_tag(:span, "Being Answered" , class: "flex-nowrap bg-green-100 text-green-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-gray-700 dark:text-green-400 border border-green-400")
    when 'answered'
      content_tag(:span, "Ansered" , class: "bg-green-100 text-green-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-gray-700 dark:text-green-400 border border-green-400")
    when 'rejected'
      content_tag(:span, "Rejected" , class: "bg-red-100 text-red-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-gray-700 dark:text-red-400 border border-red-400")
    else

    end
  end

  private

  def rejection_cause(question)
    if ['duplicate', 'other'].include? question.rejection_cause 
      content_tag(:span, "rejected - cause: #{question.rejection_cause}" , class: "bg-purple-100 text-purple-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-purple-200 dark:text-purple-900")
    else
      content_tag(:span, "rejected - cause: #{question.rejection_cause}" , class: "bg-red-100 text-red-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-red-200 dark:text-red-900")
    end
  end
end
