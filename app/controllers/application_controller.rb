class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :translate_urls
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  # http_basic_authenticate_with name: "kheper", password: "1234kh"
  include ApplicationHelper

  # layout :layout_by_resource
  def survey
    render 'campaign_mailer/send_survey'
  end
  
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
  
  def translate_urls
    translation_table = [
      ["https://www.sone.com.mx", root_path(locale: :"es-MX")],
      ["https://www.sone.com.mx/politics", politics_path(locale: :"es-MX")],
      ["https://www.sone.com.mx/pricing", pricing_path(locale: :"es-MX")],
      ["https://www.sone.com.mx/term", terms_path(locale: :"es-MX")],
      ["https://sone.com.mx", root_path(locale: :"es-MX")],
      ["https://sone.com.mx/politics", politics_path(locale: :"es-MX")],
      ["https://sone.com.mx/pricing", pricing_path(locale: :"es-MX")],
      ["https://sone.com.mx/term", terms_path(locale: :"es-MX")]
    ]
    
    url = translation_table.detect{ |x| x[0] == request.original_url }
    if request.original_url.starts_with?("https://blog") || request.original_url.include?("/blog")
      # redirect_to "/blog"
    elsif !url.nil?
      redirect_to url[1], status: 301 and return
    end
  end
  
  def set_locale
    if params[:locale].blank? || I18n.available_locales.exclude?(params[:locale].to_sym)
      I18n.locale = I18n.default_locale
    else
      I18n.locale = params[:locale] || I18n.default_locale
    end
    @lang = I18n.locale.to_s
    Rails.application.routes.default_url_options[:locale] = I18n.locale
  end

end
