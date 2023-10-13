#!/bin/bash

# This program finds bad files, and lists them in an output file.
# The user can then choose which to delete at their discretion.

mkdir ./out

# Audio

find /home -iname "*.midi" -type f | tee -a ./out/audio.out
find /home -iname "*.mid" -type f | tee -a ./out/audio.out
find /home -iname "*.mp3" -type f | tee -a ./out/audio.out
find /home -iname "*.flac" -type f | tee -a ./out/audio.out

# Images

find /home -iname "*.jpg" -type f | tee -a ./out/image.out
find /home -iname "*.png" -type f | tee -a ./out/image.out
find /home -iname "*.jpeg" -type f | tee -a ./out/image.out
find /home -iname "*.gif" -type f | tee -a ./out/image.out

# Video

find /home -iname "*.avi" -type f | tee -a ./out/video.out
find /home -iname "*.mp4" -type f | tee -a ./out/video.out
find /home -iname "*.wmv" -type f | tee -a ./out/video.out
find /home -iname "*.mpg" -type f | tee -a ./out/video.out
find /home -iname "*.mpeg" -type f | tee -a ./out/video.out
find /home -iname "*.mov" -type f | tee -a ./out/video.out
