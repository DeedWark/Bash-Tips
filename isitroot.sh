#!/bin/bash

if [ $UID -ne 0 ] ; then
	echo "You must launch with sudo!"
	exit 1
fi
