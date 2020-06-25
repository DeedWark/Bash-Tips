#!/bin/bash
# Kenji DURIEZ - ASRC46 #

#Check if SUDO
if [ $UID -ne 0 ] ; then
	echo "You must launch it with sudo!"
	exit 1
fi

#check if samba
checksamba=$(dpkg -s |grep -ie "Package: samba$")

#install it or not?
if [[ -z $checksamba ]] ; then
	read -r -p "Do you want to install Samba? [Y/N]: " sambainst
	case $sambainst in
		[YyOo]* ) apt-get -y install samba smbclient 1>/dev/null;;
		[Nn]* ) exit 0;;
	esac
fi

#user for samba
echo -e "Select a user dedicated to Samba"
read -r -p "Do you want to create a new one [Y/N] " new
case $new in
	[YyOo]* ) read -r -p "Name: " name
		useradd -m "$name" && user=$name;;
	[Nn]* ) echo "" && cut -d ':' /etc/passwd && read -r -p "Select a user: " user;;
esac

read -r -p "Path and name of the share dir: [ex : /home/samba/samba_share] " share

mkdir -p "$share" 

#get the last field of a string
#only=$(echo ${share##*/}) WORK ONLY WHEN USER DOESN'T PUT THE FINAL / at the end of the string
only=$(echo "${share}" |perl -F/ -wane 'print $F[-1-1]') #in this case, it's perfectly good

#add info_share in smb.conf
echo -ne "[${only}]
	   comment = Your share folder
	   path = ${share}
	   read only = no
	   browsable = yes\n" >> /etc/samba/smb.conf

/etc/init.d/smbd start
echo "$user password for SMB: "
smbpasswd -a "$user"

chown "$user": "$share"
/etc/init.d/smbd restart
