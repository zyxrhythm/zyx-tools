#!/bin/bash
#permission checker (octal / 'number' format ) for files and dir

if [[ $1 = 'help' ]]; then
echo "

This script basically orbits the 'stat' command. The script shows files and folders permission on 'octal number' format.

You can use it by simply typing 'prm' followed by the path to the directory. Typing 'prm -h' adds hidden files & folders that starts with '.' on the results. And 'prm -x' shall include the "user and group" that owns of the folder in the result. If you do not include a path to the file/folder the script will try to execute on current working directory. Parameter -f and -fx is for files. Typing 'prm -f' is like plain 'prm' but is intended for a file. Typing 'prm -fx' is like 'prm -x' but is intended for a file.

    sample syntax is as follows:
    
    prm
    
    prm /path/to/dir
    prm -h /path/to/dir
    prm -x /path/to/dir
    
    prm -f /path/to/file
    prm -fx /path/to/file
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
  	echo -e "\nInvalid syntax! \nParameter 1 is '-h' which will not work if parameter 2 is a file. \n\nTry perm -f '<path to file>'\nor\nTry perm -fx '<path to file>'\n"
    
    	elif [ -z $2 ]; then
    	stat -c "%a %n" * && stat -c "%a %n" .*
    
    	elif [ $p2chk = 'unknown' ]; then
    	echo "( $2 ) Invalid input."
    
	else 
    	echo "Invalid Input!"
   	
	fi

# 'perm -x' will include the "user and group" of the owner
elif [ $1 = '-x' ]; then

	if [ $p2chk = 'dir' ]  && [ ! -z $2 ]; then
    	
	dir="$2"

		if [ "${dir: -1}" != '/' ]; then
		echo "$( echo "$(stat -c "%a %U %G %n" $dir/* && stat -c "%a %U %G %n" $dir/.* )" | column -t )"
		else
        	echo "$( echo "$(stat -c "%a %U %G %n" $dir* && stat -c "%a %G %n" $dir.*)" | column -t)"
    		
		fi

	elif [ $p2chk = 'file' ]  && [ ! -z $2 ]; then 
  	echo -e "\nInvalid syntax! \nParameter 1 is '-x' which will not work if parameter 2 is a file. \n\nTry perm -fx '<path to file>'\n"

	elif [ -z $2 ]; then
	echo "$( echo "$(stat -c "%a %U %G %n" * && stat -c "%a %U %G %n" .*)" | column -t )"
    
    	elif [ $p2chk = 'unknown' ]; then
    	echo "( $2 ) Invalid input."
    
    	else
   	echo "Invalid Input!"
    
    	fi

# 'perm -f' it is like perm, but will only work if a file is specfied
elif [ $1 = '-fx' ]; then

	if [ ! -z $2 ] && [ $p2chk = 'file' ]; then
    	
	target="$2"
	stat -c "%a %n" $target

	elif [ ! -z $2 ] && [ $p2chk = 'dir' ]; then 
  	echo -e "\nInvalid syntax! \nParameter 1 is '-f' which will not work if parameter 2 is a directory. \n\nTry perm -x '<path to dir>'\nor\nTry perm -h '<path to dir>'\nor\nTry perm '<path to dir>'\n"

	elif [ -z $2 ]; then
  	echo -e "\nInvalid syntax! \nParameter 1 is '-f' which will not work if a file is not specified as parameter 2.\n"
    
    	elif [ $p2chk = 'unknown' ]; then
    	echo "( $2 ) Invalid input."
    
    	else
   	echo "Invalid Input!"
    
    	fi

# 'perm -fx' will include the "user and group" of the owner
elif [ $1 = '-fx' ]; then

	if [ ! -z $2 ] && [ $p2chk = 'file' ]; then
    	
	target="$2"
	stat -c "%a %U %G %n" $target

	elif [ ! -z $2 ] && [ $p2chk = 'dir' ]; then 
  	echo -e "\nInvalid syntax! \nParameter 1 is '-fx' which will not work if parameter 2 is a directory. \n\nTry perm -x '<path to dir>'\nor\nTry perm -h '<path to dir>'\nor\nTry perm '<path to dir>'\n"

	elif [ -z $2 ]; then
  	echo -e "\nInvalid syntax! \nParameter 1 is '-fx' which will not work if a file is not specified as parameter 2.\n"
    
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
