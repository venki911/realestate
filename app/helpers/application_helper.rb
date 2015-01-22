module ApplicationHelper
  def page_title(title)
    content_for(:title) { title + " - " + ENV['APP_NAME'] }
  end

  def errors_for(record)
    content_tag :ul, class: 'record-error' do 
      result = ""
      record.errors.full_messages.each do |message|
        result += content_tag('li', message, class: 'record-error-field')
      end
      result.html_safe
    end
  end

  def flash_messages
    trans = { 'alert' => 'alert-danger', 'notice' => 'alert alert-success' }

    content_tag :div, class: 'alert-animate' do
      flash.map do |key, value|
        content_tag 'div', value, class: "alert #{trans[key]} alert-body"
      end.join('.').html_safe
    end
  end
end
