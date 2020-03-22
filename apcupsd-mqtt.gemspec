Gem::Specification.new do |s|
  s.name           = 'apcupsd-mqtt'
  s.version        = '0.2.0'
  s.date           = '2020-03-22'
  s.summary        = "apcupsd MQTT"
  s.description    = "Collects metrics from apcaccess command-line utilitiy and publishes them via MQTT"
  s.authors        = ["aaronk6"]
  s.email          = ["code@aaronk.me"]
  s.files          = [ "lib/apcupsd-watcher.rb", "lib/apcupsd-mqtt/mqtt.rb", "lib/apcupsd-mqtt/utilities.rb", "bin/apcupsd-mqtt"]
  s.executables    << "apcupsd-mqtt"
  s.homepage       = 'https://github.com/aaronk6'
  s.license        = 'MIT'

  s.add_runtime_dependency 'mqtt', '~> 0.5.0'
end
