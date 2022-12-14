class BlacklistsController < ApplicationController

  def index
    @contacts = current_user.blacklist_contacts
  end

  def confirm
    @data = params[:data]
    id = CampaignsHelper.decrypt(params[:data]) 
    @logo= Contact.find(id).campaign.logo.real_ftp_url
    @campaign = Contact.find(id).campaign.name
    @color = Contact.find(id).campaign.color
  end

  def unsubscribe
    id = CampaignsHelper.decrypt(params[:data])
    Contact.find(id).update(blacklist: Time.now)
    flash[:notice] = t("controllers.blacklist_controller.unsuscribe_notice")
    redirect_to root_path
  end

  def cancel
  end

end
