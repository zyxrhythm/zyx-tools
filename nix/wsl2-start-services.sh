#!/bin/bash
#parameter 1 ($1)should be 'start' /'stop'
if [[ $1 != stop && $1 != start ]]
then echo "$1 invalid parameter"
exit 1
fi

s1=$1

#default list - do not add blank lines
list="ssh
apache2
mysql"

#case additional programs should be started parameter 2 should be 'list'
#And parameter 3 ($3) should be a string of programs to start/stop with (,) as the delimiter and should not start and end with  (,) 
#parameter 3 sample: webmin,vsftp
s3=$3
if [[ $2 = list && ! -z $3 ]]; then
#add $3 to $list
list="$(echo -e "$list\n$(echo -e "${s3//,/"\n"}" )" )"
fi

while IFS= read -r x
do

#checks if the service is up/down
testat=$(echo "$(service $x status)" | grep -i -e stop -e fail )

if [[ $s1 = start  && -z $testat ]]
then echo "$x service is up, doing nothing"

elif [[ $s1 = start && ! -z $testat ]]
then service $x $1

elif [[ $s1 = stop && -z $testat ]]
then service $x $1

elif [[ $s1 = stop && ! -z $testat ]]
then echo "$x service is down, doing nothing"

fi

#special "started" text for webmin
if [[ $x = webmin && $s1 = start && ! -z $testat ]]; then echo "[ ok ] Starting Webmin web panel: $x"; fi

done < <(echo "$list")

hostipaddress=$(awk '{print $2}' <<< $(ifconfig eth0 | grep -w inet))
echo -e "\nHost IP: $hostipaddress"

