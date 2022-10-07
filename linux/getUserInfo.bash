#!/bin/bash
# This file will list relevant data about a user given the username as input. 
# Useful for forensics questions that ask about users

getInfo() {
uid=`id $1`
passwdStat=`grep "^${1}" /etc/shadow | cut -d: -f2`
echo "The UID of $1 is $uid"
echo "$1 has $passwdStat password status"
}

if [ "$(id -u)" != ]; then
echo "You are not running getUserInfo.bash as root. Please do."
exit
else
getInfo $1
fi
