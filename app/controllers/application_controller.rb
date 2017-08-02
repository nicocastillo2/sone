class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  # layout :layout_by_resource

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :avatar])
  end

  private

  # def layout_by_resource
  #   if devise_controller?
  #     false
  #   else
  #     "application"
  #   end
  # end

end
