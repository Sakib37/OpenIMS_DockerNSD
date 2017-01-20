#!/bin/bash
#########################
#	Openbaton	#
#########################
# Author : Sakib37

# If there are default options load them 
if [ -f "$SCRIPTS_PATH/default_options" ]; then
	source $SCRIPTS_PATH/default_options
fi 

# pcscf start script

# Check if there was a pcscf running already

PID=`pidof -x $SERVICE.sh`
if [ $PID ]; then
    echo -e "\n$SERVICE is already running! Restarting $SERVICE\n";
    kill -9 $(pidof -x $SERVICE.sh)
    kill -9 $(pidof ser)
    /opt/OpenIMSCore/$SERVICE.sh > /dev/null 2>&1 &
else
    echo -e "\n $SERVICE is not running. Starting $SERVICE \n";
    cd /opt/OpenIMSCore
    cp -r ./ser_ims/cfg/* .
    /opt/OpenIMSCore/$SERVICE.sh > /dev/null 2>&1 &
fi

