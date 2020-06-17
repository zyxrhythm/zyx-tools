#!/bin/bash
#Fix permissions of files and folder
#This script is based on this blog: https://odd.blog/2013/11/05/fix-file-644-directory-775-permissions-linux-easily/
#$1 = target (if blank, default value: current directory)
#$2 = directory permission (if blank, default value: 755)
#$3 = file permission (if blank, default value: 644)
#$4 = recursive switch ( if 'r' is added as 4th parameter the script will do a recursive file perm fix)

# 1st
if [ -z $1 ]; then 
tardir="./"
elif [ ! -z $1 ] && [ ! -d $1 ]; then
echo "First parameter should be a valid directory!"
exit 1

else
tardir=$1
fi

permregex="^[0-7]{3}$"

# 2nd
if [ -z $2 ]; then 
dirperm=755

elif [ ! -z $2 ] && [[ $2 =~ $permregex ]]; then 
dirperm=$2

elif [ ! -z $2 ] && [ $2 = x ]; then
dskip=y

else 
dirperm=755
fi

# 3rd
if [ -z $3 ]; then 
fileperm=644

elif [ ! -z $3 ] && [[ $3 =~ $permregex ]]; then 
fileperm=$3

elif [ ! -z $3 ] && [ $3 = x ]; then
fskip=y

else 
fileperm=644
fi

# 4th
if [ $4 = r ]; then
 
 if [ $dskip != y ]; then
 find $tardir -type d -exec chmod $dirperm {} \;
 fi
 
 if [ $fskip != y ]; then
 find $tardir -type f -exec chmod $fileperm {} \;
 fi

else

tardir="."

 if [ $dskip != y ]; then
 find $tardir -type d -exec chmod $dirperm {} \;
 fi
 
 if [ $fskip != y ]; then
 find $tardir -type f -exec chmod $fileperm {} \;
 fi

fi

exit 0
