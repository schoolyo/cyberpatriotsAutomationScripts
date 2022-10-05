#!/bin/bash

# This program will check if any users don't have a password, and prompt to create a new one if they don't

checkEmpty() {
# List all users with no password
read -p "Check if any users have no password... [ENTER]"
echo
awk -F':' '{if ($2 == "*" || $2 == "!") print $1}' /etc/shadow 
echo
}

getRealUsers() {
# Get the list of actual users and cross reference with users that have no password to get rid of system users
l=$(grep "^UID_MIN" /etc/login.defs)
l1=$(grep "^UID_MAX" /etc/login.defs)
userLst=`awk -F':' -v "min=${l##UID_MIN}" -v "max=${l1##UID_MAX}" '{ if ( $3 >= min && $3 <= max ) print $0}' /etc/passwd | cut -d: -f1`

}

setNew() {
# Set new passwords for users that have none
read -p "Set new passwords for any users that have none"
}

if [ "$(id -u)" != "0" ]; then

echo "You are not running passwordCheck.bash as root."
echo "Run as 'sudo bash passwordCheck.bash'"
exit
else
checkEmpty
setNew
fi
