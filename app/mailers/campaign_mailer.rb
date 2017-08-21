class CampaignMailer < ApplicationMailer

  layout false, :only => 'change_subscription'

  def send_survey(id_campaign, sender)
    campaign = Campaign.includes(:contacts).find(id_campaign)
    @sender_name = campaign.sender_name
    recipients = []
    recipients_data = []
    color = campaign.color
    campaign.contacts.where(blacklist: nil, valid_info: true, status: 0).each do |contact|
      recipients << contact.email
      recipients_data << { substitution_data: { name: contact.name, token: CampaignsHelper.encrypt(contact.id.to_s), color: color }, address: { email: contact.email, header_to: contact.email } }
    end
    data = { html_content_only: true, recipients: recipients_data }
    @logo_path = campaign.logo.url

    mail(to: recipients, subject: "¿Qué tan dispuesto estarías a recomendar #{@sender_name} a un amigo o familiar?", from: sender, sparkpost_data: data)
  end

  def change_subscription(subscription_name, user_email)
    @subscription_name = subscription_name
    @user_email = user_email
    data = { html_content_only: true }
    mail(to: @user_email, subject: 'Cambio de Suscription', from: 'noreply@sone.com.mx', sparkpost_data: data)
  end

end
