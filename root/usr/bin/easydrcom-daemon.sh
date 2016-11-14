#!/bin/bash
#/etc/rc.common
#easydrcom daemon

DAEMONCOUNT=`ps | grep -c easydrcom-daemon`
if [ $DAEMONCOUNT -ge "4" ]
then
	echo "easydrcom daemon already running!"
	exit 0
else
	echo "easydrcom daemon started!"
	while true
	do
		sleep 60
		rm $(uci get easydrcom.@easydrcom[0].logpath)
		PCOUNT=`ps | grep -c "easydrcom -b -r"`
		if [ $PCOUNT -lt "2" ]
		then
			echo "easydrcom restarted"
			/etc/init.d/easydrcom-conf start
		fi
	done
fi

