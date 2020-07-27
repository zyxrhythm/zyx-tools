#!/bin/bash
#Fix permissions of files and folders
#This script is based on this blog: https://odd.blog/2013/11/05/fix-file-644-directory-775-permissions-linux-easily/
#$1 = directory permission (if blank, default value: 755, use 'x' to prevent the script from changing directory permissions)
#$2 = file permission (if blank, default value: 644, use x to to prevent the script from changing file permissions)
#$3 = recursive switch ( if 'r' is added as 3rd parameter the script will do a recursive file perm fix on the current dir, but if a valid is used as 3rd parameter, the script will update permissions on that directory, if left blank the script will do a non-recursive file and dir perm fix on the current dir)

if [[ $1 = 'help' ]]; then
clear
echo "

Fix permissions of files and folders

This script is based on the following blog: 
https://odd.blog/2013/11/05/fix-file-644-directory-775-permissions-linux-easily/

\$1 = directory permission 
     if blank, default value: 755 
     use 'x' to prevent the script from modifying directory permissions
	 
\$2 = file permission
     if blank, default value: 644, 
     use x to to prevent the script from modifying file permissions.
	 
\$3 = recursive switch
     if 'r' is added as 3rd parameter the script will do a recursive file and dir perm fix on the current dir, 
     if a valid directtory is used as 3rd parameter, the script will update permissions on that directory.
     if left blank the script will do a non-recursive file and dir perm fix on the current dir

"

else 

# 1st
permregex="^[0-7]{3}$"

if [ -z $1 ]; then 
dirperm='755'

elif [ ! -z $1 ] && [[ $1 =~ $permregex ]]; then 
dirperm=$1

elif [ ! -z $1 ] && [ $1 = 'x' ]; then
dskip='y'

fi

# 2nd
if [ -z $2 ]; then 
fileperm='644'

elif [ ! -z $2 ] && [[ $2 =~ $permregex ]]; then 
fileperm=$2

elif [ ! -z $2 ] && [ $2 = 'x' ]; then
fskip='y'

fi

# 3rd

if [ -d $3 ]; then
tardir="$3"
 
elif [ $3 = 'r' ]; then
tardir="./"

elif [ -z $3 ]; then
tardir="."
fi

if [[ $dskip != 'y' ]]; then
find $tardir -type d -exec chmod $dirperm {} \;
fi
 
if [[ $fskip != 'y' ]]; then
find $tardir -type f -exec chmod $fileperm {} \;
fi

exit 0

fi
