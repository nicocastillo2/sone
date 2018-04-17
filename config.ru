# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'rack-rewrite'

use Rack::Rewrite do
  r301 %r{^\/blog(\/?.*)$}, 'http://159.89.86.242/blog/$1'
end

run Rails.application
