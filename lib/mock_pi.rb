require 'json'

# Mock Raspberry Pi interface
class MockPi
  def self.temp
    '56.4°C'
  end

  def self.camera_status
    'OK'
  end

  def self.mem
    '11.36 GB (82%)'
  end

  def self.running_timelapse?
    @running_timelapse
  end

  def self.running_stream?
    @running_stream
  end

  def self.uptime
    '1 hour, 40 minutes'
  end

  def self.capture_still
    true
  end

  def self.start_timelapse
    @running_timelapse = true
  end

  def self.stop_timelapse
    @running_timelapse = false
  end

  def self.start_stream
    @running_stream = true
  end

  def self.stop_stream
    @running_stream = false
  end

  def self.reboot
    true
  end

  def self.to_json
    status = {
      coreTemperature: temp,
      availableStorage: mem,
      cameraStatus: camera_status,
      uptime: uptime
    }
    status.to_json
  end
end
