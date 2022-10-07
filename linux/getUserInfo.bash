# This file will list relevant data about a user given the username as input. 
# Useful for forensics questions that ask about users

getInfo() {
# get specified users info
if [[ ! -z $1 ]]; then
a=$1
else
echo "Please enter the username you want info about"
read a
fi

# Display the info
UID=`id $a`
grep "^${a}" /etc/shadow | cut -d: 
}
