This folder contains the automation scripts for Linux

- **common-password** replaces common-password in pam.d. It is the config file for password policy
- **fileFinder.bash** finds media files on the system and writes their paths to output files in the out directory
- **fileDelete.bash** reads the paths inside the file given as a parameter and deletes them all
- **userCheck.bash** lists all users and super users, and asks you which users to delete or remove sudo privileges from
- **getUserInfo.bash** gets some basic info about the username you pass as a parameter to the script (ID's, password status)
- **harden.bash** updates the system, enables firewall, sets up an iptable, replaces default config files with my versions, and writes the output of some analysis tools to files in the out directory
- **passwordCheck.bash** checks what users have no password, and prompts you for the new password to give them
