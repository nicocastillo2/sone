class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    campaigns_path # Or :prefix_to_your_route
  end

  def after_update_path_for(resource)
    campaigns_path
  end
end
