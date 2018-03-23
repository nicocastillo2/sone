class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    CampaignMailer.welcome(current_user).deliver_now
    current_user.update(terms: true)
    new_campaign_path # Or :prefix_to_your_route

  end

  def after_update_path_for(resource)
    new_campaign_path
  end
end
