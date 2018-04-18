require_relative 'boot'
require 'pp'
require 'csv'
require 'rails/all'
# require 'rack/rewrite'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sone
  class Application < Rails::Application
    
    # config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
      # r301 %r{^\/blog(\/?.*)$}, 'http://159.89.86.242/blog/$1'
      # # r301 %r{/blog/(\w+\/?)}, 'http://159.89.86.242/blog/$1'
    # end
    
    config.middleware.insert(0, Rack::ReverseProxy) do
      reverse_proxy_options preserve_host: true
      reverse_proxy_options force_ssl: true, replace_response_host: true
      reverse_proxy_options x_forwarded_headers: true
      reverse_proxy /^\/blog(\/?.*)$/, 'http://blog.sone-app.com/blog/$1'
    end
    
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.i18n.available_locales = [ 'es-ES', 'es-MX']
    config.i18n.default_locale = 'es-ES'
    config.time_zone = 'London'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
