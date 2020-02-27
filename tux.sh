#!/bin/bash

figlet tux

if [ "$1" == poisson ] || [ "$1" == fish ]
then
	echo "Hmmmmmmmmm poisson... Tux content !"
else
	echo "Tux aime pas ça.  Tux veut poisson !"
fi
