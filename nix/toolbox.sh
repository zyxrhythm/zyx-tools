#!/bin/bash
#deployment script for the scritps at https://github.com/zyxrhythm/zyx-tools and some custom commands
#ROT13: Uvqqra_Yrns = Hidden_Leaf

#The following function will deploy the scripts from https://github.com/zyxrhythm/zyx-tools and some extras to the $PATH and make them executable
deploybox () {
#deploys prm.sh script from the tool shed
if [ ! -e $1/prm ] && [[ $2 = 'd' || $2 = 'k' ]]; then
(wget -N https://raw.githubusercontent.com/zyxrhythm/zyx-tools/master/nix/prm.sh -O $1/prm; chmod +x $1/prm)
	if [ $? -eq 0 ]; then
	echo -e "\n'prm' created.\n"
	else 
	echo -e "\n'prm' creation failed.\n"
	fi
elif [ -e $1/prm ] && [ $2 = 'u' ]; then
(wget -N https://raw.githubusercontent.com/zyxrhythm/zyx-tools/master/nix/prm.sh -O $1/prm; chmod +x $1/prm)
fi

#deploys fprm.sh script from the tool shed
if [ ! -e $1/fprm ] && [[ $2 = 'd' || $2 = 'k' ]]; then
(wget -N https://raw.githubusercontent.com/zyxrhythm/zyx-tools/master/nix/fprm.sh -O $1/fprm; chmod +x $1/fprm)
	if [ $? -eq 0 ]; then
	echo -e "\n'fprm' created.\n"
	else 
	echo -e "\n'fprm' creation failed.\n"
	fi
elif [ -e $1/fprm ] && [ $2 = 'u' ]; then
(wget -N https://raw.githubusercontent.com/zyxrhythm/zyx-tools/master/nix/fprm.sh -O $1/fprm; chmod +x $1/fprm)
fi

#deploys zyxw-dip.sh from the tool shed
if [ ! -e $1/z ] && [[ $2 = 'd' || $2 = 'k' ]]; then
(wget https://raw.githubusercontent.com/zyxrhythm/zyx-tools/master/nix/zyxw-dip.sh -O $1/z; chmod +x $1/z)
	if [ $? -eq 0 ]; then
	echo -e "\n'z' created.\n"
	else 
	echo -e "\n'z' creation failed.\n"
	fi
elif [ -e $1/z ] && [ $2 = 'u' ]; then
(wget -N https://raw.githubusercontent.com/zyxrhythm/zyx-tools/master/nix/zyxw-dip.sh -O $1/z; chmod +x $1/z)
fi

#deploys zuni.sh from the tool shed
if [ ! -e $1/zuni ] && [[ $2 = 'd' ]]; then
(wget -N https://raw.githubusercontent.com/zyxrhythm/zyx-tools/master/nix/zuni.sh -O $1/zuni; chmod +x $1/zuni)
	if [ $? -eq 0 ]; then
	echo -e "\n'zuni' created.\n"
	else 
	echo -e "\n'zuni' creation failed.\n"
	fi
elif [ -e $1/zuni ] && [ $2 = 'u' ];then
(wget -N https://raw.githubusercontent.com/zyxrhythm/zyx-tools/master/nix/zuni.sh -O $1/zuni; chmod +x $1/zuni)
fi

#nameserver check - simply: cat /etc/resolv.conf
if [ ! -e $1/cdns ] && [[ $2 = 'd' ]]; then 
(echo "cat /etc/resolv.conf" > $1/cdns; chmod +x $1/cdns)
	if [ $? -eq 0 ]; then
	echo -e "\n'cdns' created.\n"
	else 
	echo -e "\n'cdns' creation failed.\n"
	fi
fi

#ping google.com
if [ ! -e $1/pig ] && [[ $2 = 'd' || $2 = 'u' ]]; then
(echo "ping google.com" > $1/pig; chmod +x $1/pig)
	if [ $? -eq 0 ]; then
	echo -e "\n'pig' created.\n"
	else 
	echo -e "\n'pig' creation failed.\n"
	fi
fi

#deploys the ultimate clear screen
if [ ! -e $1/c ] && [[ $2 = 'd' || $2 = 'k' || $2 = 'u' ]]; then
(echo "clear && printf '\033[3J'" > $1/c; chmod +x $1/c)
	if [ $? -eq 0 ]; then
	echo -e "\n'c' created.\n"
	else 
	echo -e "\n'c' creation failed.\n"
	fi
fi

#symlink the whois command to 'ws'
if [ ! -e $1/ws ] && [[ $2 = 'd' || $2 = 'k' || $2 = 'u' ]]; then
ln -s $(which whois) $1/ws
	if [ $? -eq 0 ]; then
	echo -e "\n'ws'whois alias created.\n"
	else 
	echo -e "\n'ws'whois alias creation failed.\n"
	fi
fi

#symlink the dig command to 'd'
if [ ! -e $1/d ] && [[ $2 = 'd' || $2 = 'k' || $2 = 'u' ]]; then
ln -s $(which dig) $1/d
	if [ $? -eq 0 ]; then
	echo -e "\n'd' dig alias created.\n"
	else 
	echo -e "\n'd' dig alias creation failed.\n"
	fi
fi

#symlink the host command to 'h'
if [ ! -e $1/h ] && [[ $2 = 'd' || $2 = 'k' || $2 = 'u' ]]; then
ln -s $(which host) $1/h
	if [ $? -eq 0 ]; then
	echo -e "\n'h' host alias created.\n"
	else 
	echo -e "\n'h' host alias creation failed.\n"
	fi
fi

#symlink the ping command to 'p'
if [ ! -e $1/p ] && [[ $2 = 'd' || $2 = 'k' || $2 = 'u' ]]; then
ln -s $(which ping) $1/p
	if [ $? -eq 0 ]; then
	echo -e "\n'p' ping alias created.\n"
	else 
	echo -e "\n'p' ping alias creation failed.\n"
	fi
fi
}

#BASH CHECK: checks if the shell is bash, if not terminate the script
if [ -z $( echo $SHELL | grep 'bash' ) ]; then 
echo 'The Default shell is not bash!'
exit 1
fi

#A input is expected in order for the scipt to continue if $1 is null the scipt will terminate.
if [ -z $1 ]; then
echo " Nothing to do."
exit 1

#this is added for cPanel adminstration
elif [ $1 = 'deploy' ] && [ $2 = cpx ]; then 
#this following will check if cPanel is instaleld on the host, will verify if cPanels /script folder is included in the user's $PATH
if [[ -z $(/usr/local/cpanel/cpanel -V 2>/dev/null) ]]; then
cpinstalled=n
else
cpinstalled=y
fi

if [ $cp = y ];then
  #check if the cpanel scripts directory is included in $PATH, if not this will add it for the current terminal session
  if [[ -z $(echo $PATH | grep "/usr/local/cpanel/scripts") ]]; then 
  export PATH=$PATH:/usr/local/cpanel/scripts
  fi
fi
#this is added for cPanel adminstration


#else if $1 for the script is 'deploy'
elif [ $1 = 'deploy' ] && [ -z $2 ]; then 
	#checks if the current user is running as root
	#if the user is root creates Uvqqra_Yrns directory in /usr/local
	#declare /usr/local/sbin/Uvqqra_Yrns as part of $PATH by modifying the bash profile for the root user
	if [ $EUID = 0 ]; then
	mkdir -p '/usr/local/sbin/Uvqqra_Yrns'
	zyxpath=/usr/local/sbin/Uvqqra_Yrns
		if [ -z $( cat /etc/profile | grep "^$zyxpath" ) ]; then 
		echo "export PATH=$PATH:$zyxpath" > /etc/profile
		fi
	#calls the deploybox function and feeds it with 'd' as input
	#d=deploy
	#u=update
	( deploybox $zyxpath d )
	
	#else if the user is not root
	#folder Uvqqra_Yrns will be created inside the users home diretory : ~/Uvqqra_Yrns
	else
	mkdir -p '~/Uvqqra_Yrns'
		if [ $? -eq 0 ]; then
		zyxpath="~/Uvqqra_Yrns"
		( deploybox $zyxpath d )
			if [ -z $( cat ~/.bash_profile | grep "^$zyxpath" ) ]; then
			echo "export PATH=$PATH:$zyxpath" > ~/.bash_profile
			fi
		else
		echo "Failed to create Uvqqra_Yrns"
		exit 1
		fi
	fi
#else if $1=update, called the deploybox  and feed it with 'u', which is equal to update.
elif [ $1 = 'update' ]  && [ -z $2 ]; then
	if [ $EUID = 0 ]; then
	zyxpath=/usr/local/sbin/Uvqqra_Yrns
	else
	zyxpath="~/Uvqqra_Yrns"
	fi
( deploybox $zyxpath u )

#else if $1=kit-deploy - deploys the special tools mentioned in zyx-kit
elif [ $1 = 'kit-deploy' ]  && [ -z $2 ]; then
zyxpath=/tmp/$(whoami)/zyx-kit
( deploybox $zyxpath k );
clear
echo "
====================================================================
=       ZYXRhythm    https://github.com/zyxrhythm/         =
===========================================================
 
z     = special domain check tool - 
        for simple check type:
        z thedomain.tld 
        
        for full check type:
        z thedomain.tld -f
	
	type 'z help' for more info.

prm  = show the file permissions on 'octal number' format.
	type 'fprm help' for more info.

fprm  = fixes file permission of folders and files
	type 'fprm help' for more info.
        
d     = is a shortcut/alias for the 'dig' command
        (Use it as you use the actual dig command)
 
ws    = is a shortcut/alias for the  'whois' command
       (Use it as you use the actual whois command)
 
h     = is a shortcut/alias for the  'host' command
       (Use it as you use the actual host  command)
 
p     = is a shortcut/alias for the  'ping' command
        (Use it as you use the actual ping  command)
 
c     = ultimate clear screen
 
more info at https://github.com/zyxrhythm/zyx-kit
======================================================================
"
###############
else

echo "Scipt Failed."
exit 1

fi

exit 0
