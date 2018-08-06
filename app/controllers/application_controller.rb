class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, :alert => exception.message
  end

  #rescue_from ActiveRecord::RecordNotUnique, with: :uniqueness_rescue_method

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user!, unless: :in_public_controller?
  before_filter :set_active_area

  def uniqueness_rescue_method
    raise 'Value already in use'
  end

  def in_public_controller?
    ['home', 'user_messages'].include?(params[:controller])
  end

  def after_sign_in_path_for(user)
    user.after_sign_in_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << [:username, :name, :address_1, :address_2, :city, :state, :zip, :phone, :email]
    devise_parameter_sanitizer.for(:sign_up) << [:username]
  end

  def set_active_area
    current_path = request.path
    @active_app_area = if current_path =~ /^\/users\/\d+$/
                         :profile
                       elsif current_path =~ /^\/rounds/
                         :rounds
                       elsif current_path =~ /^\/teams/
                         :teams
                       elsif current_path =~ /^\/users\/edit/
                         :settings
                       elsif current_path =~ /^\/leaderboards/
                         :leaderboards
                       elsif current_path =~ /^\/?$/
                         :home
                       elsif current_path =~ /^\/custom_series/
                         :custom_series
                       end
  end
end
