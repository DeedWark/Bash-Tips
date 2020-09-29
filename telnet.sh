#!/bin/bash
#Kenji DURIEZ - 2020
#This script will perform TELNET in a sec

RED='\033[1;31m'
NO='\033[0m'

read -r -p "SMTP server: " smtp
if [ -z "$smtp" ]; then
       echo -e "${RED}SMTP required!${NO}"
       exit 1
fi

read -r -p "HELO/EHLO: " helo

read -r -p "MAIL FROM: " mfrom

read -r -p "RCPT TO: " rto
if [ -z "$rto" ]; then
	echo -e "${RED}RCPT TO required!${NO}"
	exit 1
fi

read -r -p "From: " from
read -r -p "To: " to
read -r -p "Date: " date
read -r -p "Subject: " subject
read -r -p "Message-ID: (leave empty for random or type 0 for none): " mid
read -r -p "Mailer: (leave empty for put this one or type 0 for none): " xm

if [ -z "$from" ]; then
	from = $mfrom
fi

if [ -z "$to" ]; then
	to = "$rto"
fi

if [ -z "$date" ]; then
	date = ""
fi

if [ -z "$subject" ]; then
	subject = ""
fi

{ echo "EHLO ${helo}"; echo "EHLO ${helo}"; echo "MAIL FROM:<${mfrom}>"; echo "RCPT TO:<${rto}>"; echo "DATA"; echo "Date: ${date}"; echo "To: ${to}"; echo "From: ${from}"; echo "Subject: ${subject}"; echo "."; echo ""; sleep 1; } | telnet ${smtp} 25