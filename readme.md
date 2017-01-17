#Introduction
This is a script that collects sensor information from ipmitool on an HP 380 G6 running Proxmox, formats it, and then inserts it into an influxdb database named "ipmi".

#Requirements 
1. Linux OS (in this case proxmox using debian)
1. ipmitool 
1. freeipmi
1. loaded modules

###To install
```
sudo apt-get install ipmitool freeipmi-tools -y
modprobe ipmi_si type=kcs ports=0xCA2 regspacings=1
modprobe ipmi_devintf
modprobe ipmi_msghandler
modprobe ipmi_poweroff
modprobe ipmi_watchdog
```

You must also have a database named ipmi created on the influxdb machine. 
`cwesterfield@influxdb~/# influx -execute 'create database ipmi'`

#My environment
My influxdb server lives at 10.0.1.100
