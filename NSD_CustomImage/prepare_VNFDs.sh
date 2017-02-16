#!/bin/bash

# This scripts creates all the .tar file of VNF packages
# Run this script when all the VNF packages are configured
bind9_DIR='packages/bind9'
fhoss_DIR='packages/fhoss'
pcscf_DIR='packages/pcscf'
scscf_DIR='packages/scscf'
icscf_DIR='packages/icscf'

declare -a packages=(bind9 fhoss pcscf scscf icscf)

for i in "${packages[@]}"
do
	echo "Preparing VNF Package for $i"
	package_dir=${i}_DIR
	cd ${!package_dir}
	# Delete pacakge.tar file if already exists
	if [ -f $i.tar ] ; then
		echo "Deleting old $i.tar file"
    		rm $file > /dev/null 2>&1
	fi

	tar -cvf "$i.tar" * > /dev/null
	mv "$i.tar" ../../VNFDs/
	echo "Moved $i.tar to VNFDs directory"
	cd -
done

