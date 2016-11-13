#!/bin/bash
#/etc/rc.common
#easydrcom daemon

while true
do
	sleep 60
	PCOUNT=`ps | grep -c easydrcom`
	if [ $PCOUNT -lt "2" ]
	then
		/etc/init.d/easydrcom-conf easydrcom_start
	fi
done