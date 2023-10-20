#!/bin/bash

# This script will list users, allow the administrator to cull unnecessary users, change user passwords, and check for suspicious users

listUsers() { #List general users
  clear
  read -p "Displaying all general users on this system... [ENTER]"
  echo
  awk -F':' '$3 > 999 { print $1 }' /etc/passwd
  echo
}

listSuperUsers() { #List users with sudo privileges
  clear
  read -p "Displaying all super users on this system... [ENTER]"
  echo
  awk -F':' '$1 == "sudo" { print $4 }' /etc/group | tr "," "\n" | sort
  echo
}

cullUsers() { #Cull the unauthorized users
  while :
  do
    listUsers
    echo "Enter the names of the users which you desire to delete, one at a time. Type 0 to exit."
    echo "You will get an error message regarding an expected integer value; ignore it."
    echo
    echo "Enter the username of the user you wish to delete: "
    read username
    
    if [ $username -eq 0 ]; then
      break
    else
      sudo userdel -r $username &>/dev/null
      echo "User $username deleted"
      read -p "[ENTER] to continue..."
    
    fi
  
  done
}

cullSuperUsers() { #Remove sudo priviledges from unauthorized users
  while :
  do
    listSuperUsers
    echo "Enter the username you want to remove sudo privileges from, one at a time. Type 0 to exit."
    echo "You will get an error message regarding an expected integer value; ignore it."
    echo
    echo "Enter the username you want to remove sudo privileges from: "
    read username
    
    if [ $username -eq 0 ]; then
      break
    else
      #sudo deluser $username sudo &>/dev/null
      sudo gpasswd -d $username sudo &>/dev/null
      echo "User $username removed from sudo group"
      read -p "[ENTER] to continue..."
    
    fi 
  
  done
}

changePassword() { #Check for empty passwords
  clear
  echo "Passwordless users:"
  awk -F':' '$2 == "" { print $1 }' /etc/shadow | sort
  
  # Change the password of any users inputted
  echo "Enter the username you want to change the password of, one at a time. Type 0 to exit."
  echo "You will get an error message regarding an expected integer value; ignore it."
  
  while true; do
    echo
    echo "Enter the username you want to change the password of: "
    read name
    if [ "$name" = "0" ]; then
      break
    fi
  
    echo "Enter the password you want to replace theirs with: "
    read password
    if [ "$password" = "0" ]; then
      break
    fi
  
    sudo echo "$name:$password" | chpasswd
    echo "Password of $name has been updated"
    read -p "[ENTER] to continue..."
  done
}

userCheck() {
  
  # Check for non-root UID 0
  #echo "Non-root UID 0 users:"
  #awk -F':' '$3 == 0 && $1 != "root" { print $1 }' /etc/passwd
  
  # Check for any odd users
  #echo "Check for odd users:"
  #awk -F':' '$3 > 999 && $3 < 65534 { print $1 }' /etc/passwd
  
  # Lock root account
  passwd -l root 
  
  # Display as columns
  #paste <(awk -F':' '{OFS=":"} $2 == "" {print $1}' /etc/shadow) <(awk -F':' '$3 == 0 && $1 != "root" {print $1}' etc/passwd)
}

if [ "$(id -u)" != "0" ]; then

  echo "You are not running usercheck.sh as root."
  echo "Run as 'sudo bash usercheck.sh'"
  exit
else
  #listUsers
  cullUsers
  #listSuperUsers
  cullSuperUsers
  changePassword
  userCheck
fi
