#!/bin/bash
# This file will list relevant data about a user given the username as input. 
# Useful for forensics questions that ask about users

getInfo() {
uid=`id $1`
passwdStat=`grep "^${1}" /etc/shadow | cut -d: -f2`
echo "The ID's of $1 is $uid"
echo "$1 has $passwdStat password status"
}

if [ "$(id -u)" != "0" ]; then
echo "You are not running getUserInfo.bash as root. Please do."
exit
elif [ $# -eq 0 ]; then
echo "No argument provided. Please provide the username you want info about as a parameter when calling the script"
exit
else
getInfo $1
fi
