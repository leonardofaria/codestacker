class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale, :set_style
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_style
    style = params[:style] ? params[:style] : session[:style] ? session[:style] : 'Monokai'
    session[:style] = style
  end

  def set_locale
    case request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    when 'pt'
    when 'pt-PT'
      locale = 'pt-BR'
    else
      locale = I18n.default_locale
    end

    I18n.locale = locale
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
end
