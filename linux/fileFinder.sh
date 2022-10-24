#!/bin/bash

# This program finds bad files, and lists them in an output file.
# The user can then choose which to delete at their discretion.

mkdir ./out

# Audio

find /home -name "*.midi" -type f | tee -a ./out/audio.out
find /home -name "*.mid" -type f | tee -a ./out/audio.out
find /home -name "*.mp3" -type f | tee -a ./out/audio.out
find /home -name "*.flac" -type f | tee -a ./out/audio.out

# Images

find /home -name "*.jpg" -type f | tee -a ./out/image.out
find /home -name "*.png" -type f | tee -a ./out/image.out
find /home -name "*.jpeg" -type f | tee -a ./out/image.out
find /home -name "*.gif" -type f | tee -a ./out/image.out

# Video

find /home -name "*.avi" -type f | tee -a ./out/video.out
find /home -name "*.mp4" -type f | tee -a ./out/video.out
find /home -name "*.wmv" -type f | tee -a ./out/video.out
find /home -name "*.mpg" -type f | tee -a ./out/video.out
find /home -name "*.MPG" -type f | tee -a ./out/video.out
find /home -name ".*mpeg" -type f | tee -a ./out/video.out
