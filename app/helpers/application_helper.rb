module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper

	def flash_message
	  messages = ''
	  [:notice, :info, :warning, :alert].each do |message|
	    messages += "<div class=\"pure-alert pure-alert-#{message}\">#{flash[message]}</div>" if flash[message]
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
    content_for(:title, page_title.to_s)
    content_tag(:h2, page_title, options)
  end

  def page_title(title)
    return "codestacker &mdash; #{title}" if title
    return "codestacker &mdash; #{params[:tag]}" if params[:tag]
    return "codestacker &mdash; #{params[:user]}" if params[:user]
    return "codestacker &mdash; #{@code.title}" if @code
    return "codestacker &mdash; we love code"
  end

  def rss_links
    return auto_discovery_link_tag(:rss, tag_code_url(params[:tag], format: 'rss')) if params[:tag]
    return auto_discovery_link_tag(:rss, user_code_url(params[:user], format: 'rss')) if params[:user]
    return auto_discovery_link_tag(:rss, codes_url(format: 'rss'))
  end

  def google_analytics(id)
    content_tag :script do
      "
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
        m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

        ga('create', #{id}, 'auto');
        ga('send', 'pageview');
      ".html_safe
    end if id && Rails.env == 'production'
  end

  def owner?(id)
    current_user && (current_user.role.name == 'admin' || current_user.id == id)
  end

  def meta_tags
    keywords = "codestacker, code, php, ruby, snippet, resource, actionscript, rails, yml, sql"
    keywords = @code.tag_list if @code

    description = "codestacker is a community to share snippets easily!"
    description = @code.description.html_safe if @code and @code.description

    "<meta name=\"keywords\" content=\"#{keywords}\">".html_safe + "<meta name=\"description\" content=\"#{description}\">".html_safe
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
