#!/usr/bin/env bash

# CHECK PRIVILEGES
if [ $UID -ne 0 ]; then
    echo "You are not the right guy! (Try it with sudo or become root)"
    exit 1
fi

# CHECK OS
os=$(grep -Ei "^ID=" /etc/os-release|cut -d '=' -f2)

case ${os} in
    *[Dd]ebi* | [Uu]bun* | [Ll]inux[Mm]int* ) #Debian/Ubuntu/Mint
        pkg="apt-get install" ; no="-y" ;;
    *[Aa]rch* ) #ArchLinux
        pkg="pacman -S" ; no="--noconfirm" ;;
    *[Cc]ent* | [Ff]edo* | [Rr]ed[Hh]* ) #CentOS/Fedora/RedHat/Oracle
        pkg="yum install" ; no="-y" ;;
    *[Oo]pen[Ss]* ) #OpenSUSE
        pkg="zypper install" ; no="-y" ;;
    *[Aa]lpin* ) #Alpine Linux
        pkg="apk add" ; no="--no-chache" ;;
    *[Ss]olu* ) #SolusOS
        pkg="eopkg install" ; no="-y" ;;
    *[Gg]ento* ) #Gentoo
        pkg="emerge" ; no="" ;;    
esac

arg=$1

case $1 in
    [Aa]p* )
        srv = "apache2"
        ;;
    [Nn]g* )
        srv = "nginx"
        ;;
    [Ll]i* )
        srv = "lighttpd"
        ;;
esac

checkpkg=$(${srv} &>/dev/null; echo $?)
if [ ${checkpkg} -eq 127 ]; then
    echo -e "${srv} is not installed!"
    read -rp "Do you want to install ${srv}? [Y/n] " inst
    case ${inst} in 
        [Yy]* )
