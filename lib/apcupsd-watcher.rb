require 'time'
require 'json'

require 'apcupsd-mqtt/mqtt'
require 'apcupsd-mqtt/utilities'

class ApcupsdWatcher

  UPDATE_INTERVAL = 2
  FULL_PUSH_INTERVAL = 60 # needs to be larger than UPDATE_INTERVAL
  STATUS_COMMAND = 'apcaccess -u'
  # STATUS_COMMAND = 'ssh info-pi /sbin/apcaccess -u'
  COMMAND_TIMEOUT = 2
  FLOAT_FIELDS = [ 'LINEV', 'LOADPCT', 'BCHARGE', 'TIMELEFT', 'LOTRANS', 'HITRANS', 'BATTV', 'NOMBATTV' ]
  INT_FIELDS = [ 'MBATTCHG', 'MINTIMEL', 'MAXTIME', 'ALARMDEL', 'NUMXFERS', 'TONBATT', 'CUMONBATT', 'NOMINV', 'NOMPOWER' ]
  DATE_FIELDS = [ 'BATTDATE', 'DATE', 'STARTTIME', 'XOFFBATT', 'XONBATT' ]
  IGNORED_FIELDS = [ 'END APC' ]

  def initialize(opts)
    @upsname = 'unknown'

    begin
      @mqtt = ApcupsdMqtt.new(opts)
    rescue => e
      raise "Failed to connect to MQTT server (%s)" % e
    end
  end

  def run_loop
    status = nil
    loop_counter = 0

    loop do
      loop_counter += 1

      begin
        new_status = parse_apcaccess_output(get_apcaccess_output(STATUS_COMMAND, COMMAND_TIMEOUT))
      rescue Errno::ENOENT
        return "Failed to get UPS status (apcaccess not in path?)"
      rescue Timeout::Error
        return "Failed to get UPS status in time (execution took more than %.2f seconds)" % COMMAND_TIMEOUT
      end

      if loop_counter * UPDATE_INTERVAL >= FULL_PUSH_INTERVAL
        # set status to nil, so the next `publish_updates` will send everything
        status = nil
        loop_counter = 0
      end

      @mqtt.autodiscovery(@upsname, new_status) if status == nil
      publish_updates(status, new_status)

      status = new_status
      sleep UPDATE_INTERVAL
    end
  end

  private

  def publish_updates(old_status, new_status)
    updates = get_updates(old_status, new_status)
    return if updates.empty?
    @mqtt.publish(@upsname, updates)
  end

  def get_updates(old_status, new_status)
    return new_status unless old_status

    changes = {}
    new_status.each do |key, value|
      if !old_status[key] || old_status[key] != value
        changes[key] = value
      end
    end
    changes
  end

  def get_apcaccess_output(cmd, timeout)
    output = Utilities::exec_with_timeout(cmd, timeout)
  end

  def parse_apcaccess_output(str)
    dict = {}
    str.split("\n").map! do |line|
      key, value = line.split(":", 2)
      key.strip!

      next if IGNORED_FIELDS.include? key

      value.strip!
      parsed = nil

      if INT_FIELDS.include? key
        parsed = Integer(value)
      elsif FLOAT_FIELDS.include? key
        parsed = Float(value)
      elsif DATE_FIELDS.include? key and value != 'N/A'
        parsed = Time.parse(value).iso8601
      end

      @upsname = value if key == 'UPSNAME'

      dict[key.downcase] = parsed != nil ? parsed : value
    end
    add_extra_fields(dict)
  end

  def add_extra_fields(dict)
    if dict['loadpct'] != nil and dict['nompower'] != nil
      dict['power'] = calcucate_power(dict['loadpct'], dict['nompower'])
    end
    dict
  end

  def calcucate_power(load_pct, nom_power)
    load_pct / 100 * nom_power
  end

end
