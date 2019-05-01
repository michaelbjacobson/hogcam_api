require 'rubygems'
require 'dotenv/load'
require 'sinatra/base'
require 'sinatra/cors'
require 'thin'
require 'json'
require 'logger'
require_relative './lib/raspberry_pi'
require_relative './lib/mock_pi'
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
    use Rack::CommonLogger, access_logger
  end

  helpers do
    def raspi
      ENV['RACK_ENV'] == 'production' ? RaspberryPi : MockPi
    end
  end

  get '/status' do
    raspi.to_json
  end

  get '/timelapse_running' do
    raspi.running_timelapse?.to_s
  end

  post '/reboot' do
    raspi.reboot
  end

  post '/toggle_timelapse' do
    raspi.running_timelapse? ? raspi.stop_timelapse : raspi.start_timelapse
  end

  post '/capture_still' do
    raspi.capture_still unless raspi.running_timelapse?
  end

  not_found do
    redirect '/'
  end
end
