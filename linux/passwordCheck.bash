#!/bin/bash

# This program will check if any users don't have a password, and prompt to create a new one if they don't

checkEmpty() {
# List all users with no password
read -p "Check if any users have no password... [ENTER]"
echo
awk -F':' '{if ($2 == "*" || $2 == "!") print $1}' /etc/shadow 
echo
}
