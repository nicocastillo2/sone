class CampaignMailer < ApplicationMailer

  def send_survey(id_campaign, subject, sender)
    campaign = Campaign.find(id_campaign)
    recipients = []
    recipients_data = []
    color = campaign.color
    campaign.contacts.each do |contact|
      recipients << contact.email
      recipients_data << { substitution_data: { name: contact.name, token: contact.token, color: color } }
    end
    data = { html_content_only: true, recipients: recipients_data }
    @logo_path = campaign.logo.url

    mail(to: recipients, subject: subject, from: sender, sparkpost_data: data)
  end

end
