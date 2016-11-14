#!/bin/sh /etc/rc.common
#easydrcom daemon
#Author:presisco

DAEMONCOUNT=`ps | grep -c easydrcom-daemon`
DLOGPATH=$(uci get easydrcom.@easydrcom[0].dlogpath)
EZLOGPATH=$(uci get easydrcom.@easydrcom[0].ezlogpath)
DLOGMAXLINES=$(uci get easydrcom.@easydrcom[0].dloglines)
EZLOGMAXLINES=$(uci get easydrcom.@easydrcom[0].ezloglines)
INTERVAL=$(uci get easydrcom.@easydrcom[0].dinterval)

if [ $DAEMONCOUNT -ge "4" ]
then
	exit 0
else
	DATE=`date`
	echo "easydrcom daemon started at $DATE">>$DLOGPATH
	while true
	do
		sleep $INTERVAL
		
		EZLOGLINES=`awk 'END{print NR}' test1.sh`
		if [ $EZLOGLINES -gt $EZLOGMAXLINES ]
		then
			echo "" > $EZLOGPATH
		fi
		
		DLOGLINES=`awk 'END{print NR}' test1.sh`
		if [ $DLOGLINES -gt $DLOGMAXLINES ]
		then
			echo "" > $DLOGPATH
		fi
		
		PCOUNT=`ps | grep -c "easydrcom -b -r"`
		DATE=`date`
		if [ $PCOUNT -lt "1" ]
		then
			echo "easydrcom restarted at $DATE">>$DLOGPATH
			/etc/init.d/easydrcom-conf start
		fi
	done
fi