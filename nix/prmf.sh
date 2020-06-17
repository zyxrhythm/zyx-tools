#!/bin/bash
#Fix permissions of files and folder
#This script is based on this blog: https://odd.blog/2013/11/05/fix-file-644-directory-775-permissions-linux-easily/
#$1 = target (if blank, default value: current directory)
#$2 = directory permission (if blank, default value: 755)
#$3 = file permission (if blank, default value: 644)


if [ -z $1 ]; then 
tardir="./"
elif [ ! -z $1 ] && [ ! -d $1 ]; then
echo "First parameter should be a valid directory!"
exit 1

else
tardir=$1
fi

if [ -z $2 ]; then 
dirperm=755
else
dirperm=$2
fi

if [ -z $3 ]; then 
fileperm=644
else
fileperm=$3
fi


find $tardir -type d -exec chmod $dirperm {} \;
find $tardir -type f -exec chmod $fileperm {} \;


exit 0
