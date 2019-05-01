$LOAD_PATH.unshift File.dirname(__FILE__)
require 'dependencies'

# Raspberry Pi Interface API
class API < Sinatra::Base
  Logger.class_eval { alias_method :write, :<< }
  access_log = File.join(File.dirname(File.expand_path(__FILE__)), 'logs', 'access.log')
  access_logger = Logger.new(access_log)

  configure do
    use Rack::CommonLogger, access_logger
  end

  helpers do
    def raspi
      ENV['APP_ENV'] == 'deployment' ? RaspberryPi : MockPi
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
end
