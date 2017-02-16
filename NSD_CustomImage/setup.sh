#!/bin/bash

# Docker user must have sudo permission to run this script
# Location where https://github.com/openbaton/openimscore-packages is cloned
NSD_LOCATION="/home/sakib/OpenIMS_NSD/openimscore-packages"
IMAGE="ubuntu:14.04"
NETWORK_NAME="mgmt"
declare -a Services=('bind9' 'fhoss' 'icscf' 'pcscf' 'scscf');
# '-e ' at the beginning of the string get skipped in bash
# so '-idt' is added here so that -e at the beginning will not be skipped
bind9_params='-idt -e realm=epc.mnc001.mcc001.3gppnetwork.org  -e useFloatingIpsForEntries=true'
fhoss_params='-idt -e diameter_port=3868  -e name=hss' 
icscf_params='-idt -e port=5060  -e name=icscf  -e diameter_port=3869'
pcscf_params='-idt -e port=4060  -e name=pcscf'
scscf_params='-idt -e port=6060  -e name=scscf  -e diameter_port=3870'

# Functions 
remove(){
    echo "Deleting all the service containers"
    for service in "${Services[@]}"
    do
        docker rm -f $service 
    done
    echo "Deleted all the containers"
    echo "Deleting all the networks"
    docker network rm $NETWORK_NAME
    echo "Deleted all the networks"
}

install(){
    echo "Creating network ${NETWORK_NAME}"
    docker network create $NETWORK_NAME
    echo "done"
    for service in "${Services[@]}"
    do
        echo "***********Preparing container for $service************"
	eval "curr_param=\$${service}_params"
        port=""
        for str in $curr_param; do
	    if `echo $str | grep -q 'port'` ; then
		port_num=`echo $str | awk -F  "=" ' {print $2}'`
		port="$port -p $port_num:$port_num"
            fi
	done
	# NOTE: -e at the beginning of curr_param get escaper. The following can be a solution
	#echo " $port '-e ' $curr_params --name=${service} --network=$NETWORK_NAME $IMAGE"
        #command=" $curr_param --name=${service} --network=$NETWORK_NAME $IMAGE"
	#echo "Command : $curr_param"
	#docker run $command
	docker run $curr_param --name=${service} --network=$NETWORK_NAME $IMAGE
        script_loc="$NSD_LOCATION/${service}/scripts"
        docker cp $script_loc ${service}:/
        docker exec $service apt-get update &> /dev/null
    done
    echo "done"
    
}


#calling required function
options=("install" "remove")
select opt in "${options[@]}"
do
    case $opt in
        "install")
            install
            break
            ;;
        "remove")
            remove
            break
            ;;
        *) echo invalid option;;
   esac
done

