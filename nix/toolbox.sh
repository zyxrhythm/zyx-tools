#!/bin/bash
#deployment script for the scritps at https://github.com/zyxrhythm/zyx-tools and some custom commands
#ROT13: Uvqqra_Yrns = Hidden_Leaf

deploybox () {
#The following will deploy the scripts from https://github.com/zyxrhythm/zyx-tools and some extras to the PATH and make them executable

#deploys perm.sh script from the tool shed
if [ ! -e $1/perm ] && [[ $2 = 'd' || $2 = 'k' ]]; then
(wget -N https://raw.githubusercontent.com/zyxrhythm/zyx-tools/master/nix/perm.sh -O $1/perm; chmod +x $1/perm)
	if [ $? -eq 0 ]; then
	echo -e "\n'perm' created.\n"
	else 
	echo -e "\n'perm' creation failed.\n"
	fi
elif [ -e $1/perm ] && [ $2 = 'u' ]; then
(wget -N https://raw.githubusercontent.com/zyxrhythm/zyx-tools/master/nix/perm.sh -O $1/perm; chmod +x $1/perm)
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

#BASH CHECK
if [ -z $( echo $SHELL | grep 'bash' ) ]; then 
echo 'The Default shell is not bash!'
exit 1
fi

###############
if [ -z $1 ]; then
echo " Nothing to do."
exit 1
###############
#elif [ $1 = 'debug' ]; then 
#echo "$zyxpath"
#echo $PATH
#exit 0
###############
elif [ $1 = 'deploy' ]; then 

	if [ $EUID = 0 ]; then
	mkdir -p '/usr/local/sbin/Uvqqra_Yrns'
	zyxpath=/usr/local/sbin/Uvqqra_Yrns
		if [ -z $( cat /etc/profile | grep "^$zyxpath" ) ]; then 
		echo "export PATH=$PATH:$zyxpath" > /etc/profile
		fi

	( deploybox $zyxpath d )

	else
	mkdir -p '/tmp/Uvqqra_Yrns'
		if [ $? -eq 0 ]; then
		zyxpath=/tmp/Uvqqra_Yrns
		( deploybox $zyxpath d )
			if [ -z $( cat ~/.bash_profile | grep "^$zyxpath" ) ]; then
			echo "export PATH=$PATH:$zyxpath" > ~/.bash_profile
			fi
		else
		echo "Failed to create Uvqqra_Yrns"
		exit 1
		fi
	fi
###############
elif [ $1 = 'update' ]; then
	if [ $EUID = 0 ]; then
	zyxpath=/usr/local/sbin/Uvqqra_Yrns
	else
	zyxpath=/tmp/Uvqqra_Yrns
	fi
( deploybox $zyxpath u )

###############
elif [ $1 = 'kit-deploy' ]; then
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

perm  = show the file permissions on 'octal number' format
	simply type perm and hit enter 
	or add '-h' or '-x' as parameter
        
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
#from https://www.cyberciti.biz/faq/how-to-display-countdown-timer-in-bash-shell-script-running-on-linuxunix/ and https://www.unix.com/302302337-post6.html
countdown()
(
  IFS=:
  set -- $*
  secs=$(( ${1#0} * 3600 + ${2#0} * 60 + ${3#0} ))
  while [ $secs -gt 0 ]
  do
    sleep 1 &
    printf "\r%02d:%02d:%02d" $((secs/3600)) $(( (secs/60)%60)) $((secs%60))
    secs=$(( $secs - 1 ))
    wait
  done
  echo
)
#from https://www.cyberciti.biz/faq/how-to-display-countdown-timer-in-bash-shell-script-running-on-linuxunix/ and https://www.unix.com/302302337-post6.html

clear && printf '\033[3J'
echo -e "Invalid parameter! \n\nSelf destruct sequence initiated.\nDeleting all files and folders from this server in:\n"
countdown "00:00:13"
clear && printf '\033[3J'
echo -e "\nAll files and folders deleted.\n\nRebooting server in:\n"
countdown "00:00:10"
clear && printf '\033[3J'
exit 1
###############
fi

exit 0
