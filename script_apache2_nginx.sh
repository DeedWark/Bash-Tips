#!/bin/bash
# Kenji DURIEZ - ASRC46 #

#check if SUDO
if [ $UID -ne 0 ] ; then
	echo "You must launch it with sudo!"
	exit 1
fi

#check if Apache2 is installed
check=$(dpkg -s |grep -ie "Package: apache2$")

if [[ -z $check ]] ; then
	read -r -p "Do you want to install Apache2? [Y/N]: " inst
	case $inst in
		[yYoO]* ) apt-get -y install apache2 1>/dev/null;;
		[Nn]* ) exit 0;;
	esac
fi

#User choice
read -r -p "Name of your site: " site
echo -e "   [1] .com\n   [2] .net\n   [3] .io\n   [4] Custom"
read -r -p "Choose your domain: " choice
dom=""
case $choice in
	1 | *[Cc]om ) dom=".com";;
	2 | *[Nn]et ) dom=".net";;
	3 | *[Ii]o ) dom=".io";;
	4 | [Cc]ust* ) read -r -p "Domain (don't forget the point): " custom ; dom="$custom";;
esac
echo -e ""

mv /etc/apache2/ports.conf{,.old} && sed 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf.old > /etc/apache2/ports.conf 2>/dev/null

#Create VHost
echo -ne "<VirtualHost *:8080>
               ServerName $site$dom
	       ServerAlias *.$site$dom
	       ServerAdmin webmaster@localhost
	       DocumentRoot /var/www/$site$dom
	       <Directory /var/www/$site$dom>
	               Options -Indexes +FollowSymLinks
		       AllowOverride all
		       Require all granted
	       </Directory>
	       ErrorLog /var/log/error_$site.log
	       CustomLog /var/log/access_$site.log combined
</VirtualHost>" > /etc/apache2/sites-available/"$site$dom".conf

#Create site dir
mkdir -p /var/www/"$site$dom"

#Active the site
/usr/sbin/a2ensite "$site$dom" &>/dev/null

#Restart apache2
/etc/init.d/apache2 start 2>/dev/null && /etc/init.d/apache2 reload 2>/dev/null

#Add local dns
echo -ne "\n127.0.0.1    $site$dom www.$site$dom" >> /etc/hosts

echo -e "\nYour site is now available! ($site$dom or www.$site$dom)\nDon't forget to put your web files in this dir: /var/www/$site$dom/\n"

####################### NGINX ########################
read -r -p "Do you want to set a Reverse Proxy with NGINX? [Y/N]: " rp

case $rp in
	[YyOo]* ) 
		checknginx=$(dpkg -s |grep -ie "Package: nginx$")

		if [[ -z $checknginx ]] ; then
			read -r -p "Do you want to install NGINX? [Y/N]: " nginxinst
			case $nginxinst in
				[YyOo]* ) apt-get -y install nginx 1>/dev/null;;
				[Nn]* ) exit 0;;
			esac
		fi

		/usr/bin/unlink /etc/nginx/sites-enabled/default
		read -r -p "Enter your local server IP: " ip
		echo -ne "server{
				listen 80;
				server_name $site$dom www.$site$dom;

				access_log /var/log/nginx/access_$site.log;
				error_log /var/log/nginx/error_$site.log;

				location / {
					    proxy_pass http://$ip:8080;
				}
		}" > /etc/nginx/reverse_proxy.conf
	ln -s /etc/nginx/sites-available/reverse_proxy.conf /etc/nginx/sites-available/reverse_proxy.conf
	/etc/init.d/nginx start
	;;

	[Nn]* ) exit 0;;
esac
