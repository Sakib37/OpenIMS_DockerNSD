#!/bin/bash
#########################
#	Openbaton	#
#########################
# Author : lgr
#        : Sakib37

# scscf bind9 relation joined script

# If there are default options load them 
if [ -f "$SCRIPTS_PATH/default_options" ]; then
	source $SCRIPTS_PATH/default_options
fi 

if [ -z "$SCRIPTS_PATH" ]; then
	echo "$SERVICE : Using default script path $SCRIPTS_PATH"
	SCRIPTS_PATH="/scripts"
else
	echo "$SERVICE : Using custom script path $SCRIPTS_PATH"
fi

VARIABLE_BUCKET="$SCRIPTS_PATH/.variables"

# Check for bind9 realm related information
if [ -z "$bind9_realm" ]; then
	# Actually this case should not happen, only if you renamed the config values ;)
	echo "$SERVICE : bind9_realm not defined, will use default : openims.test"
	bind9_realm="openims.test"
fi

if [ -z "$mgmt" ]; then
	# Actually this case should not happen, only if you renamed the config values ;)
	echo "$SERVICE : there is not mgmt network!"
	exit 1
fi

if [ -z "$bind9_mgmt" ]; then
	# Actually this case should not happen, only if you renamed the config values ;)
	echo "$SERVICE : there is not mgmt network for bind9!"
	exit 1
fi

if [ ! -z "$bind9_useFloatingIpsForEntries" ]; then
	echo "$SERVICE : bind9_useFloatingIpsForEntries : $bind9_useFloatingIpsForEntries"
	if [ ! $bind9_useFloatingIpsForEntries = "false" ]; then
		if [ -z "$bind9_mgmt_floatingIp" ]; then
			echo "$SERVICE : there is no floatingIP for the mgmt network for bind9 !"
			exit 1
		else
			# Else we just overwrite the environment variable
			bind9_mgmt=$bind9_mgmt_floatingIp
		fi
	fi
fi

# Lets update the resolv.conf file
# Make a bakup of the current file and make change in the original file
cp /etc/resolv.conf{,_backup}
printf "%s\n%s\n" "nameserver $bind9_mgmt" "search $bind9_realm" > /etc/resolv.conf

cp /etc/resolvconf/resolv.conf.d/base{,_backup}
printf "%s\n%s\n" "nameserver $bind9_mgmt" "search $bind9_realm" > /etc/resolvconf/resolv.conf.d/base

# Update the /etc/resolv.conf to be sure we have added the new nameserver
resolvconf -u
