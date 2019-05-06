require_relative './camera'

# Raspberry Pi interface
class RaspberryPi
  def self.temp
    temp = `/usr/local/bin/temp`.strip
    "#{temp}°C"
  end

  def self.camera_status
    Camera.status
  end

  def self.mem
    `/usr/local/bin/mem`.strip
  end

  def self.timelapse_active?
    `/usr/local/bin/timelapse active`.strip == 'true'
  end

  def self.stream_active?
    `/usr/local/bin/stream active`.strip == 'true'
  end

  def self.uptime
    uptime = `echo $(awk '{print $1}' /proc/uptime)`.to_i
    duration = Time.at(uptime).utc
    hours = duration.strftime('%H').to_i
    minutes = duration.strftime('%M').to_i
    minutes_str = (minutes == 1 ? "#{minutes} minute" : "#{minutes} minutes")
    return minutes_str unless hours > 0

    hours_str = (hours > 1 ? "#{hours} hours" : "#{hours} hour")
    "#{hours_str}, #{minutes_str}"
  end

  def self.update_preview
    system('/usr/local/bin/update_preview')
  end

  def self.start_timelapse
    system('nohup /usr/local/bin/timelapse start >/dev/null &')
  end

  def self.stop_timelapse
    system('/usr/local/bin/timelapse stop')
  end

  def self.start_stream
    system('nohup /usr/local/bin/stream start >/dev/null &')
  end

  def self.stop_stream
    system('/usr/local/bin/stream stop')
  end

  def self.reboot
    system('sudo reboot')
  end

  def self.status
    {
      coreTemperature: temp,
      availableStorage: mem,
      cameraStatus: camera_status,
      uptime: uptime
    }
  end
end
