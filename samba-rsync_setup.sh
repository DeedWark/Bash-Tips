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
/usr/bin/smbpasswd -a "$user"

chown "$user": "$share"
/etc/init.d/smbd restart

############ RSYNC #############
read -r -p "Do you want to set rsync backup for your samba share? [Y/N]: " wantrs

case $wantrs in
	[YyOo]* ) checkrsync=$(dpkg -s |grep -ie "Package: rsync$")

		if [[ -z $checkrsync ]] ; then
			read -r -p "Do you want to install rsync & cifs-utils? [Y/N] " rsyncinst
			case $rsyncinst in
				[YyOo]* ) apt-get -y install rsync cifs-utils 1>/dev/null;;
				[Nn]* ) exit 0;;
			esac
		fi

		read -r -p "Enter a path (backup place): " bkppath
		mkdir -p "$bkppath"

		read -r -p "\nEnter your share IP/DNS: " ip
		/usr/bin/mount -t cifs -o username="$user" //"$ip"/"$only" "$bkppath"

		checkmount=$(/usr/bin/mount |grep -i samba)
		if [[ -z $checkmount ]] ; then
			echo -e "Mount FAILED! - Please do this command after this script :\nmount -t cifs -o username=${user} //${ip}/${only} ${bkppath}\nOR\nmount.cifs //${ip}/${only} ${bkppath}\n"
		fi

		echo -e "\n//${ip}/${only}    ${bkppath} smbfs username=${user},password=CHANGE_PASSWORD 0 0" >> /etc/fstab
		echo -e "\nPLEASE CHANGE PASSWORD IN THIS FILE '/etc/fstab' TO MOUNT YOUR BACKUP FOLDER AT LINUX STARTING"
		
		echo -e "#!/bin/bash\n\nrsync -r ${share} ${bkppath}" > /usr/bin/backup_samba && chmod +x /usr/bin/backup_samba

		read -r -p "Do you want to set an auto backup? (w/CRON) [Y/N]: " auto
		case $auto in
			[YyOo]* ) echo -e "  [1] Monthly\n  [2] Weekly\n  [3] Daily\n  [4]  Hourly"
				read -r -p "Select a time period: " period
				case $period in
					1 ) cp /usr/bin/backup_samba /etc/cron.monthly/backup_samba;;
					2 ) cp /usr/bin/backup_samba /etc/cron.weekly/backup_samba;;
					3 ) cp /usr/bin/backup_samba /etc/cron.daily/backup_samba;;
					4 ) cp /usr/bin/backup_samba /etc/cron.hourly/backup_samba;;
				esac;;
			[Nn]* ) exit ;;
		esac;;

	[Nn]* ) exit 0;;
esac
