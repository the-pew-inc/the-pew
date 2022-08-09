# app/components/alert_component.rb

# frozen_string_literal: true

# @param type [String] Classic alert (aka flash) type `error`, `alert` and `info` + custom `success`
# @param data [String, Hash] `String` for backward compatibility,
#   `Hash` for the new functionality `{title: '', body: '', timeout: 5, countdown: false, action: { url: '', method: '', name: ''}}`.
#   The `title` attribute for `Hash` is mandatory.

# Examples
# AlertComponent.new(type: 'notice', data: { timeout: 8, title: 'Entry was deleted', body: 'You can still recover the deleted item using Undo below.', countdown: true, action: { url: 'http://localhost:3000/undo', method: 'patch', name: 'Undo' } })
# AlertComponent.new(type: 'error', data: { timeout: 8, title: 'Access denied', body: "You don't have sufficient rights to the action." })
# AlertComponent.new(type: 'success', data: 'Successfully logged in')
# AlertComponent.new(type: 'alert', data: 'You need to log in to access the page')

class AlertComponent < ViewComponent::Base
  def initialize(type:, data:)
    @type = type
    @data = prepare_data(data)
    @icon = icon
    @icon_color_class = icon_color

    @data[:timeout] ||= 3
  end

  private 

  def prepare_data(data)
    case data
    when Hash
      data
    else
      { title: data }
    end
  end

  def icon
    case @type
    when 'success', 'notice'
      '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>'.html_safe
    when 'error', 'alert'
      '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>'.html_safe
    else
      '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>'.html_safe
    end
  end

  def icon_color
    case @type
    when 'success', 'notice'
      'text-green-400'
    when 'error',
      'text-red-800'
    when 'alert'
      'text-red-400'
    else
      'text-gray-400'
    end
  end

end
