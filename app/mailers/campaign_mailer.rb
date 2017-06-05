class CampaignMailer < ApplicationMailer

  def send_survey(hashes, transmitter, receiver, subject)
    @hashes = hashes
    data = { html_content_only: true }
    # mail(to: receiver, subject: "Test", body: "test correo gem", from: "roberto@kheper.io")
    mail(to: receiver, subject: subject, from: transmitter, sparkpost_data: data)
  end

end
