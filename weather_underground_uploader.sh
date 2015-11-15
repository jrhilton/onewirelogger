#!/bin/sh

#sql user name = root
#sql password = raspberry
#server = localhost
#table = owfs
#see the accompanying sql file for the structure

#run ever 15m using cron using the following:
#*/15 * * * * sudo sh /mnt/weatheruupload.sh

#sleep for 15 s to let the system settle and all sensors to be read and data written to the SQL database.
sleep 15

#TEMPERATURE
outsidetemp1=$(mysql -D owfs -s -uroot -praspberry -e "SELECT outsidetemperature1 FROM sensor_data ORDER BY ID DESC LIMIT 1")

#PRESSURE
pressure1=$(mysql -D owfs -s -uroot -praspberry -e "SELECT pressure1 FROM sensor_data ORDER BY ID DESC LIMIT 1")

#HUMIDITY
humidity1=$(mysql -D owfs -s -uroot -praspberry -e "SELECT outsidehumidity1 FROM sensor_data ORDER BY ID DESC LIMIT 1")

#RAIN SINCE MIDNIGHT
rain1bucketsmax=$(mysql -D owfs -s -uroot -praspberry -e "SELECT MAX(rain1) FROM sensor_data WHERE DATE(created_at) = CURDATE()")
rain1bucketsmin=$(mysql -D owfs -s -uroot -praspberry -e "SELECT MIN(rain1) FROM sensor_data WHERE DATE(created_at) = CURDATE()")
rainsincemidnightinch=`echo "scale=4; 0.01*($rain1bucketsmax-$rain1bucketsmin)" | bc`

#RAIN IN THE LAST HOUR
rain1bucketsmaxinlast15=$(mysql -D owfs -s -uroot -praspberry -e "SELECT MAX(rain1) FROM sensor_data WHERE created_at > date_sub(now(), interval 15 minute)")
rain1bucketsmininlast15=$(mysql -D owfs -s -uroot -praspberry -e "SELECT MIN(rain1) FROM sensor_data WHERE created_at > date_sub(now(), interval 15 minute)")
rainrateperhourinch=`echo "scale=4; 4*0.01*($rain1bucketsmaxinlast15-$rain1bucketsmininlast15)" | bc`

# WEATHER UNDERGROUND UPLOAD

#DEFINE BASE URL & USERNAME
urlp1='http://weatherstation.wunderground.com/weatherstation/updateweatherstation.php?ID=******&PASSWORD=******&dateutc='

# TEMPERATURE1
act_temp_c=$tempoutside1
tempfah=$(echo "scale=4; ($outsidetemp1 * 1.8)+32" |bc)
tempfartext="&tempf="
urlp2=$tempfartext$tempfah

# HUMIDITY
humiditytext="&humidity="
humidity1adj=$(echo "scale=4; (($humidity1 / 160)*100)+28" |bc)
urlp3=$humiditytext$humidity1adj

# DEWPOINT
dewpointc=$(echo "scale=4; $outsidetemp1 - ((100 - $humidity1adj) / 5)" |bc)
#dewpoint=$(echo "$tempfah - ((9 / 25)*(100 - $humidity1))" |bc)
dewpointf=$(echo "scale=4; ($dewpointc * 1.8)+32" |bc)
dewpointtext="&dewptf="
urlp4=$dewpointtext$dewpointf
echo $dewpointc

# PRESSURE
act_pressure_inch=$(echo "scale=4; $pressure1 * 0.0295333727" |bc)
pressuretext="&baromin="
urlp5=$pressuretext$act_pressure_inch

# RAIN RATE PER HOUR
raintext="&rainin="
urlp6=$raintext$rainrateperhourinch

# RAIN SINCE MIDNIGHT
rain_since_midnight_text="&dailyrainin="
urlp7=$rain_since_midnight_text$rainsincemidnightinch

#SOFTWARE TYPE
urlp8='&softwaretype=One%20Wire'

#ACTION
urlp9='&action=updateraw'

#SLEEP, GET TIME, COMBINE ALL DATA
stationtime=$(date "+%Y-%m-%d%T")
combined1=$urlp1$stationtime$urlp2$urlp3$urlp4$urlp5$urlp6$urlp7$urlp8$urlp9

#SUBMIT TO WEATHER UNDERGROUND
curl -sS --connect-timeout 15 --max-time 30 "$combined1"
