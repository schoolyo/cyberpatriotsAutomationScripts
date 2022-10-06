# This program will use the output files from fileFinder.bash and use the file locations as arguments to delete the files
delete() {
# delete the files
while read -r i ; do rm $i ; done < filename
}
# Make sure to run as root
if [ "$(id -u)" != "0" ]; then

echo "You are not running fileDelete.bash as root."
echo "Run as 'sudo bash fileDelete.bash'"
exit
else
delete
fi
