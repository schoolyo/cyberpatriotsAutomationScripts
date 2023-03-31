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
awk -F':' -v "min=${l##UID_MIN}" -v "max=${l1##UID_MAX}" "$3 >= min && $3 <= max { print $1 }"
# '{ if ( $3 >= min && $3 <= max ) print $0}' /etc/passwd | cut -d: -f1
echo
}

listSuperUsers() {
# List users with sudo priviledges

clear
read -p "Displaying all super users on this system... [ENTER]"
echo
#grep '^sudo:.*$' /etc/group | cut -d: -f4
awk -F':' "{ if ( $1 == 'sudo' ) print $4 }" | tr "," "\n"
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
sudo userdel -r $a &>/dev/null
echo "User $a deleted"
read -p "[ENTER] to continue..."

fi

done
}

cullSuperUsers() {
# remove sudo priviledges from users that shouldn't have it
echo "Enter the name of the user you want to remove sudo privileges from, one at a time. Type 0 to exit."
echo "You will get an error message regarding an expected integer value; ignore it."
# begin loop
while :
do
echo
echo "Enter the username of the user you want to remove sudo privileges from: "
read a

if [ $a -eq 0 ]; then
break
else
sudo deluser $a sudo &>/dev/null
echo "User $a removed from sudo group"
read -p "[ENTER] to continue..."

fi 

done
}

userCheck() {
# check for empty passwords
echo "Passwordless users:"
awk -F':' "$2 == '*' || $2 == '' { print $1 }" /etc/passwd
echo

# check for non-root UID 0
echo "Non-root UID 0 users:"
awk -F':' "$3 == 0 && $1 != 'root' { print $1 }" /etc/passwd
echo

# check for any odd users or ones that shouldn't be allowed
echo "Check for odd users:"
awk -F':' "$3 > 999 && $3 < 65534 { print $1 }" /etc/passwd
echo

# lock root account
passwd -l root 

}

if [ "$(id -u)" != "0" ]; then

echo "You are not running usercheck.bash as root."
echo "Run as 'sudo bash usercheck.bash'"
exit
else
listUsers
cullUsers
listSuperUsers
cullSuperUsers
fi
