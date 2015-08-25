class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :js_request?

  before_action :set_locale, :set_style
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :admin_or_owner_required

  def admin_or_owner_required(id)
    unless current_user and (current_user.id == id || current_user.role.name == 'admin')
      flash[:alert] = t('app.flash.codes.edit_denied')
      request.env['HTTP_REFERER'].nil? ? redirect_to(root_path) : redirect_to(:back)
      return false
    end
  end

  protected

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

  def js_request?
    request.format.js?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
end
