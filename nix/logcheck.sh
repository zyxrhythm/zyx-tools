#!/bin/bash
# P1= what log ( apache / nginx / msql )
# P2= how many lines of the sorted info will be displayed
# P3= the path to the log files
# P4= the name of the log file

#THRALL
if [ -z $1 ]; then
echo "No Input!"
exit 1
fi

#from https://stackoverflow.com/questions/4137262/is-there-an-easy-way-to-determine-if-user-input-is-an-integer-in-bash
S1=$1
if [ ! -z $1 ] && [[ -n ${S1//[0-9]/} ]]; then
echo "$1 -- Invalid Number"
exit 1
fi

if [ ! -z $3 ] && [ ! -z $4 ] && [ ! -d $4 ]; then
echo "$4 -- Invalid Directory!"
exit 1
fi

#THRALL

##########
##########

#START

if [ ! -z $2 ] && [ $2 = 'apache' ]; then

 if [[ -z $(apache2 -v 2>/dev/null) ]] && [[ -z $(httpd -v 2>/dev/null) ]]; then 
 echo "Apache not found!"
 exit 1
 fi
 
 if [ ! -z $3 ] && [ ! -z $4 ] && [ ! -z $( echo "$(cd $4; if [ ! -e ./$3 ] || [ -d  ./$3 ]; then echo 'invalid'; fi )" | grep invalid ) ]; then
 echo "$3 -- Invalid File!"
 exit 1
 fi
 
 d1=$1

 if [ -z $3 ]; then
 d3="access.log"
 else
 d3=$3
 fi

 if [ -z $4 ]; then 
 d2="/var/log/apache2/"
 else
 d2=$4
 fi
 
 x=$( cd $d2; awk '{ print $1}' $d3 | sort | uniq -c | sort -nr | head -n $d1 | column -t )

 while IFS= read -r line; do
 linex=$( echo $line | awk '{$2=$2};1' | cut -f2 -d" " | tr -d '\040\011\012\015')
 wsv=$(whois $linex)
 countryx=$(echo "$wsv" | grep -i -e "Country:" | tr -d '\040\011\012\015')
 country=${countryx#*:}
 org=$(echo "$wsv" | grep -i -e "OrgName:" | tr -d '\040\011\012\015')
 
 echo "$( printf "%-15s" "$line" ) -- [ $( printf "%-3s" "$country" ) ] --> $org" | column -t

 done < <(printf '%s\n' "$x")

else
 
 echo "Invalid Input!"
 exit 1

fi 
