# apcupsd-mqtt

*Collects metrics from `apcaccess` command-line utilitiy and publishes them via MQTT*

This script runs `apcaccess -u` every two seconds and publishes the values that have changed since the last update to MQTT. The full list is published once a minute. Those intervals are currently hard-coded but I’m happy to make them configurable if someone finds this useful.

It also performs auto-discovery to make the UPS available in Home Assistant.

## Prerequisites

`apcupsd` needs to be installed and properly configured, which means the `apcaccess` utilitiy needs to work.

## Usage

```
Usage: apcupsd-mqtt [options]

Specific options:
        --mqtt-host HOST             MQTT host
        --mqtt-port PORT             MQTT port
        --mqtt-username USERNAME     MQTT username
        --mqtt-password PASSWORD     MQTT password
        --[no-]mqtt-tls              MQTT connect via TLS
        --mqtt-topic TOPIC           MQTT topic to send updates to
        --mqtt-autodiscovery-prefix PREFIX
                                     Prefix for MQTT auto-discovery
```

## Example

**Start sending metrics:**

```
$ apcupsd-mqtt --mqtt-host homeserver
```

**Watch data being published via MQTT:**

_(requires Mosquitto to be installed)_

```
$ mosquitto_sub -v -h homeserver -t 'apcupsd/#'
apcupsd/info-pi/apc/state 000,000,0000
apcupsd/info-pi/date/state 2020-01-22T23:26:52+01:00
apcupsd/info-pi/hostname/state info-pi
apcupsd/info-pi/version/state 3.14.14 (31 May 2016) debian
apcupsd/info-pi/upsname/state info-pi
apcupsd/info-pi/cable/state USB Cable
apcupsd/info-pi/driver/state USB UPS Driver
apcupsd/info-pi/upsmode/state Stand Alone
apcupsd/info-pi/starttime/state 2020-01-19T19:59:53+01:00
apcupsd/info-pi/model/state Back-UPS RS 900G
apcupsd/info-pi/status/state ONLINE
apcupsd/info-pi/linev/state 229.0
apcupsd/info-pi/loadpct/state 9.0
apcupsd/info-pi/bcharge/state 100.0
apcupsd/info-pi/timeleft/state 128.2
apcupsd/info-pi/mbattchg/state 5
apcupsd/info-pi/mintimel/state 3
apcupsd/info-pi/maxtime/state 0
apcupsd/info-pi/sense/state Medium
apcupsd/info-pi/lotrans/state 176.0
apcupsd/info-pi/hitrans/state 294.0
apcupsd/info-pi/alarmdel/state 30
apcupsd/info-pi/battv/state 27.1
apcupsd/info-pi/lastxfer/state Automatic or explicit self test
apcupsd/info-pi/numxfers/state 0
apcupsd/info-pi/tonbatt/state 0
apcupsd/info-pi/cumonbatt/state 0
apcupsd/info-pi/xoffbatt/state N/A
apcupsd/info-pi/selftest/state NO
apcupsd/info-pi/statflag/state 0x05000008
apcupsd/info-pi/serialno/state XXXXXXXXXXXX
apcupsd/info-pi/battdate/state 2018-11-21T00:00:00+01:00
apcupsd/info-pi/nominv/state 230
apcupsd/info-pi/nombattv/state 24.0
apcupsd/info-pi/nompower/state 540
apcupsd/info-pi/firmware/state 879.L4 .I USB FW:L4
apcupsd/info-pi/power/state 48.6
```
