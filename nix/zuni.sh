#!/bin/bash
#Update/Installation script for ZYXW
#https://github.com/zyxrhythm/zyxw

#parameter 1 : install / update
#parameter 2 : download directory
#parameter 3 : document root directory
#parameter 4 : cgi-bin directory
#parameter 5 : branch
#parameter 6 : use conf from the branch
#parameter 7 : whois program
#parameter 8 : 'x'tra parameter
#parameter 9 : too much love will kill you ( I mean parameter )

clear && echo -en "\e[3J"

######START OF FUNC
panksiyon () {
##checks if all parameters are present
if [[ -z $2 ]] || [[ -z $3 ]] || [[ -z $4 ]] || [[ -z $5 ]]; then
echo "Missing parameters."
exit 1

elif [[ ! -z $9 ]]; then
echo "Too much love will kill you. (I mean parameter)"
exit 1

fi

clear && echo -en "\e[3J"

echo -e "---------------\n-> Directory Check Report:\n"
#checks if parameter 2
#
if [[ ! -e $2 ]] && [[ ! -d $2 ]]; then
echo -e "'$2' \nDownload directory does not exist!\n"
dircheck=f

elif [[ -e $2 ]] && [[ -d $2 ]] && [[ $2 != '.' ]] && [[ $2 != '..' ]]; then
S2=$2
if [[ "${S2: -1}" = '/' ]]; then S2=${S2%?} ; fi
echo -e "'$S2'\nDownload Directory [ok]\n"

elif [[ -e $2 ]] && [[ ! -d $2 ]]; then
echo -e "'$2' \nNot a directory.\n"
dircheck=f

else 
echo "Parameter 2 Error."
dircheck=f
exit 1
fi

#checks if parameter 3
if [[ ! -e $3 ]] && [[ ! -d $3 ]]; then
echo -e "'$3' \nDocument directory does not exist!\n"
dircheck=f

elif [[ -e $3 ]] && [[ -d $3 ]] && [[ $3 != '.' ]] && [[ $3 != '..' ]]; then
S3=$3
if [[ "${S3: -1}" = '/' ]]; then S3=${S3%?} ; fi
echo -e "'$S3'\nDocument Root Directory [ok]\n"

elif [[ -e $3 ]] && [[ ! -d $3 ]]; then
echo -e "'$3' \nNot a directory.\n"
dircheck=f

else 
echo "Parameter 3 Error."
dircheck=f
exit 1
fi

#checks if parameter 4
if [[ ! -e $4 ]] && [[ ! -d $4 ]]; then
echo -e "'$4' \nCGI directory does not exist!\n"
dircheck=f

elif [[ -e $4 ]] && [[ -d $4 ]] && [[ $4 != '.' ]] && [[ $4 != '..' ]]; then
S4=$4
if [[ "${S4: -1}" = '/' ]]; then S4=${S4%?} ; fi
echo -e "'$S4'\nCGI Directory [ok]\n"

elif [[ -e $4 ]] && [[ ! -d $4 ]]; then
echo -e "'$4' \nNot a directory.\n"
dircheck=f

else
echo -e "\nParameter 4 Error."
dircheck=f
exit 1
fi

if [[ -e $S4/../zyx ]] && [[ ! -d $S4/../zyx ]]; then 
echo "'zyx' is not a directory, also it should be in the same level as the 'cgi-bin' directory"
dircheck=f

elif [[ ! -e $S4/../zyx  ]]; then 
mkdir $S4/../zyx 
fi 

if [[ $dircheck = 'f' ]]; then echo -e "\nScript Halted." ; exit 1; fi

#removes the zyxw dir on the download directory if it exists
if [[ -d "$S2/zyxw" ]]; then 
rm -rf $S2/zyxw
fi

echo "---------------"

#clones the branch from github on the download directory
if [[ $dircheck != 'f' ]]; then
(cd $2; git clone -b $5 https://github.com/zyxrhythm/zyxw ); fi

if [[ ! -e $2/zyxw ]] && [[ ! -d $2/zyxw ]]
then 
echo -e "\n Git Error. Check if git is installed corretly."
exit 1

fi

echo "
-> Repository cloned at: 
$S2/zyxw

---------------"

#install all with the current content of the branch: customizations will be removed
if [[ $1 = 'install' ]] || [[ $1 = 'reinstall' ]]; then 

rm -rf $S3/{index.html,LICENSE,README.txt,icon.png,image.png}
cp $S2/zyxw/{index.html,LICENSE,README.txt,icon.png,image.png} $S3

rm -rf $S3/js/{allowedchars.js,dip.js,gencopy.js,whois.js}
cp $S2/zyxw/js/* $S3/js

rm -rf $S3/css/{digger.css,dip.css,eppstats.css,general.css,home.css,sslinfo.css,whois.css}
cp -u $S2/zyxw/css/* $S3/css

rm -rf $4/{.htaccess,cctld.zyx,digger.zyx,dip.zyx,eppstatuscodes.zyx,gtld.zyx,home.zyx,moreinfo.zyx,sslinfo.zyx,thx.zyx,updates.zyx,whois.conf.zyx,whois.zyx}
cp -u $S2/zyxw/cgi-bin/* $S4

if [[ $S3/cgi-bin = $S4 ]]; then
rm -rf $S3/zyx
cp -uR $S2/zyxw/zyx $S3

else 
rm -rf $S4/../zyx
cp -uR $S2/zyxw/zyx $S4/..

fi

if [[ $1 = 'install' ]]; then
echo -e "\nBranch: $5\n\n-> Installation Complete!\n\n"
elif [[ $1 = 'reinstall' ]]; then
echo -e "\nBranch: $5\n\n-> Re-installation Complete!\n\n"
fi

#patial: preserve customizations : /image.png /icon.png /zyx/vars/*.vars /zyx/txt/* /css/*
elif [[ $1 = 'update' ]]; then

echo -e "\nExecuting Update ( preserving customizations )\nBranch: $5\n"

rm -rf $S3/{index.html,LICENSE,README.txt}
cp $S2/zyxw/{index.html,LICENSE,README.txt} $S3
echo -e "\nUpdated:\n$S3/index.html\n$S3/LICENSE\n$S3/README.txt\n"

rm -rf $S3/js{allowedchars.js,dip.js,gencopy.js,whois.js}
cp $S2/zyxw/js/* $S3/js
echo -e "\nUpdated:\n$S3/js/allowedchars.js\n$S3/js/dip.js\n$S3/js/gencopy.js\n$S3/js/whois.js\n"

rm -rf $4/{.htaccess,cctld.zyx,digger.zyx,dip.zyx,eppstatuscodes.zyx,gtld.zyx,home.zyx,moreinfo.zyx,sslinfo.zyx,thx.zyx,updates.zyx,whois.conf.zyx,whois.zyx}
cp -u $S2/zyxw/cgi-bin/* $S4
cp -u $S2/zyxw/cgi-bin/.* $S4
echo "
Updated:
$S4/.htaccess
$S4/cctld.zyx
$S4/digger.zy
$S4/dip.zyx
$S4/eppstatuscodes.zyx 
$S4/gtld.zyx 
$S4/home.zyx 
$S4/moreinfo.zyx 
$S4/sslinfo.zyx 
$S4/thx.zyx 
$S4/updates.zyx 
$S4/whois.conf.zyx
$S4/whois.zyx
"

rm -rf $S4/../zyx/blob/{cctldx.blob,gtldx.blob,tldlist0.blob,tldlistg.blob,tldlistx.blob}
cp -u $S2/zyxw/zyx/blob/* $S4/../zyx/blob
echo "
Updated:
cctldx.blob
gtldx.blob
tldlist0.blob
tldlistg.blob
tldlistx.blob
"

rm -rf $S4/../zyx/sh/{genvars.sh,homevars.sh,navpart.sh,tldblob.sh}
cp -u $S2/zyxw/zyx/sh/* $S4/../zyx/sh
echo "
Updated:
genvars.sh
homevars.sh
navpart.sh
tldblob.sh
"

if [[ $1 = 'update' ]] && [[ $8 = 'x' ]]; then
rm -rf $S4/../zyx/vars/tpage.vars
cp -u $S2/zyxw/zyx/vars/tpage.vars $S4/../zyx/vars
echo "
Updated: 
$S2/zyxw/zyx/vars/tpage.vars
"
fi

else
echo "Nothing to do."
exit 1

fi

if [[ $6 = 'y'  ]] && [[ $7 = 'whois' ]]; then

cp -u $S2/zyxw/zxy/conf/whois.conf /etc/whois.conf
echo "-> /etc/whois.conf updated"

elif [[ $6 = 'y'  ]] && [[ $7 = 'jwhois' ]]; then

cp -u $S2/zyxw/zxy/conf/jwhois.conf /etc/jwhois.conf
echo "-> /etc/jwhois.conf updated"

fi

rm -rf $S2/zyxw
echo "
-------------
-> House Keeping...

$S2/zyxw (removed)

-------------
"
}
######END OF FUNC

currentdir=$(pwd)
#use the same directory of the script for the config file
#https://stackoverflow.com/questions/59895/get-the-source-directory-of-a-bash-script-from-within-the-script-itself
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#GROOT CHECK
if [ "$EUID" -ne 0 ]; then echo "Error: Please run as groot. (I mean root)" ; exit 1; fi

##GIT CHECK
if [[ ! -z $( $( which git 2>&1 ) | grep  "which.no" ) ]]; then echo "Git Not found! - please install git."; exit 1; fi

##WHOIS CHECK
if [[ -e /usr/bin/jwhois ]] && [[ ! -d /usr/bin/jwhois ]]; then 
whoisprog='jwhois'
elif [[ -e /usr/bin/whois ]] && [[ ! -d /usr/bin/whois ]] && [[ ! -e /usr/bin/jwhois ]]; then 
whoisprog='whois'
else echo "Warning: No whois program detected! - please install whois."
exit 1
fi

##CONFIG CHECK
if [[ ! -e $scriptdir/zyxw.config ]] && [[ ! -d $scriptdir/zyxw.config ]] && [[ -z $1 || $1 = 'install' ]] && [[ -z $2 ]]; then

echo -e "Current Directory: $currentdir\nScript Directory: $scriptdir\n\n****************\n-> Initiating a full installation... \n"

wtd='install'

##download dir check 
until [ "$dldirc" = 'valid' ]; do
  echo -e "Specify a directory in which the repository files will be downloaded, \nthe current directory ($currentdir) will be used \nif nothing is specified:"
  read dldir
  
  if [[ -z $dldir ]]; then 
  dldir=$currentdir
  dldirc='valid'   
  
  elif [[ -e "$dldir" ]] && [[ -d "$dldir" ]] && [[ $dldir != '.' ]] && [[ $dldir != '..' ]]; then 
  if [[ "${dldir: -1}" = '/' ]]; then dldir=${dldir%?} ; fi
  dldirc='valid'
  
  else 
  dldirc='invalid'
  fi
  
done
echo -e "\n-> Will use ( $dldir) for the repository download.\n"

##doc root dir check
until [ "$docdirc" = 'valid' ]; do
  echo "Enter the full path to the website document root directory:"
  read docdir
  
  if [[ -e "$docdir" ]] && [[ -d "$docdir" ]] && [[ $docdir != '.' ]] && [[ $dldir != '..' ]]; then 
  if [[ "${docdir: -1}" = '/' ]]; then docdir=${docdir%?} ; fi
  docdirc='valid'; 
  
  else 
  docdirc='invalid'
  fi
  
done
echo -e "\n-> Will treat ( $docdir ) as the website document root.\n"

##cgi-bin dir check
until [ "$cgidirc" = 'valid' ]; do
  echo "Enter the full path to the cgi-bin directory:"
  read cgidir
  
  if [[ -e "$cgidir" ]] && [[ -d "$cgidir" ]] && [[ $cgidir != '.' ]] && [[ $dldir != '..' ]]; then 
  if [[ "${cgidir: -1}" = '/' ]]; then cgidir=${cgidir%?} ; fi
  cgidirc='valid'; 
  
  else 
  cgidirc='invalid'
  fi

done
echo -e "\n-> Will treat ( $cgidir ) as the 'CGI-BIN' directory.\n"

##branch selection
echo -e "\nMake sure the branch is valid! \nIf left blank, the Alpha branch will be deployed.\nInput the Branch you wanted to deploy:"
read zyxwb
if [[ -z "$zyxwb" ]]; then zyxwb=Alpha 	; fi

echo -e "-> Will deploy $zyxwb branch.\n"

until [ "$confverc" = 'valid' ]; do
  echo -e "\nWould you like to use the $whoisprog.conf files from the $zyxwb branch? ( 'y' / 'n' )"
  read confver
  if [[ "$confver" = 'y' ]] || [[ "$confver" = 'n' ]]; then confverc='valid'; else confverc='invalid'; fi
done

touch $scriptdir/zyxw.config

echo "###############################
What_To_Do=$wtd
Download_Directory=$dldir
Document_Root_Directory=$docdir
CGI_Directory=$cgidir
Branch=$zyxwb
Use_Conf_Files=$confver
Whois_Prog=$whoisprog
###############################" > $scriptdir/zyxw.config

echo -e "\nzyxw.config created at $scriptdir"

echo "
Installing ZYXW with the following specifications:

Execute: Full $wtd
Download Directory: $dldir
Document Root Directory: $docdir
CGI Directory: $cgidir
Branch: $zyxwb
Use ($whoisprog) conf files: $confver
"
read -p "Proceed? (y/n) : " insggg

while [ $insggg != 'y' ] && [ $insggg != 'n' ]; do
  echo "Invalid Input! please Enter 'y' or 'n' "
  read insggg
done

if [[ $insggg = 'y' ]]; then
clear && echo -en "\e[3J"
spitfire=$( panksiyon $wtd $dldir $docdir $cgidir $zyxwb $confver $whoisprog )
echo "$spitfire"
exit 0

elif [[ $insggg = 'n' ]]; then
echo "Installation cancelled."
exit 0
fi

##################################

elif [[ -e $scriptdir/zyxw.config ]] && [[ ! -d $scriptdir/zyxw.config ]] && [[ $1 = 'reinstall' ]] && [[ -z $2 ]]; then

if [[ ! -z $(cat "$scriptdir/zyxw.config" | grep -w "What_To_Do=install" ) ]]; then 
sed -i 's/What_To_Do=update/What_To_Do=install/g' $scriptdir/zyxw.config
fi

wtd=$( cat $scriptdir/zyxw.config | grep 'What_To_Do=' | cut -f2 -d'=' )
dldir=$( cat $scriptdir/zyxw.config | grep 'Download_Directory=' | cut -f2 -d'=' )
docdir=$( cat $scriptdir/zyxw.config | grep 'Document_Root_Directory=' | cut -f2 -d'=' )
cgidir=$( cat $scriptdir/zyxw.config | grep 'CGI_Directory=' | cut -f2 -d'=' )
zyxwb=$( cat $scriptdir/zyxw.config | grep 'Branch=' | cut -f2 -d'=' )
confver=$( cat $scriptdir/zyxw.config | grep 'Use_Conf_Files=' | cut -f2 -d'=' )
whoisprog=$( cat $scriptdir/zyxw.config | grep 'Whois_Prog=' | cut -f2 -d'=' )

echo "
Re-installing ZYXW with the following specifications:

Execute: Full $wtd
Download Directory: $dldir
Document Root Directory: $docdir
CGI Directory: $cgidir
Branch: $zyxwb
Use ($whoisprog) conf files: $confver

Warning: This will override all customizations you have made.
"
read -p "Proceed? (y/n) : " insggg

while [ $insggg != 'y' ] && [ $insggg != 'n' ]; do
  echo "Invalid Input! please Enter 'y' or 'n' "
  read insggg
done

if [[ $insggg = 'y' ]]; then
clear && echo -en "\e[3J"
spitfire=$( panksiyon $wtd $dldir $docdir $cgidir $zyxwb $confver $whoisprog )
echo "$spitfire"
exit 0

elif [[ $insggg = 'n' ]]; then
echo "Installation cancelled."
exit 0
fi

##################################

elif [[ -e $scriptdir/zyxw.config ]] && [[ ! -d $scriptdir/zyxw.config ]] && [[ -z $1 || $1 = 'update' ]] && [[ -z $2 ]]; then

clear && echo -en "\e[3J"

if [[ ! -z $(cat "$scriptdir/zyxw.config" | grep -w "What_To_Do=install" ) ]]; then 
sed -i 's/What_To_Do=install/What_To_Do=update/g' $scriptdir/zyxw.config
fi

wtd=$( cat $scriptdir/zyxw.config | grep 'What_To_Do=' | cut -f2 -d'=' )
dldir=$( cat $scriptdir/zyxw.config | grep 'Download_Directory=' | cut -f2 -d'=' )
docdir=$( cat $scriptdir/zyxw.config | grep 'Document_Root_Directory=' | cut -f2 -d'=' )
cgidir=$( cat $scriptdir/zyxw.config | grep 'CGI_Directory=' | cut -f2 -d'=' )
zyxwb=$( cat $scriptdir/zyxw.config | grep 'Branch=' | cut -f2 -d'=' )
confver=$( cat $scriptdir/zyxw.config | grep 'Use_Conf_Files=' | cut -f2 -d'=' )
whoisprog=$( cat $scriptdir/zyxw.config | grep 'Whois_Prog=' | cut -f2 -d'=' )

spitfire=$( panksiyon $wtd $dldir $docdir $cgidir $zyxwb $confver $whoisprog )
echo "$spitfire"

else

spitfire=$( panksiyon $1 $2 $3 $4 $5 $6 $7 $8 $9 )
echo "$spitfire"

fi

exit 0
