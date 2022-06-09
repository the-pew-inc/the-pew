module ApplicationHelper
  def flash_bg_color(type)
    case type
    when 'alert'
      'bg-red-100'
    when 'notice'
      'bg-blue-100'
    else
      # TODO: report in system log
      'bg-green-100'
    end
  end

  def flash_text_color(type)
    case type
    when 'alert'
      'text-red-700'
    when 'notice'
      'text-blue-700'
    else
      # TODO: report in system log
      'text-green-700'
    end
  end
end
