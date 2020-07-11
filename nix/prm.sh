#!/bin/bash
#permission checker (octal / 'number' format ) for files and dir

if [[ $1 = 'help' ]]; then
echo "

This script is basically orbiting the 'stat' command. The script shows files and folders permission on 'octal number' format.

You can use it by simply typing 'prm' followed by the path to the file/directory. Typing 'prm -h' adds hidden files/folders that starts with '.' on the results. And 'prm -x' shall include the owner of the file/folder in the result. If you do not include a path to file/folder the script will be executed on your current working directory.

    sample syntax is as follows:

    prm /path/to/dirorfile
    prm -h /path/to/dir
    prm -x /path/to/dirorfile

"

else

#checks if input is a directory / file/ something else
p1chk=$( if [ -d $1 ]; then echo dir; elif [ ! -d $1 ] && [ -e $1 ]; then echo file; else echo unknown; fi )
p2chk=$( if [ -d $2 ]; then echo dir; elif [ ! -d $2 ] && [ -e $2 ]; then echo file; else echo unknown; fi )

##just 'perm' : will dispaly permission on octal format and file name/s on the current working directory 
#but will not display hidden contents with '.' at the beginning of their file names
if [ -z $1 ]; then
stat -c "%a %n" * 

# 'perm -h' will display even hidden files
elif [ $1 = '-h' ]; then 
	if [ $p2chk = 'dir' ] && [ ! -z $2 ]; then
	dir="$2"
		
		if [ "${dir: -1}" != '/' ]; then
		stat -c "%a %n" $dir/* && stat -c "%a %n" $dir/.*     
		else
		stat -c "%a %n" $dir* && stat -c "%a %n" $dir.*
		fi
  
	elif [ $p2chk = 'file' ]  && [ ! -z $2 ]; then 
  	echo -e "\nInvalid syntax! Parameter 1 is '-x' which will not work if parameter 2 is a file. \n\nTry perm '<path to file>'\n"
    
    elif [ -z $2 ]; then
    stat -c "%a %n" * && stat -c "%a %n" .*
    
    elif [ $p2chk = 'unknown' ]; then
    echo "( $2 ) Invalid input."
    
	else 
    echo "Invalid Input!"
    
   	fi

# 'perm -x' will include the owner for the file plus will display an indicator for symbolic links
elif [ $1 = '-x' ]; then

	if [ $p2chk = 'dir' ]  && [ ! -z $2 ]; then
    	
	dir="$2"

		if [ "${dir: -1}" != '/' ]; then
		echo "$( echo "$(stat -c "%a %U %G %n" $dir/* && stat -c "%a %U %G %n" $dir/.* )" | column -t )"
		else
        echo "$( echo "$(stat -c "%a %U %G %n" $dir* && stat -c "%a %G %n" $dir.*)" | column -t)"
    	fi

	elif [ $p2chk = 'file' ]  && [ ! -z $2 ]; then 
  	echo -e "\nInvalid syntax! Parameter 1 is '-x' which will not work if parameter 2 is a file. \n\nTry perm '<path to file>'\n"

	elif [ -z $2 ]; then
	echo "$( echo "$(stat -c "%a %U %G %n" * && stat -c "%a %U %G %n" .*)" | column -t )"
    
    elif [ $p2chk = 'unknown' ]; then
    echo "( $2 ) Invalid input."
    
    else
   	echo "Invalid Input!"
    
    fi

#if a directory is specified, will display file permissions for all files and folder on that directory
elif [ $p1chk = 'dir' ] && [ -z $2 ]; then
    
	dir="$1"

	if [ "${dir: -1}" != '/' ]; then
   	stat -c "%a %n" $dir/*
    	else
    	stat -c "%a %n" $dir*
    	fi

#if a file is specified, will display file permission of that file
elif [ $p1chk = 'file' ] && [ -z $2 ]; then
stat -c "%a %n" $1

else echo "Invalid Parameter!"

fi

exit 0

fi
