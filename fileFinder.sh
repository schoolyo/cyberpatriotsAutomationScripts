#!/bin/bash

# Define file extensions and corresponding output files
declare -A file_extensions=(
  ["Audio"]="midi mid mp3 flac"
  ["Images"]="jpg png jpeg gif"
  ["Video"]="avi mp4 wmv mpg mpeg mov"
  ["Text"]="txt pdf"
)

# Function to find and list files of specified extensions
find_and_list_files() {
  local directory="$1"
  local extensions="$2"
  local output_file="$3"

  for ext in $extensions; do
    find "$directory" -iname "*.$ext" -type f | tee -a "$output_file"
  done
}

# Find and list files by category
for category in "${!file_extensions[@]}"; do
  extensions="${file_extensions[$category]}"
  output_file="${category,,}.out"
  find_and_list_files /home "$extensions" "./$output_file"
done
