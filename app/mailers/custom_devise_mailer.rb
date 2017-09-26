class CustomDeviseMailer < Devise::Mailer   
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  # config devise deliver method
  self.delivery_method = :smtp
  self.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => 587,
    :authentication => :plain,
    :user_name      => Rails.application.secrets.sendgrid_username,
    :password       => Rails.application.secrets.sendgrid_password,
    :domain         => 'heroku.com', #actualizar al cambiar el dominio
    :enable_starttls_auto => true
  }

end