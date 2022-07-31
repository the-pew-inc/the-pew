module QuestionsHelper
  def question_status(question)
    case question.status
    when 'asked'
      content_tag(:span, "in review" , class: "bg-gray-100 text-gray-800 text-sm font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-gray-700 dark:text-gray-300")
    when 'approved'
      content_tag(:span, "asked" , class: "bg-blue-100 text-blue-800 text-sm font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-blue-200 dark:text-blue-800")
    when 'answered'
      content_tag(:span, "answered" , class: "bg-green-100 text-green-800 text-sm font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-green-200 dark:text-green-900")
    when 'rejected'
      rejection_cause(question)
    else
      # TODO: report error
      content_tag(:span, "invalid status" , class:"bg-yellow-100 text-yellow-800 text-sm font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-yellow-200 dark:text-yellow-900")
    end
  end

  private

  def rejection_cause(question)
    if ['duplicate', 'other'].include? question.rejection_cause 
      content_tag(:span, "rejected - cause: #{question.rejection_cause}" , class: "bg-purple-100 text-purple-800 text-sm font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-purple-200 dark:text-purple-900")
    else
      content_tag(:span, "rejected - cause: #{question.rejection_cause}" , class: "bg-red-100 text-red-800 text-sm font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-red-200 dark:text-red-900")
    end
  end
end
