# apcupsd-mqtt

*Collects metrics from `apcaccess` command-line utilitiy and publishes them via MQTT*

This script runs `apcaccess -u`  every two seconds and publishes the values that have changed since the last update to MQTT. The full list is published once a minute. Those intervals are currently hard-coded but I’m happy to make them configurable if someone finds this useful.

## Caution

This code is mostly untested. I’m using this for a single *APC Back UPS PRO USV 900VA - BR900G-GR* and haven’t tested any other APC devices yet.

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

apcupsd/info-pi/raw/APC 001,036,0857
apcupsd/info-pi/raw/DATE 2019-03-10 12:56:35 +0100
apcupsd/info-pi/raw/HOSTNAME info-pi
apcupsd/info-pi/raw/VERSION 3.14.14 (31 May 2016) debian
apcupsd/info-pi/raw/UPSNAME info-pi
apcupsd/info-pi/raw/CABLE USB Cable
apcupsd/info-pi/raw/DRIVER USB UPS Driver
apcupsd/info-pi/raw/UPSMODE Stand Alone
apcupsd/info-pi/raw/STARTTIME 2019-03-10 12:50:31 +0100
apcupsd/info-pi/raw/MODEL Back-UPS RS 900G
apcupsd/info-pi/raw/STATUS ONLINE
apcupsd/info-pi/raw/LINEV 226.0
apcupsd/info-pi/linev 226.0
apcupsd/info-pi/raw/LOADPCT 8.0
apcupsd/info-pi/loadpct 8.0
apcupsd/info-pi/raw/BCHARGE 100.0
apcupsd/info-pi/bcharge 100.0
apcupsd/info-pi/raw/TIMELEFT 153.0
apcupsd/info-pi/timeleft 153.0
apcupsd/info-pi/raw/MBATTCHG 5
apcupsd/info-pi/mbattchg 5
apcupsd/info-pi/raw/MINTIMEL 3
apcupsd/info-pi/mintimel 3
apcupsd/info-pi/raw/MAXTIME 0
apcupsd/info-pi/maxtime 0
apcupsd/info-pi/raw/SENSE Medium
apcupsd/info-pi/raw/LOTRANS 176.0
apcupsd/info-pi/lotrans 176.0
apcupsd/info-pi/raw/HITRANS 294.0
apcupsd/info-pi/hitrans 294.0
apcupsd/info-pi/raw/ALARMDEL 30
apcupsd/info-pi/alarmdel 30
apcupsd/info-pi/raw/BATTV 27.1
apcupsd/info-pi/battv 27.1
apcupsd/info-pi/raw/LASTXFER Low line voltage
apcupsd/info-pi/raw/NUMXFERS 0
apcupsd/info-pi/numxfers 0
apcupsd/info-pi/raw/TONBATT 0
apcupsd/info-pi/tonbatt 0
apcupsd/info-pi/raw/CUMONBATT 0
apcupsd/info-pi/cumonbatt 0
apcupsd/info-pi/raw/XOFFBATT N/A
apcupsd/info-pi/raw/SELFTEST NO
apcupsd/info-pi/raw/STATFLAG 0x05000008
apcupsd/info-pi/raw/SERIALNO 4B1847P11007
apcupsd/info-pi/raw/BATTDATE 2018-11-21
apcupsd/info-pi/raw/NOMINV 230
apcupsd/info-pi/nominv 230
apcupsd/info-pi/raw/NOMBATTV 24.0
apcupsd/info-pi/nombattv 24.0
apcupsd/info-pi/raw/NOMPOWER 540
apcupsd/info-pi/nompower 540
apcupsd/info-pi/raw/FIRMWARE 879.L4 .I USB FW:L4
apcupsd/info-pi/power 43.2
apcupsd/info-pi/raw/APC 001,036,0857
apcupsd/info-pi/raw/DATE 2019-03-10 12:56:35 +0100
apcupsd/info-pi/date 2019-03-10T12:56:35+01:00
apcupsd/info-pi/raw/HOSTNAME info-pi
apcupsd/info-pi/raw/VERSION 3.14.14 (31 May 2016) debian
apcupsd/info-pi/raw/UPSNAME info-pi
apcupsd/info-pi/raw/CABLE USB Cable
apcupsd/info-pi/raw/DRIVER USB UPS Driver
apcupsd/info-pi/raw/UPSMODE Stand Alone
apcupsd/info-pi/raw/STARTTIME 2019-03-10 12:50:31 +0100
apcupsd/info-pi/starttime 2019-03-10T12:50:31+01:00
apcupsd/info-pi/raw/MODEL Back-UPS RS 900G
apcupsd/info-pi/raw/STATUS ONLINE
apcupsd/info-pi/raw/LINEV 226.0
apcupsd/info-pi/linev 226.0
apcupsd/info-pi/raw/LOADPCT 8.0
apcupsd/info-pi/loadpct 8.0
apcupsd/info-pi/raw/BCHARGE 100.0
apcupsd/info-pi/bcharge 100.0
apcupsd/info-pi/raw/TIMELEFT 153.0
apcupsd/info-pi/timeleft 153.0
apcupsd/info-pi/raw/MBATTCHG 5
apcupsd/info-pi/mbattchg 5
apcupsd/info-pi/raw/MINTIMEL 3
apcupsd/info-pi/mintimel 3
apcupsd/info-pi/raw/MAXTIME 0
apcupsd/info-pi/maxtime 0
apcupsd/info-pi/raw/SENSE Medium
apcupsd/info-pi/raw/LOTRANS 176.0
apcupsd/info-pi/lotrans 176.0
apcupsd/info-pi/raw/HITRANS 294.0
apcupsd/info-pi/hitrans 294.0
apcupsd/info-pi/raw/ALARMDEL 30
apcupsd/info-pi/alarmdel 30
apcupsd/info-pi/raw/BATTV 27.1
apcupsd/info-pi/battv 27.1
apcupsd/info-pi/raw/LASTXFER Low line voltage
apcupsd/info-pi/raw/NUMXFERS 0
apcupsd/info-pi/numxfers 0
apcupsd/info-pi/raw/TONBATT 0
apcupsd/info-pi/tonbatt 0
apcupsd/info-pi/raw/CUMONBATT 0
apcupsd/info-pi/cumonbatt 0
apcupsd/info-pi/raw/XOFFBATT N/A
apcupsd/info-pi/raw/SELFTEST NO
apcupsd/info-pi/raw/STATFLAG 0x05000008
apcupsd/info-pi/raw/SERIALNO XXXXXXXXXXXX
apcupsd/info-pi/raw/BATTDATE 2018-11-21
apcupsd/info-pi/battdate 2018-11-21T00:00:00+01:00
apcupsd/info-pi/raw/NOMINV 230
apcupsd/info-pi/nominv 230
apcupsd/info-pi/raw/NOMBATTV 24.0
apcupsd/info-pi/nombattv 24.0
apcupsd/info-pi/raw/NOMPOWER 540
apcupsd/info-pi/nompower 540
apcupsd/info-pi/raw/FIRMWARE 879.L4 .I USB FW:L4
apcupsd/info-pi/power 43.2
```
