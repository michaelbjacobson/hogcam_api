require 'rubygems'
require 'dotenv/load'
require 'sinatra/base'
require 'sinatra/cors'
require 'thin'
require 'rack/ssl-enforcer'
require 'json'
require 'logger'
require_relative './lib/raspberry_pi'
require_relative './lib/camera'

# Raspberry Pi Interface App
class App < Sinatra::Base
  register Sinatra::Cors
  Logger.class_eval { alias_method :write, :<< }
  access_log = File.join(File.dirname(File.expand_path(__FILE__)), 'logs', 'access.log')
  access_logger = Logger.new(access_log)

  configure do
    # set :allow_origin, '*'
    set :allow_origin, 'https://www.hedgehog.watch'
    set :allow_methods, 'GET,POST'
    set :allow_headers, 'content-type,if-modified-since'
    set :expose_headers, 'location,link'
    use Rack::SslEnforcer if ENV['RACK_ENV'] == 'production'
    use Rack::CommonLogger, access_logger
  end

  # before do
  #   halt 418, "I'm a teapot!" if request.params['key'] != ENV['HOGCAM_API_KEY']
  # end

  get '/status' do
    RaspberryPi.status.to_json
  end

  get '/timelapse/active' do
    RaspberryPi.timelapse_active?.to_s
  end

  post '/reboot' do
    RaspberryPi.reboot
  end

  post '/timelapse/toggle' do
    RaspberryPi.toggle_timelapse
  end

  post '/update_preview' do
    RaspberryPi.update_preview
  end

  not_found do
    redirect '/'
  end
end
