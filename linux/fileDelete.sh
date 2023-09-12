# This program will use the output files from fileFinder.bash and use the file locations as arguments to delete the files
# remember to call this script with the input file name as a parameter
delete() {
  # delete the files
  while read -r i ; do rm $i ; done < $1 # read through input file one line at a time and use that line as paramater for rm command
}
# Make sure to run as root
if [ "$(id -u)" != "0" ]; then

  echo "You are not running fileDelete.bash as root."
  echo "Run as 'sudo bash fileDelete.bash'"
  exit
else
  delete $(readlink -f $1)
fi
