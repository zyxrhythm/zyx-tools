#!/bin/bash
#Parameter 1 ($1)should be 'start' /'stop'
if [[ $1 != stop && $1 != start ]]
then echo "Invalid parameter 1: $1 --- \$1 should be 'stop'/'start'".
exit 1
fi

s1=$1

#Default list - you remove all entries here by making the its value ="" and just specify the names of those that needs to be started by adding '-add' as parameter 2.
#Do not add blank lines
list="ssh
apache2
mysql
vsftpd"

#Case additional programs should be started, parameter 2 ($2) should be '-add'
#And parameter 3 ($3) should be a string of programs to start/stop with (,) as the delimiter, and should not start and end with  (,) 
#Parameter 3 sample: name1,name2
s3=$3
if [[ ! -z $2 && $2 != '-add' ]]; then
echo "Invalid parameter 2: $2 --- \$2 should be '-add'."
exit 1

elif [[ $2 = '-add' && ! -z $3 ]]; then
#add $3 to $list
list="$(echo -e "$list\n$(echo -e "${s3//,/"\n"}" )" )"
fi

while IFS= read -r x
do

#Checks if the service is up/down/unrecognized
testatx="$(service $x status 2> /dev/null)" 
if [[ ! -z $( grep -i -e stop -e fail <<< "$testatx" ) ]]; then testat=d; elif [[ -z $testatx ]]; then testat=x; else testat=u;fi

if [[ $s1 = stop || $s1 = start ]] && [[ $testat = x ]]
then echo "$x : unknown"

elif [[ $s1 = start  && $testat = u ]]
then echo "$x service is up, doing nothing"

elif [[ $s1 = start && $testat = d ]]
then service $x $1

elif [[ $s1 = stop && $testat = u ]]

then 
#Special "stopped" text for webmin
if [[ $x = webmin && $s1 = stop && $testat = u ]]; then service $x $1 > /dev/null 2>&1 && echo "[ ok ] Stopping Webmin web panel: $x."
else

service $x $1
fi

elif [[ $s1 = stop && $testat = d ]]
then echo "$x service is down, doing nothing"

fi

#Special "started" text for webmin
if [[ $x = webmin && $s1 = start && $testat = d ]]; then echo "[ ok ] Starting Webmin web panel: $x."; fi

done < <(echo "$list")

hostipaddress=$(awk '{print $2}' <<< $(ifconfig eth0 | grep -w inet))
echo -e "\nHost IP: $hostipaddress"

