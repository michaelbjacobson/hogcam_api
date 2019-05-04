require 'rubygems'
require 'dotenv/load'
require 'sinatra/base'
require 'sinatra/cors'
require 'thin'
require 'json'
require 'logger'
require_relative './lib/raspberry_pi'
require_relative './lib/camera'

# Raspberry Pi Interface API
class API < Sinatra::Base
  register Sinatra::Cors
  Logger.class_eval { alias_method :write, :<< }
  access_log = File.join(File.dirname(File.expand_path(__FILE__)), 'logs', 'access.log')
  access_logger = Logger.new(access_log)

  configure do
    set :allow_origin, '*'
    set :allow_methods, 'GET,HEAD,POST'
    set :allow_headers, 'content-type,if-modified-since'
    set :expose_headers, 'location,link'
    use Rack::SslEnforcer if ENV['RACK_ENV'] == 'production'
    use Rack::CommonLogger, access_logger
  end

  get '/status' do
    RaspberryPi.to_json
  end

  get '/timelapse_running' do
    RaspberryPi.running_timelapse?.to_s
  end

  post '/reboot' do
    RaspberryPi.reboot
  end

  post '/toggle_timelapse' do
    RaspberryPi.running_timelapse? ? RaspberryPi.stop_timelapse : RaspberryPi.start_timelapse
  end

  post '/capture_still' do
    RaspberryPi.capture_still unless RaspberryPi.running_timelapse?
  end

  not_found do
    redirect '/'
  end
end
