#!/bin/bash

# This script will list users, allow the administrator to cull unnecessary users, change user passwords, and check for suspicious users

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
# Remove sudo priviledges from unauthorized users
echo "Enter the username you want to remove sudo privileges from, one at a time. Type 0 to exit."
echo "You will get an error message regarding an expected integer value; ignore it."
# Begin loop
while :
do
echo
echo "Enter the username you want to remove sudo privileges from: "
read name

if [ $name -eq 0 ]; then
break
else
sudo deluser $name sudo &>/dev/null
echo "User $name removed from sudo group"
read -p "[ENTER] to continue..."

fi 

done
}

changePassword() {
# Change the password of any users inputted
echo "Enter the username you want to change the password of, one at a time. Type 0 to exit."
echo "You will get an error message regarding an expected integer value; ignore it."
while :
do
echo
echo "Enter the username you want to change the password of: "
read name
echo "Enter the password you want to replace theirs with: "
read password

if [ $name -eq 0 || $password -eq 0 ]; then
break
else
sudo echo "$name:$password" | chpasswd
echo "Password of $name has been updated"
read -p "[ENTER] to continue..."

fi

done
}


userCheck() {

# Check for empty passwords
echo "Passwordless users:"
noPassword=$(awk -F':' "$2 == '*' || $2 == '' { print $1 }" /etc/passwd)

# Check for non-root UID 0
echo "Non-root UID 0 users:"
noRoot=$(awk -F':' "$3 == 0 && $1 != 'root' { print $1 }" /etc/passwd)

# Check for any odd users
echo "Check for odd users:"
oddUsers=$(awk -F':' "$3 > 999 && $3 < 65534 { print $1 }" /etc/passwd)

# Lock root account
passwd -l root 

# Display as columns
#need to figure out how to use column command to do this
}

if [ "$(id -u)" != "0" ]; then

echo "You are not running usercheck.sh as root."
echo "Run as 'sudo bash usercheck.sh'"
exit
else
listUsers
cullUsers
listSuperUsers
cullSuperUsers
changePassword
userCheck
fi
