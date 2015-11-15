#!/bin/bash

#run using cron with the following command as an example for updating every five minutes
#*/5 * * * * sudo sh /mnt/onewire_update.sh

# READ SENSORS
tempinside1read=`cat /mnt/1wire/7E.B72400001000/EDS0066/temperature`
tempoutside1read=`cat /mnt/1wire/28.BA4918040000/temperature`
pressure1read=`cat /mnt/1wire/7E.B72400001000/EDS0066/pressure`
rain1read=`cat /mnt/1wire/1D.1CD30D000000/counters.B`
humidity1read=`cat /mnt/1wire/26.00328F010000/humidity`
humiditytemp1read=`cat /mnt/1wire/26.00328F010000/temperature`

# FORMAT SENSOR DATA
tempinside1=`echo $tempinside1read | cut -c -4`
tempoutside1=`echo $tempoutside1read | cut -c -4`
pressure1=`echo $pressure1read | cut -c -6`
rain1=`echo $rain1read`
humoutside1=`echo $humidity1read`
humoutsidetemp1=`echo $humiditytemp1read | cut -c -4`

# PRINT OUT VALUES FOR DEBUG PURPOSES IF NEEDED
#echo $tempinside1read
#echo $tempoutside1read
#echo $pressure1read
#echo $rain1read

# CONVERT VALUES TO STRINGS
tempinside1=$tempinside1read
tempoutside1=$tempoutside1read
pressure1=$pressure1read
rain1=$rain1read
humoutside1=$humidity1read
humoutsidetemp1=$humiditytemp1read



# UPDATE MYSQL DATABASE
echo
mysql -uroot -praspberry owfs <<EOF
#insert into sensor_data (insidetemperature1) values ('${tempinside1}');
#insert into sensor_data (outsidetemperature1) values ('${tempoutside1}');
#insert into sensor_data (outsidehumidity1) values ('${humoutside1}');
#insert into sensor_data (outsidehumiditytemp1) values ('${humoutsidetemp1}');
#insert into sensor_data (pressure1) values ('${pressure1}');
#insert into sensor_data (rain1) values ('${rain1}');
insert into sensor_data (insidetemperature1, outsidetemperature1, outsidehumidity1, outsidehumiditytemp1, pressure1, rain1) values ('${tempinside1}', '${tempoutside1}', '${humoutside1}', '${humoutsidetemp1}', '${pressure1}', '${rain1}');
EOF
