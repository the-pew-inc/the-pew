# Form Error
# Description: custom class applied to the form fields that are containing an
# incorrect or missing value.
ActionView::Base.field_error_proc = proc do |html_tag, instance|
  fragment = Nokogiri::HTML.fragment(html_tag)
  field = fragment.at('input,select,textarea')

  html = if field
          error_message = instance_tag.error_message.join(', ')
          field['class'] = "#{field['class']} border-red-600 border focus:outline-none"
          html = <<-HTML
              #{fragment.to_s}
              <p class="mt-1 text-sm text-red-600">#{error_message.upcase_first}</p>
          HTML
          html
        else
          html_tag
        end

  html.html_safe
end