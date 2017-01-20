#!/bin/bash
#########################
#	Openbaton	#
#########################
# Author : Sakib37

# If there are default options load them 
if [ -f "$SCRIPTS_PATH/default_options" ]; then
	source $SCRIPTS_PATH/default_options
fi 

# pcscf stop script

# Check if there pcscf waiting already
PID=`pidof -x $SERVICE.sh`
if [ $PID ]; then
    echo -e "\n$SERVICE is already running! Stopping $SERVICE \n";
    kill -9 $(pidof -x $SERVICE.sh)
    kill -9 $(pidof ser)
else
    echo -e "\n $SERVICE: already stopped \n";
fi
