#!/bin/bash

#########################
#	Openbaton	#
#########################
# Author : Sakib37

# This script configures the name resolution in bind server

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

if [ -z "$realm" ]; then
	# Actually this case should not happen, only if you renamed the config values ;)
	echo "$SERVICE : there is no realm for bind9!"
	exit 1
fi

# Also load variables from the relations
if [ -f "$VARIABLE_BUCKET" ]; then
	source $VARIABLE_BUCKET
fi

if [ ! $useFloatingIpsForEntries = "false" ]; then
	if [ -z "$mgmt_floatingIp" ]; then
		echo "$SERVICE : there is no floatingIP for the mgmt network for bind9 !"
		exit 1
	else
		# Else we just overwrite the environment variable
		dns_ip=$mgmt_floatingIp
	fi
else
	dns_ip=$mgmt
fi

# get current dns and search domain
curr_dns_ip=`grep '^[[:space:]]*nameserver[[:space:]]\+' /etc/resolv.conf | head -1 | awk '{print $2}' `
curr_dns_domain=`grep '^[[:space:]]*search[[:space:]]\+' /etc/resolv.conf | head -1 | awk '{print $2}' `

# Insert forwarders to enable public domain resolution using google dns
sed -i "12i \\\tforwarders {\n\t\t127.0.0.1;\n\t\t${curr_dns_ip};\n\t\t8.8.8.8;\n\t\t8.8.4.4;\n\t};" /etc/bind/named.conf.options

# Lets update the resolv.conf file
# Make a bakup of the current file and make change in the original file
cp /etc/resolv.conf{,_backup}
printf "%s\n%s\n" "nameserver $mgmt" "search $realm" > /etc/resolv.conf

cp /etc/resolvconf/resolv.conf.d/base{,_backup}
printf "%s\n%s\n" "nameserver $mgmt" "search $realm" > /etc/resolvconf/resolv.conf.d/base

# Update the /etc/resolv.conf to be sure we have added the new nameserver
resolvconf -u
