require 'mqtt'

class ApcupsdMqtt

  def initialize(opts)
    @client = MQTT::Client.connect(
      host: opts.mqtt_host,
      port: opts.mqtt_port,
      username: opts.mqtt_username,
      password: opts.mqtt_password,
      ssl: opts.mqtt_use_tls
    )
    @topic = opts.mqtt_topic
  end

  def publish(updates, prefix='')
    updates.each do |key, value|
      @client.publish("%s/%s%s" % [ @topic, prefix, key ], value)
    end
  end

end
