#!/bin/bash
if [[ $1 != stop && $1 != start ]]
then echo "$1 invalid parameter"
exit 1
fi

s1=$1
list="ssh
apache2
mysql"

s3=$3
if [[ $2 = list && ! -z $3 ]]; then
#add $3 to $list
list="$(echo -e "$list\n$(echo -e "${s3//,/"\n"}" )" )"
fi

while IFS= read -r x
do

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

if [[ $x = webmin && $s1 = start && ! -z $testat ]]; then echo "[ ok ] Starting Webmin web panel: $x"; fi

done < <(echo "$list")

hostipaddress=$(awk '{print $2}' <<< $(ifconfig eth0 | grep -w inet))
echo Host IP: $hostipaddress

