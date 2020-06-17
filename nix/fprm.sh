#!/bin/bash
#Fix permissions of files and folder
#This script is based on this blog: https://odd.blog/2013/11/05/fix-file-644-directory-775-permissions-linux-easily/
#$1 = target (if blank, default value: current directory)
#$2 = directory permission (if blank, default value: 755)
#$3 = file permission (if blank, default value: 644)
#$4 = recursive switch ( if 'r' is added as 4th parameter the script will do a recursive file perm fix)


if [ -z $1 ]; then 
tardir="./"
elif [ ! -z $1 ] && [ ! -d $1 ]; then
echo "First parameter should be a valid directory!"
exit 1

else
tardir=$1
fi

permregex="^[0-7]{3}$"

if [ -z $2 ] || [ $2 = x ]; then 
dirperm=755

elif [ ! -z $2 ] && [[ $2 =~ $permregex ]]; then 
dirperm=$2

else 
dirperm=755
fi

if [ -z $3 ] || [ $3 = x ]; then 
dirperm=644

elif [ ! -z $3 ] && [[ $3 =~ $permregex ]]; then 
dirperm=$3

else 
dirperm=644
fi


if [ $4 = r ]; then

find $tardir -type d -exec chmod $dirperm {} \;
find $tardir -type f -exec chmod $fileperm {} \;

else
tardir="."

find $tardir -type d -exec chmod $dirperm {} \;
find $tardir -type f -exec chmod $fileperm {} \;
fi

exit 0
