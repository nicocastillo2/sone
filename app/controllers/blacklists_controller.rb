class BlacklistsController < ApplicationController

  def index
    @contacts = current_user.blacklist_contacts
  end

  def confirm
    @data = params[:data]
  end

  def unsubscribe
    id = CampaignsHelper.decrypt(params[:data])
    Contact.find(id).update(blacklist: Time.now)
  end

  def cancel
  end

end
