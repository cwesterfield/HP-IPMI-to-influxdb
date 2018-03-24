#!/bin/bash
#Create table of output for Influxdb

SENSOR=`which ipmitool`
CURL==`which curl`
SENSOR_RAW=/tmp/SENSOR.raw
#SENSOR_CLN=/tmp/SENSOR.log
SENSOR_IMP=/tmp/sensor.import
TIME=`date`

##Insert Date for testing
echo $TIME > $SENSOR_RAW

##Get Sensor Info
$SENSOR -I open sensor >> $SENSOR_RAW

##Empty old import file
rm $SENSOR_IMP


##Split Flat file into chunks
#Fans
for i in $SENSOR_RAW
 do
  cat $i | grep "Fan " | awk -F "|" {'print "fan,host=hp_380_g6,fan="$1,"percentage=",$2'} | tr -s '[:space:]' | sed 's/Fan\ /Fan\\ /g; s/percentage= /percentage=/g' >> $SENSOR_IMP
 done

#Temps
for j in $SENSOR_RAW
 do
  cat $j | grep "Temp " | awk -F "|" {'print "temp,host=hp_380_g6,temp="$1,"DegInC=",$2'} | tr -s '[:space:]' | sed 's/Temp /Temp\\ /g ; s/InC= /InC=/g; s/\<[0-9]\>/0&/' | grep -v na >> $SENSOR_IMP
 done

#Power

  cat $SENSOR_RAW | grep "Meter" | awk -F "|" {'print "power,host=hp_380_g6,power="$1,"watts=",$2'} | tr -s '[:space:]' | sed 's/Power /Power\\ /g ; s/watts= /watts=/g' >> $SENSOR_IMP


#IMPORT!

curl -i -XPOST 'http://10.0.1.100:8086/write?db=ipmi' --data-binary @$SENSOR_IMP
