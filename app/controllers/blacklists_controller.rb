class BlacklistsController < ApplicationController

  def index
    @contacts = current_user.blacklist_contacts
  end

  def confirm
    @data = params[:data]
    id = CampaignsHelper.decrypt(params[:data]) 
    @logo= Contact.find(id).campaign.logo.url
    @campaign = Contact.find(id).campaign.name
    @color = Contact.find(id).campaign.color
  end

  def unsubscribe
    id = CampaignsHelper.decrypt(params[:data])
    Contact.find(id).update(blacklist: Time.now)
    flash[:notice] = 'Gracias por contactarnos, Disculpe las molestias'
    redirect_to root_path
  end

  def cancel
  end

end
