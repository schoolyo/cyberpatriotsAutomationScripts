#!/bin/bash

# This script will list users, and allow the administrator to cull unnecessary users as desired

# ADD GROUP / PASSCHANGE FUNCTIONALITY

listUsers() {
# List general users

clear
read -p "Displaying all general users on this system... [ENTER]"
echo
l=$(grep "^UID_MIN" /etc/login.defs)
l1=$(grep "^UID_MAX" /etc/login.defs)
awk -F':' -v "min=${l##UID_MIN}" -v "max=${l1##UID_MAX}" '{ if ( $3 >= min && $3 <= max ) print $0}' /etc/passwd | cut -d: -f1
echo
}

listSuperUsers() {
# List users with sudo priviledges

clear
read -p "Displaying all super users on this system... [ENTER]"
echo
grep '^sudo:.*$' /etc/group | cut -d: -f4
echo
}

cullUsers() {
# Cull the unauthorized users

echo "Enter the names of the users which you desire to delete, one at a time. Type 0 to exit."
echo "You will get an error message regarding an expected integer value; ignore it."
# Begin loop
while :
do
echo
echo "Enter the username of the user you wish to delete: "
read a

if [ $a -eq 0 ]; then
break
else
sudo userdel $a &>/dev/null
echo "User $a deleted"
read -p "[ENTER] to continue..."

fi

done
}

removeSuperUsers() {
# remove sudo priviledges from users that shouldn't have it
echo "Enter the name of the user you want to remove sudo privileges from, one at a time. Type 0 to exit."
echo "You will get an error message regarding an expected integer value; ignore it."
# begin loop
while :
do
echo
echo "Enter the username of the user you want to remove sudo privileges from: "
read a

if [ $a -eq 0]; then
break
else
sudo deluser $a sudo
echo "User $a removed from sudo group"
read -p "[ENTER] to continue..."

fi 

done
}

if [ "$(id -u)" != "0" ]; then

echo "You are not running usercheck.bash as root."
echo "Run as 'sudo bash usercheck.bash'"
exit
else
listUsers
cullUsers
listSuperUsers
removeSuperUsers
fi
