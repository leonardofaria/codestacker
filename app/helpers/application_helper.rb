module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper

	def flash_message
	  messages = ''
	  [:notice, :info, :warning, :alert].each do |message|
	    messages += "<div class=\"alert alert-#{message}\">#{flash[message]}</div>" if flash[message]
	    flash[message] = nil
	  end
	  messages.html_safe
	end

  def title(page_title, options = {})
    if options[:class]
      options[:class] = options[:class] + ' title'
    else
      options[:class] = ' title'
    end
    content_for(:title, ' - ' + page_title.to_s)
    content_tag(:h2, page_title, options)
  end

  # devise helpers

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
