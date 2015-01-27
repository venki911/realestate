module ApplicationHelper
  def page_title(title)
    content_for(:title) { title + " - " + ENV['APP_NAME'] }
  end

  def index_in_paginate(index)
    index + Kaminari.config.default_per_page * params[:page].to_i
  end

  def page_header title, options={},  &block
     content_tag :div,:class => "list-header clearfix" do
        if block_given? 
            content_title = content_tag :div, :class => "left" do
              content_tag(:h3, title, :class => "header-title")
            end

            output = with_output_buffer(&block)
            content_link = content_tag(:div, output, {:class => " right"})
            content_title + content_link
        else
            content_tag :div , :class => "row" do 
               content_tag(:h3, title, :class => "header-title")
            end
        end 
     end
  end

  def input_row &block
    content_tag :div, with_output_buffer(&block), class: 'input-row'
  end

  def breadcrumb_admin(options=nil)
    breadcrumb_create options, "Home", admin_root_url
  end

  def breadcrumb_member(options=nil)
    breadcrumb_create options, "Home", member_root_url
  end

  def breadcrumb(options=nil)
    breadcrumb_create options, "Home", root_url
  end

  def breadcrumb_create options, home_text, home_url
    content_tag(:ul, breadcrumb_str(options, home_text, home_url), :class => "breadcrumb")
  end

  def breadcrumb_str options, home_text, home_url
    items = []
    char_sep = "&raquo;".html_safe
    if( !options.nil?  && options.size != 0)
      items <<  content_tag(:li , :class => "active") do
        link_to(home_text, home_url ) + content_tag(:span, char_sep, :class => "divider")
      end
      options.each do |option|
        option.each do |key, value|
          if value
          items << content_tag(:li) do
            link_to(key, value) + content_tag(:span, char_sep, :class => "divider")
          end 
          else
            items << content_tag(:li, key, :class =>"active") 
          end
        end
      end 
    else
      icon = content_tag "i", " ", :class => "icon-user  icon-home"
      items << content_tag(:li, icon + home_text , :class => "active")  
    end
    items.join("").html_safe
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

  def flash_config
    config = {key: '', value: ''}
    flash.map do |key, value|
      config[:key] = key
      config[:value] = value
    end
    config
  end

  def notification_box
    content_tag :div, '', id: 'notification'
  end

  def flash_messages

    trans = { 'alert' => 'alert-danger', 'notice' => 'alert alert-success' }

    content_tag :div, class: 'notification' do
      flash.map do |key, value|
        content_tag 'div', value, class: "alert #{trans[key]} alert-body"
      end.join('.').html_safe
    end
  end
end
