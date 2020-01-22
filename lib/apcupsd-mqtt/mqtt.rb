require 'mqtt'

class ApcupsdMqtt

  GENERIC_ID = 'apcups'
  MANUFACTURER_STRING = 'APC'

  HA_TYPE = 'sensor'
  HA_CONFIG = 'config'
  HA_STATE = 'state'
  HA_DEVICE_CLASS_MAPPING = {
    "bcharge" => "battery",
    "power" => "power",
    "battdate" => "timestamp",
    "date" => "timestamp",
    "starttime" => "timestamp",
    "xoffbatt" => "timestamp",
    "xonbatt" => "timestamp"
  }

  def initialize(opts)
    @opts = opts
    @client = MQTT::Client.connect(
      host: opts.mqtt_host,
      port: opts.mqtt_port,
      username: opts.mqtt_username,
      password: opts.mqtt_password,
      ssl: opts.mqtt_use_tls
    )
    @topic = opts.mqtt_topic
  end

  def publish(devicename, updates)
    updates.each do |key, payload|
      @client.publish([ @topic, devicename, key, HA_STATE ].join('/'), payload)
    end
  end

  def autodiscovery(device_name, status)

    status.each do |key, value|

      payload = {
        name: "%s (UPS on %s)" % [ key, device_name ],
        stat_t: [ @opts.mqtt_topic, device_name, key, 'state' ].join('/'),
        unique_id: [ GENERIC_ID, device_name, key ].join('_'),
        device: {
          identifiers: [ [ GENERIC_ID, status["serialno"], device_name ].join('_') ],
          name: "%s on %s" % [ status["model"], device_name ],
          sw_version: status["firmware"],
          model: "%s (%s)" % [ status["model"], status["serialno"] ],
          manufacturer: MANUFACTURER_STRING
        }
      }

      device_class = HA_DEVICE_CLASS_MAPPING[key]
      payload[:dev_cla] = device_class if device_class

      topic = [ @opts.mqtt_autodiscovery_prefix, HA_TYPE, [ GENERIC_ID, device_name ].join('_'), key, HA_CONFIG ].join('/')

      @client.publish(topic, payload.to_json)

    end
  end

end
