#!/bin/bash

# This program will check if any users don't have a password, and prompt to create a new one if they don't

getRealPasswordless() {
  # Get the list of actual users and cross reference with users that have no password to get rid of system users
  read -p "Check if any users have no password... [ENTER]"
  
  # get min and max uid values for users
  l=$(grep "^UID_MIN" /etc/login.defs)
  l1=$(grep "^UID_MAX" /etc/login.defs)
  # get strings of usernames that have no passwords and are real users
  userLst=`awk -F':' -v "min=${l##UID_MIN}" -v "max=${l1##UID_MAX}" '{ if ( $3 >= min && $3 <= max ) print $0}' /etc/passwd | cut -d: -f1`
  emptyLst=`awk -F':' '{if ( $2 == "*" || $2 == "!" ) print $1}' /etc/shadow`
  
  # display real passwordless users
  for user in $userLst; do
    for none in $emptyLst; do
      if [ $user == $none ]; then
        echo $user
      fi
    done
  done
}

setNew() {
  # Set new passwords for users that have none
  read -p "Set new passwords for any users that have none"
  echo
  while :
  do
  echo "Enter the username of the user you want to create a new password for. Type 0 to exit."
  read a 
  if [ $a -eq 0 ]; then
  break
  else
  # need to figure out how to read the list
  echo "New password for $a has been created"
  read -p "[ENTER] to continue..."
  
  fi
  
  done
}

if [ "$(id -u)" != "0" ]; then

  echo "You are not running passwordCheck.bash as root."
  echo "Run as sudo bash passwordCheck.bash"
  exit
else
  getRealPasswordless
  setNew
fi
