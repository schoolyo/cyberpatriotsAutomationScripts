#!/bin/bash

# This program will use the output files from fileFinder.bash and use the file locations as arguments to delete the files
# remember to call this script with the input file name as a parameter

delete() { # Check if the file exists
  if [ -e "$1" ]; then
    while IFS= read -r file; do
      # Confirm before deleting
      read -p "Delete $file? (y/n): " confirm
      if [ "$confirm" == "y" ]; then
        rm -v "$file"
      fi
    done < "$1"
  else
    echo "Input file does not exist: $1"
  fi
}

# Check if running as root
if [ "$(id -u)" != "0" ]; then
  echo "You are not running fileDelete.sh as root."
  echo "Run as 'sudo bash fileDelete.sh'"
  exit 1
fi

if [ $# -eq 1 ]; then
  delete "$(readlink -f "$1")"
else
  echo "Usage: sudo bash fileDelete.sh [input_file]"
  exit 1
fi
