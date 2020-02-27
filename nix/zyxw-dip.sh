#!/bin/bash
#This script was created by Zyx Rhythm (email:zyxrhythm@gmail.com)
#And it can be downloaded at https://github.com/zyxrhythm/zyx-tools/
#############################################

clear && echo -en "\e[3J"

whoisprogtest=$(if [[ -e /usr/bin/whois ]] && [[ ! -d /usr/bin/whois ]] && [[ ! -e /usr/bin/jwhois ]]; then echo 'whois'; else echo 'jwhois'; fi )

if [[ $whoisprogtest = 'jwhois' ]]; then
whoisprog='jwhois'
zyxwhois="whois -n"

elif [[ $whoisprogtest = 'whois' ]]; then
whoisprog='whois'
zyxwhois="whois --verbose"

else
echo -e "\nA whois program is not installed.\n"
exit 1
fi

domain=$(echo $1 | gawk '{print tolower($0)}' )

#more info trigger
if [[ $2 = '-f' ]]; then
checknsrb="y"
else
checknsrb="n"
fi

if [[ -z "$domain" ]]; then
echo -e "\nInvalid Input: Empty.\n"
exit 1

else

valid='0-9a-z'
	if [[ ${domain:0:1} =~ [^$valid] ]] || [[ ${domain: -1} =~ [^$valid] ]]; then

	echo -e "\nInput Cannot start/end with a symbol.\n"
	exit 1
	fi

	if [[ ${domain:0:8} = "https://" ]] || [[ ${domain:0:7} = "http://" ]]; then
	domain="${domain#*//}"
	fi

	#determine if whois or jwhois
	if [[ $whoisprog = 'jwhois' ]]; then
	zyx0=$($zyxwhois $domain 2>&1)
	zyx=$(echo "$zyx0" | sed  '1,2d' )

		if [[ $(echo "${zyx:0:9}" | gawk '{print tolower($0)}' | tr -d '\040\011\012\015' ) = "nomatch" ]]; then
		zyxdvc0=$($zyxwhois $domain  -h whois.iana.org 2>&1)
		zyxdvc1=$(echo "$zyxdvc0" | sed  '1,2d' )
		zyxdvc="${zyxdvc1:0:9}"
		fi

		trywis0=$(echo "$zyx0" | grep -F -i -e "[Querying" | sort -u | tr -d '\[\] ' )
		trywis="${trywis0#*Querying}"

	elif [[ $whoisprog = 'whois' ]]; then
	zyx0=$($zyxwhois $domain 2>&1)
	zyx=$(echo "$zyx0" | sed -e '1,/Query string:/d' | sed -n '1!p' )
	trywis0=$(echo "$zyx0" | grep -i -e "Using server" | sort -u )
	trywis=${trywis0#*Using server }

	else
	echo -e "\nHanggang sa dulo ng ating walang hanggan, hangga't ang puso'y wala ng maramdaman.\n"
	exit 1

	fi

	nsxx=$(echo "$zyx" | grep -i -e 'Name server:' )

	cnamec=$(dig A +noall +answer $domain)
	cnamec0=$(dig CNAME +noall +answer $domain)

	if [[ -z $( echo "$cnamec $cnamec0" | grep "IN.CNAME" ) ]]; then
	cnc="n"
	else
	cnc="p"
	fi

	if (( $(grep -c . <<<"$cnamec") > 1)); then
    senvar=" also"
	else
    senvar=""
	fi

	#==========================
	# THE GREAT FUNCTION HALL
	#=================

	#Domain Status Functions
	dsfunction () {

	while IFS= read -r line; do
	echo "${line#*#}"
	done < <(printf '%s\n' "$1")
	}

	#Name Servers Function
	nsfunction () {
	if [[ -z $2 ]] && [[ $checknsrb = "y" ]]; then
	echo -e "Name Servers:\n"

	while IFS= read -r line; do
   	echo  -e "${line#*:}"
	done < <(printf '%s\n' "$1")

	echo -e "\n++++++++++++++++++++++++++"

	while IFS= read -r line; do
   	nsr1=$( echo "${line#*:}" | tr -d '\040\011\012\015' | gawk '{print tolower($0)}' )
   	nsr2=$(dig a +short "$nsr1" @8.8.8.8 2>/dev/null )
   	nscx=$( echo "$( dig a +short $domain @$nsr2 2>/dev/null )" | tr -d '\040\011\012\015' )

   		if [[ -z "$nsr2" ]]; then
		nsipc="null"
		echo "${line#*:} "

   		elif [[ "${nscx:0:2}" = ";;" ]]; then
		nsipc="xd"
   		echo "${line#*:}"
   		else
        echo -e "\n${line#*:}"
   		fi

		if (( $(grep -c . <<<"$nsr2") > 1)); then

			while IFS= read -r line1; do
   			nsa0=$($zyxwhois $line1 )
			nscx2=$( echo "$( dig a +short $domain @$line1 )" | tr -d '\040\011\012\015' )

				if [[ "${nscx2:0:2}" = ";;" ]]; then
   				nsipc1="xd"
   				fi

   			nsa1=$( echo "$nsa0" | grep -i -e "OrgName:" )

   				if [[ -z "$nsa1" ]]; then
                nsa2=$( echo "$nsa0" | grep -i -e "NetName:" )
   				else
                nsa2="$nsa1"
   				fi

			nsax=$( echo "$nsa2" | sort -u )

                if [[ "$nsipc1" = "null" ]]; then
				echo "Invalid Nameserver - Does not resolve to an IP address!"
				nsipc1="reset"

                elif [[ "$nsipc1" = "xd" ]]; then
				echo -e " $nsr2 --- $( echo "${nsax##*:}" | awk '{$2=$2};1' ) \n Warning: This NS does not respond to dig queries!!"
				nsipc1="reset"

				else
				echo "   $line1 --- $( echo "${nsax##*:}" | awk '{$2=$2};1' )"
				fi

			done < <(printf '%s\n' "$nsr2")

		else
   		nsa20=$($zyxwhois "$nsr2" )
   		nsa21=$( echo "$nsa20" | grep -i -e "OrgName:" )
   			if [[ -z "$nsa21" ]]; then
            nsa22=$( echo "$nsa20" | grep -i -e "NetName:" )
            else
            nsa22="$nsa21"
   			fi

   		nsax2=$( echo "$nsa22" | sort -u | head -1 )

   			if [[ "$nsipc" = "null" ]]; then
            echo "Invalid Nameserver - Does not resolve to an IP address!"
   			nsipc="reset"

   			elif [[ "$nsipc" = "xd" ]]; then
            echo -e "  $nsr2 --- ${nsax2#*:} \n Warning: This NS does not respond to dig queries!"
   			nsipc="reset"

			else
   			echo "   $nsr2 --- $(echo "${nsax2#*:}" | awk '{$2=$2};1' )"
   			fi
		fi

	done < <(printf '%s\n' "$1")

    echo -e "\n++++++++++++++++++++++++++"

	elif [[ $2 = "z" ]] || [[ $checknsrb = "n" ]]; then
	echo -e "\n Name Servers: \n"
		while IFS= read -r linez ; do
		echo -e "${linez#*:}"
		done < <(printf '%s\n' "$1")

    echo -e "\n"

	elif [[ $2 = "x" ]]; then
		while IFS= read -r linez ; do
   		echo -e "${linez#*:} $3"
		done < <(printf '%s\n' "$1")

	else
    echo "Nothing here."
	fi
	}

	#A Record Function
	arfunction () {

	cnchk=$( dig CNAME $domain @8.8.8.8 )

	if [[ -z $2 ]]; then
	arff="$1"

	elif [[ $2 = 'x' ]]; then
	artqns=$( echo "$1" | gawk '{print tolower($0)}' )
	arff=$(dig a +short $domain @$artqns )

	else
	artqns="8.8.8.8"
	arff=$(dig a +short $domain @$artqns )
	fi

	if (( $(grep -c . <<<"$arff") > 1)); then
    artvar="A Records:"
	else
    artvar="A Record:"
	fi

	echo "$artvar"

	if [[ -z "$arff" ]]; then
    echo "No A record found!"

    else

		while IFS= read -r line; do
			if [[ "$line" =~ ^(([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))\.){3}([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))$ ]]; then
			rchk="A"

                if [[ ${line:0:7} = "192.168" ]] || [[ ${line:0:4} = "10.0" ]] || [[ ${line:0:6} = "172.16" ]] || [[ ${line:0:6} = "172.31" ]]; then
                rchkx="r1"
				alinex="$line"
				elif [[ ${line:0:4} = "127." ]] || [[ ${line:0:3} = "0.0" ]]; then
                rchkx="r0"
				alinex="$line"
				else
				rchkx="rr"
				alinex="$line"
   				ar0=$($zyxwhois $alinex )
				fi

			elif [[ $cnc = "p" ]] && [[ ! -z "$(dig +short A $line )" ]]; then
			ealinex=$(dig a +short $line )
			alinex="$ealinex"
			ar0=$($zyxwhois $alinex )
			rchk="CNAME"

            else
			rchk="WTF"
			fi

		ar1=$( echo "$ar0" | grep -i -e "OrgName:" );

			if [[ -z "$ar1" ]]; then
            ar2=$( echo "$ar0" | grep -i -e "NetName:" )
			else
            ar2="$ar1"
			fi

		arx=$( echo "$ar2" | sort -u | head -1 )

			if [[ $rchk = "A" ]] && [[ $rchkx = "r0" ]]; then
			echo -e "\n  $alinex --- [ PRIVATE IP ] \n"

			elif [[ $rchk = "A" ]] && [[ $rchkx = "r1" ]]; then
			echo -e "\n  $alinex --- [ RESERVED IP ] \n"

			elif [[ $rchk = "A" ]] && [[ $rchkx = "rr" ]]; then
			echo -e "\n  $alinex --- $( echo ${arx#*:} | awk '{$2=$2};1' ) "

			elif [[ $rchk = "CNAME" ]]; then
			echo -e "\n $line --- [ CNAME ]"

			elif [[ ! -z $cnchk ]] && [[ -z $( echo "$rchk" | grep "A") ]]; then
			echo -e "\nDomain resolves to Oblivion...\nWarning: domain resolves to only a CNAME and nothing more,\nalso the CNAME is invalid / does not resolve to an IP address.\n"

			else
            echo -e "\nDomain resolves to oblivion!\n"

			fi

		done < <(printf '%s\n' "$arff")

	fi
	}

	#MX Record/s Function
	mrfunction () {

	if [[ -z $2 ]]; then
	mxrff="$1"

	elif [[ $2 = "x" ]]; then
	mxrtqns=$( echo "$1" | gawk '{print tolower($0)}' )
	mxrff=$(dig mx +short $domain @$mxrtqns | sort -n )

    elif [[ $2 = "y" ]]; then
	mxrtqns="8.8.8.8"
	mxrff=$(dig mx +short $domain @$mxrtqns | sort -n )

	else
	mxrtqns="8.8.8.8"
	mxrff=$(dig mx +short $domain @$mxrtqns | sort -n )
	fi

	if (( $(grep -c . <<<"$mxrff") > 1)); then
    mxtvar="MX Records:"
	else
	mxtvar="MX Record:"
	fi

	echo -e "$mxtvar \n"

	tmxrc=$( if [[ -z $( echo "$( dig MX "$domain" @8.8.8.8 2>/dev/null)" | grep -w "IN.MX" ) ]]; then echo "x"; else echo "y"; fi; )

	if [[ -z "$mxrff" ]]; then
	echo -e "No MX record found! \n"

	elif [[ $tmxrc = "x" ]] ; then
	echo -e "MX record not found! \n [ Possibly misconfigured ] \n"

	elif [[ $cnc = "p" ]]; then
	echo -e "\nW arning: The Naked Domain resolves to a CNAME! \nT his might result in unexpected pregnancy (I mean error), like this one!\nF or all we know, it could even start World War 6! \n"

	else
		if [[ $cnc = "p" ]]; then
        mxrffcf=$( echo  "$mxrff"  | sed '/ /!d' )
		else
		mxrffcf="$mxrff"
		fi

		while IFS= read -r line; do
		mxr1=$(echo  $line | cut -f2 -d" ")
		mxr1a=$(echo $line | cut -f1 -d" ")

			if [[ $checknsrb = "n" ]] || [[ $checknsrb = "N" ]]; then
			mxr2=$(dig A +short "$mxr1" @"$mxrtqns" 2>/dev/null )
			mxrc=$( dig +noall +answer ANY "$mxr1" @8.8.8.8 2>/dev/null )

            elif [[ $checknsrb = "y" ]] || [[ $checknsrb = "Y" ]]; then
			mxr2=$(dig A +short "$mxr1" @8.8.8.8 2>/dev/null )
			mxrc=$( dig ANY +noall +answer "$mxr1" @8.8.8.8 2>/dev/null )

            else
			mxr2=$(dig A +short "$mxr1" @"$mxrtqns" 2>/dev/null )
			fi

		mxcnamevarc=$( echo "$mxrc" | grep -w "IN.CNAME" )
		mxcnamevara=$( echo "$mxrc" | grep -w "IN.A" )
		mxcnamechk=$( if [[ -z "$mxcnamevarc" ]]; then echo "x"; else echo "y"; fi )
		mxachk=$( if [[ -z "$mxcnamevara" ]]; then echo "x"; else echo "y"; fi )

			if [[ -z "$mxr2" ]] && [[ $mxcnamechk = "x" ]] && [[ $mxachk = "x" ]]; then
			mxipc="null"
			echo -e "$mxr1a $mxr1 \n\nMX Record Misconfigured ( Case 1 ), \nThe hostname does not resolve to an A/CNAME record.\n\n"

			elif [[ $mxcnamechk = "y" ]] && [[ $mxachk = "x" ]]; then
			mxabc=$( dig A +short "$(dig cname $mxr1 +short 2>/dev/null )" 2>/dev/null )

				if [[ -z "$mxabc" ]]; then
    			echo -e "$mxr1a $mxr1 \n \nMX Record Misconfigured ( Case 2a ), \nThe hostname resolves to CNAME that does not resolve to an IP address. \n";

				elif [[ ! -z "$mxabc" ]]; then
				echo -e "$mxr1a $mxr1 \n \nMX Record Configuration ( Case 2b ), \nThe hostname resolves to CNAME:\n"

				else
				echo "$mxr1a $mxr1 \n \nYou should not ever see this! \nSince you did, please contact the administrator.\n"
				fi

			elif [[ $mxcnamechk = "y" ]] && [[ $mxachk = "y" ]]; then
			ansfmxf=$( echo "$(dig NS $domain @8.8.8.8 +short )" | head -n 1)
			mxipc="null"
			echo -e "$mxr1a $mxr1 \n \nMX Record Possibly Misconfigured ( Case 3 ), \nThe hostname resolves to a combination of CNAME/s and A record/s: \n \n To see all records, \ntry 'dig ANY ${mxr1%?} @${ansfmxf%?}' \n\n"

			else
			echo -e "$mxr1a $mxr1 \n"
			fi

		if (( $(grep -c . <<<"$mxr2") > 1)); then

			while IFS= read -r linex; do
   			mxa1=$( echo "$($zyxwhois $linex )" | grep -i -e "OrgName:" )

   				if [[ -z "$mxa1" ]]; then
   				mxa2=$( echo "$mxa0" | grep -i -e "NetName:" )
   				else
   				mxa2="$mxa1"
   				fi

   			mxax=$( echo "$mxa2" | sort -u | head -1 )

   				if [[ "$mxipc" = "null" ]] && [[ -z "$mxachk" ]]; then
   				echo -e "MX record configuration unknown!"
   				else
					if [[ "$linex" =~ ^(([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))\.){3}([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))$ ]]; then
						if [[ ${linex:0:7} = "192.168" ]] || [[ ${linex:0:4} = "10.0" ]] || [[ ${linex:0:6} = "172.16" ]] || [[ ${linex:0:6} = "172.31" ]]; then
            			echo  "  $linex --- [ PRIVATE IP ]"
						elif [[ ${linex:0:4} = "127." ]] || [[ ${linex:0:3} = "0.0" ]]; then
            			echo "   $linex --- [ RESERVED IP ]"
						else
            			echo "   $linex --- $( echo "${mxax#*:}" | awk '{$2=$2};1' )"
						fi

					else
					echo -e "   $linex --- [ CNAME ]"
					fi
   				fi

		done < <(printf '%s\n' "$mxr2")

	echo -e "\n"

	#############

		else

   		mxa20=$($zyxwhois "$mxr2" )
   		mxa21=$( echo "$mxa20" | grep -i -e "OrgName:" )

   			if [[ -z "$mxa21" ]]; then
   			mxa22=$( echo "$mxa20" | grep -i -e "NetName:" )
   			else
   			mxa22="$mxa21"
   			fi

   		mxax2=$( echo "$mxa22" | sort -u | head -1 )

			if [[ ! -z "$mxr2" ]]; then

   				if [[ "$mxipc" = "null" ]] && [[ $mxachk = "x" ]] && [[ $mxcnamechk = "x" ]]; then
   				echo "Invalid MX Record - Does not Resolve to an IP address!"
   				else
   					if [[ "$mxr2" =~ ^(([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))\.){3}([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))$ ]]; then
						if [[ ${linex:0:7} = "192.168" ]] || [[ ${linex:0:4} = "10.0" ]] || [[ ${linex:0:6} = "172.16" ]] || [[ ${linex:0:6} = "172.31" ]]; then
                		echo -e "  $linex --- [ PRIVATE IP ] \n"
						elif [[ ${linex:0:4} = "127." ]] || [[ ${linex:0:3} = "0.0" ]]; then
						echo -e "   $linex --- [ RESERVED IP ]"
						else
						echo -e "   $mxr2 --- $(echo "${mxax2#*:}" | awk '{$2=$2};1' )"
    					fi

   					else
					echo -e "   $mxr2 --- [ CNAME ]"
    				fi
   				echo -e "\n"
   				fi
  			fi
		fi
		done < <(printf '%s\n' "$mxrffcf")
	fi
	}

	#DaysCalcFunction
	countdfunc () {
	extdate=$(echo "$1" | grep -o -P '(?<=Date:).*(?=T)' | tr -d '\040\011\012\015' )
	#some registrar does not have the "T" on the expiration date but has a space divide the date and time - thus the above will not be enough
	#The following line will utilize the space between the date and the time instead
	if [[ -z $extdate ]]; then
    extdatex=$(echo "$1" | grep -o -P '(?<=Date:).*(?= )' | tr -d '\040\011\012\015' )
	else
	extdatex="$extdate"
	fi
	daysleft=$( echo $((($(date +%s --date "$extdatex")-$(date +%s))/(3600*24))) )
	echo "$daysleft"
	}
	#=====================
	# END OF FUNCTION HALL
	#=====================

	#domain validity check -if  by checking the first 9 characters on the raw whois result
	dvc=$(echo "${zyx:0:9}" |  gawk '{print tolower($0)}' | tr -d '\040\011\012\015')

	if [[ $dvc = 'domainno' ]] || [[ $dvc = 'nomatch' ]] || [[ $dvc = 'notfound' ]] || [[ $dvc = 'nodataf' ]] || [[ $dvc = 'nowhois' ]] || [[ $dvc = 'thisdoma' ]] || [[ $dvc = 'nom' ]] || [[ $dvc = 'invalidq' ]] || [[ $dvc = 'whoisloo' ]] || [[ $dvc = 'theregis' ]] || [[ $dvc = 'connect' ]] || [[ $dvc = 'available' ]] || [[ $dvc = ">>>domai" ]] || [[ $dvc = "connect:" ]] || [[ $dvc = 'errorth' ]] || [[ $dvc = 'noinform' ]] || [[ $dvc = 'thequeri' ]]; then

	domhv=$( echo "$(nslookup "$domain")" | grep -e 'NXDomain'  )
		if [[ $( echo "${domain#*.}" | grep -o "\." | wc -l) -gt "0" ]] && [[ -z "$domhv" ]]; then
    	domvarx="- ( A sub domain )"
		else
    	domvarx=$(echo -e "\n( Not a  valid domain / sub domain. )" )
		fi
	echo -e "Input : $domain $domvarx \nWhois server queried: $trywis \n\nNo whois information found! \n\nPossible causes: \n\n->Input is not valid \n1.The domain is not registered or has been deleted and is no longer registered. \n2.Not a valid domain name. \n3.The TLD has beed added to the 'not supported' TLD list \n\n->The whois server for this domain name does not respond to whois queries via port 43 (a web/other interface might be available). \n\n->No whois server found. \n\n\nPlease input a valid/registered naked domain name (FQDN)\n\n"
	exit 1

	elif [[ "$dvc" = "%ianawh" ]] || [[ "$zyxdvc" = "%ianawh" ]]; then
	echo -e "Input : $domain - is a TLD \n\n$zyx \n\n"
	exit 1

	elif [[ "$dvc" = "patterns" ]]; then
	echo -e "Input: $domain - is a TLD \nBut if you do a 'whois $domain' \non a Linux terminal you will get:\n\n'$zyx'\n\nSo if you are here to validate this TLD \nor want to get some info about it,\ndo not start the input with a dot '.' \n"
	exit 1

	else

	tld=$( echo $domain | rev | cut -d "." -f1 | rev )

		if [[ $tld = "shop" ]]; then
		zyx=$(whois $domain -h whois.nic.shop 2>&1 )
		fi

	whoisservergrep=$(echo "$zyx" | grep -i -e "REGISTRAR WHOIS SERVER:" | sort -u )

		if [[ ! -z "$whoisservergrep" ]]; then

			if [[ $whoisprog = 'jwhois' ]]; then

			whoisserver=$(echo "$whoisservergrep" | cut -f2 -d":" | tr -d '\040\011\012\015' )

			elif [[ $whoisprog = 'whois' ]]; then

			whoisserver0=$(echo "$whoisservergrep" | cut -f2 -d":" | tr -d '\040\011\012\015' )
			whoisserver=${whoisserver0#*Using Server }
			else
			whoisserver=$(echo "$whoisservergrep" | cut -f2 -d":" | tr -d '\040\011\012\015' )
			fi

		zyx2=$(whois $domain -h $whoisserver 2>&1 )
		fi

	#REESE
	rese=$(echo "$zyx2" | grep -i -e "reseller:")
	reseller=$( echo "${rese#*:}" | awk '{$2=$2};1')

	resx=$( echo $reseller | tr -d '\040\011\012\015' )
	if [[ -z $resx ]] || [[ ${resx:0:1} =~ [^$validchars] ]]; then
    reese='None'
	else
	reese="$reseller"
	fi
	#REESE

	#TLD LISTS
	shopt -s extglob
	#general list of supported TLD for dip.zyx
	tldlistg="+(aarp|able|abogado|abudhabi|academy|accountant|accountants|active|actor|ads|adult|aero|africa|agency|airforce|ally|alsace|amsterdam|anquan|apartments|app|arab|archi|army|arpa|art|asia|associates|attorney|auction|audio|author|auto|autos|baby|band|bank|bar|barcelona|barefoot|bargains|baseball|basketball|bayern|bcn|beauty|beer|berlin|best|bet|bible|bid|bike|bingo|bio|biz|black|blackfriday|blockbuster|blog|blue|boats|boo|book|booking|boston|bot|boutique|box|broadway|broker|brother|brussels|budapest|build|builders|business|buy|buzz|bzh|cab|cafe|cal|call|cam|camera|camp|cancerresearch|capetown|capital|car|caravan|cards|care|career|careers|cars|casa|case|cash|casino|cat|catering|catholic|cba|cbn|cbre|cbs|ceb|center|ceo|cern|cfa|cfd|channel|charity|chase|chat|cheap|christmas|chrome|church|cipriani|circle|citadel|citic|city|cityeats|claims|cleaning|click|clinic|clinique|clothing|cloud|club|clubmed|coach|codes|coffee|college|cologne|com|community|company|compare|computer|comsec|condos|construction|consulting|contact|contractors|cooking|cool|coop|corsica|country|coupon|coupons|courses|credit|creditcard|creditunion|cricket|crown|crs|cruise|cruises|cymru|dabur|dad|dance|data|date|dating|day|dds|deal|dealer|deals|degree|delivery|democrat|dental|dentist|desi|design|dev|diamonds|diet|digital|direct|directory|discount|discover|diy|dnp|docs|doctor|dog|doha|domains|dot|download|drive|dubai|duck|durban|earth|eat|eco|education|email|energy|engineer|engineering|enterprises|equipment|esq|estate|eurovision|eus|events|everbank|exchange|expert|exposed|express|fail|faith|family|fan|fans|farm|farmers|fashion|fast|feedback|fidelity|film|final|finance|financial|fire|fish|fishing|fit|fitness|flights|flir|florist|flowers|fly|foo|food|football|forsale|forum|foundation|free|frl|frontdoor|fun|fund|furniture|futbol|fyi|gal|gallery|game|games|garden|gdn|gent|gift|gifts|gives|giving|glass|global|gmbh|gold|golf|got|graphics|gratis|green|gripe|grocery|group|guide|guitars|guru|hair|hamburg|haus|health|healthcare|help|helsinki|here|hiphop|hitachi|hiv|hockey|holdings|holiday|homes|horse|hospital|host|hosting|hot|hoteles|hotels|house|how|ice|icu|imamat|immo|inc|industries|info|ing|ink|institute|insurance|insure|int|international|investments|irish|ismaili|ist|istanbul|java|jetzt|jewelry|jo|jobs|joburg|jot|joy|jprs|juegos|kaufen|kddi|ke|kim|kinder|kitchen|kiwi|koeln|kosher|kpmg|kpn|krd|kred|kuokgroup|kyoto|lacaixa|ladbrokes|lamer|lancia|lancome|land|lat|latino|latrobe|law|lawyer|lds|lease|leclerc|legal|lgbt|life|lifeinsurance|lifestyle|lighting|like|lilly|limited|limo|linde|link|lipsy|live|living|llc|loan|loans|locker|lol|london|lotto|love|ltd|ltda|luxe|luxury|madrid|maison|makeup|man|management|mango|map|market|marketing|markets|mba|med|media|meet|melbourne|meme|memorial|men|menu|miami|mini|mint|mit|mlb|mls|mma|mobi|mobile|mobily|moda|moe|moi|mom|monash|money|mormon|mortgage|moscow|moto|motorcycles|mov|movie|movistar|msd|mtn|mtr|museum|mutual|nab|nadex|nagoya|name|nationwide|natura|navy|nec|net|netbank|network|new|news|next|nextdirect|ngo|ninja|now|nowruz|nrw|nyc|observer|office|okinawa|oldnavy|one|ong|onl|online|ooo|open|org|organic|origins|osaka|ott|ovh|page|paris|pars|partners|parts|party|passagens|pay|pet|pharmacy|phd|phone|photo|photography|photos|physio|pics|pictures|pid|pin|ping|pink|pizza|place|play|plumbing|plus|poker|politie|porn|post|press|prime|pro|prod|productions|prof|promo|properties|property|protection|pub|qpon|quebec|quest|racing|radio|raid|read|realestate|realtor|realty|recipes|red|rehab|reise|reisen|reit|rent|rentals|repair|report|republican|rest|restaurant|review|reviews|rich|rio|rip|rocks|rodeo|room|rsvp|rugby|ruhr|run|ryukyu|saarland|safe|safety|sale|salon|sarl|save|scholarships|school|schule|science|scot|search|seat|secure|security|seek|select|services|seven|sew|sex|sexy|shell|shia|shiksha|shoes|shop|shopping|show|showtime|silk|singles|site|ski|skin|smile|soccer|social|softbank|software|solar|solutions|song|soy|space|sport|spot|spreadbetting|srl|star|stockholm|storage|store|stream|studio|study|style|sucks|supplies|supply|support|surf|surgery|swiss|sydney|systems|tab|taipei|talk|target|tatar|tattoo|tax|taxi|team|tech|technology|tel|tennis|theater|theatre|tickets|tienda|tips|tires|tirol|today|tokyo|tools|top|total|tours|town|toys|trade|trading|training|travel|travelers|trust|trv|tube|tui|tunes|university|uno|vacations|vegas|ventures|versicherung|vet|viajes|video|vig|viking|villas|vin|vip|vision|vivo|vlaanderen|vodka|vote|voting|voto|voyage|vuelos|wales|wang|wanggou|watch|watches|weather|webcam|website|wed|wedding|weibo|weir|whoswho|wien|wiki|win|wine|winners|work|works|world|wow|wtf|xihuan|xin|xyz|yachts|yoga|yokohama|you|yun|zara|zero|zip|zone|zuerich|ca|us|co|cc|me|ac|tv|in)"

	#supported TLD list - but will output raw whois info
	tldlist0="+(ad|ae|af|ag|ai|al|am|ao|aq|ar|as|at|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bm|bn|bo|br|bs|bt|bw|by|bz|cd|cf|cg|ch|ci|ck|cl|cm|cn|cr|cu|cv|cw|cx|cy|cz|de|dj|dk|dm|do|dz|ec|ee|eg|er|es|et|fi|fj|fk|fm|fo|fr|ga|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|io|iq|ir|is|it|je|jm|jo|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|mg|mh|mk|ml|mm|mn|mo|mp|mq|mr|ms|mt|mu|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|om|pa|pe|pf|pg|pk|pl|pm|pn|pr|ps|pt|pw|py|qa|re|ro|rs|ru|rw|sa|sb|sc|sd|se|sh|si|sk|sl|sm|sn|so|sr|ss|st|sv|sx|sy|sz|tc|td|tf|tg|th|tj|tk|tl|tm|tn|to|tr|tt|tw|tz|ua|ug|uy|uz|va|vc|ve|vg|vi|vu|wf|ws|ye|yt|za|zm|zw)"

	#exclulded TLDS
	tldlistx="+(abbott|abb|abarth|abbvie|abc|aco|arte|asda|adac|aeg|aig|aigo|airbus|airtel|agakhan|akdn|alfaromeo|alibaba|alipay|allfinanz|allstate|alstom|amfam|audi|audible|accenture|aetna|afamilycompany|auspost|afl|americanexpress|americanfamily|amex|amica|analytics|android|anz|aol|apple|aquarelle|aramco|athleta|avianca|bentley|aws|axa|azure|bananarepublic|baidu|banamex|bauhaus|bbc|bbt|blanco|bbva|bcg|beats|bnl|bnpparibas|boehringer|bofa|bosch|bostik|bom|bond|bloomberg|bridgestone|bradesco|bugatti|barclaycard|barclays|bestbuy|bharti|bing|bms|bmw|calvinklein|citi|canon|capitalone|caseih|cartier|chanel|cisco|chintai|chrysler|comcast|commbank|cookingchannel|cuisinella|csc|cyou|datsun|dclk|dell|delta|dhl|dtv|duns|dupont|dvag|dvr|edeka|emerck|deloitte|dish|dodge|dunlop|epost|erni|esurance|etisalat|extraspace|epson|ericsson|fedex|ferrari|ferrero|fiat|firestone|flickr|forex|frontier|fage|fairwinds|fido|firmdale|foodnetwork|ford|fox|fresenius|frogans|ftr|fujitsu|fujixerox|gallo|gallup|gap|gbiz|gea|genting|george|ggee|glade|gle|globo|gmo|gmx|goldpoint|goo|goog|gop|godaddy|goodyear|google|grainger|gmail|guardian|gucci|guge|hangout|hbo|hdfc|hermes|hgtv|hisamitsu|hdfcbank|hkt|homedepot|homegoods|homesense|honda|honeywell|hotmail|hsbc|hughes|hyatt|hyundai|ieee|ibm|icbc|infiniti|ifm|ikano|imdb|immobilien|intel|intuit|ipiranga|iselect|itau|itv|iveco|jaguar|jcb|jcp|jeep|jio|jll|jmp|jnj|juniper|jpmorgan|kerryhotels|kerrylogistics|kerryproperties|kfh|kia|kindle|komatsu|lamborghini|lancaster|landrover|lasalle|lexus|lincoln|lanxess|lixil|lefrak|locus|lpl|liaison|loft|lego|lotte|lidl|lplfinancial|lupin|macys|maif|marriott|marshalls|maserati|mattel|mckinsey|lundbeck|merckmsd|metlife|microsoft|mitsubishi|monster|mopar|nba|neustar|newholland|nexus|nfl|nhk|nico|nike|nikon|nissan|nissay|nokia|norton|northwesternmutual|nowtv|nra|ntt|obi|olayan|olayangroup|ollo|off|omega|onyourside|oracle|orange|otsuka|panasonic|piaget|pfizer|philips|pictet|pccw|pioneer|pnc|playstation|pohl|pramerica|praxi|progressive|pru|prudential|pwc|qvc|redstone|redumbrella|reliance|ren|rexroth|richardli|ricoh|rightathome|ril|rmit|rocher|rogers|rwe|sakura|samsclub|samsung|sandvik|sandvikcoromant|sanofi|sap|sas|saxo|sbi|sbs|sca|scb|schaeffler|sling|schmidt|schwarz|scjohnson|scor|sener|ses|sfr|shangrila|sharp|shaw|shouji|shriram|sina|skype|smart|sncf|sohu|sony|spiegel|srt|stada|sky|staples|starhub|statebank|statefarm|stc|stcgroup|suzuki|swatch|swiftcover|symantec|taobao|tatamotors|tci|tdk|telefonica|temasek|teva|thd|tiaa|tiffany|tjmaxx|tjx|tkmaxx|tmall|toray|toshiba|toyota|travelchannel|travelersinsurance|tushu|tvs|ubank|ubs|uconnect|unicom|uol|ups|vana|vanguard|verisign|virgin|visa|vistaprint|viva|volkswagen|volvo|walmart|walter|warman|weatherchannel|williamhill|windows|weber|wme|wolterskluwer|woodside|wtc|xbox|xerox|xfinity|yahoo|yamaxun|yodobashi|youtube|zappos|zippo)"

	case $tld in

	$tldlistx)
	echo -e "\nThis TLD was added to the unsupported TLD list.\n\n\nTo know why it unsupported contact the admin."
	;;

	$tldlistg)
	############
	### CORE ###
	###########
	#stores the registrar name on a variable
	registrar=$(echo "$zyx" | grep -i -e "registrar:" | sort -u )

	#stores the func processed domain status on a variable
	dsfrgt=$( dsfunction "$(echo "$zyx" | grep -i -e "status:" )" )

	#stores the domain's creation date
	creationdate0=$(echo "$zyx" | grep -i -e "Creation date:")
	creationdate1=$( echo "${creationdate0#*:}"| sed 's/T/\ Time: /g' )
	dayssince0=$( countdfunc "$creationdate0" )

	#stores the domain's expiration date from the registry
	expdx0=$(echo "$zyx" | grep -i -e "Registry expiry date:")
	expdx1=$( echo "${expdx0#*:}" | sed 's/T/\ Time: /g' )
	dayslefttry0=$( countdfunc "$expdx0" )

	#stores the domain's expiration date from the registrar
	if [[ -z "$whoisserver" ]] || [[ "$whoisserver" = " " ]]; then
	expd1="Expiry Date Not Found. Consult the Registrar."
	daysleftrar0="Counter Error: Whois server Not Found!"
	else
	expd0=$(echo "$zyx2" | grep -i -e "Registrar registration expiration date:")
		if [[ -z "$expd0" ]] || [[ "$expd0" = " " ]]; then
		expd1="Expiry Date Not Found. Consult the Registrar."
		daysleftrar0="Counter Error: Date Not Found!"
		else
		expd1=$( echo "${expd0#*:}" |sed 's/T/\ Time: /g' | sed 's/tration/\y/g' )
		daysleftrar0=$( countdfunc "$expd0" )
		fi
	fi

	#COUNTER VAR CONDITIONALS
	if [[ "$dayssince0" = "0" ]]; then
	dayssincevar="Domain was registered"
	dayssince="today!"
	else
	dayssincevar="Days counted since creation"
	dayssince="${dayssince0#*-}"
	fi

	if [[ "${dayslefttry0:0:1}" = "-" ]]; then
	dltryvar="Days Expired (Registry)"
	dayslefttry=${dayslefttry0#*-}
	else
	dltryvar="Days Left (Registry)"
	dayslefttry="$dayslefttry0"
	fi

	if [[ "${daysleftrar0:0:1}" = "-" ]]; then
	dlrarvar="Days Expired (Registrar)"
	daysleftrar=${daysleftrar0#*-}
	else
	dlrarvar="Days Left (Registrar)"
	daysleftrar="$daysleftrar0"
	fi

	echo -e "__________________________\n\nDomain Name: $domain\nRegistrar: ${registrar#*:}\nReseller: $reese\n__________________________\n\nDomain Status:\n\n$dsfrgt\n__________________________\n\nCreation Date: $creationdate1\nRegistry Expiry Date: $expdx1\nRegistrar Expiry Date: $expd1\n__________________________"

	if [[ $checknsrb = 'y' ]]; then
	echo -e "\n--------------------------\nBased on this server's time and time zone\n($(date))\n\n$dayssincevar : $dayssince \n$dltryvar : $dayslefttry \n$dlrarvar: $daysleftrar \n--------------------------\n__________________________\n"
	fi

	#verifies if an auth resolves to an IP address - good for verifying glue records
	nscheckfunc () {
	while IFS= read -r linec; do
	dqns=$( echo "${linec#*:}" | tr -d '\040\011\012\015' )
		if [[ -z "$( dig a +short $dqns @8.8.8.8 )" ]]; then
        nsxcr="y"
    	else
    	nsxcr="x"
    	fi
	echo "$nsxcr"
	done < <(printf '%s\n' "$1")
	}

	#######################################
	#checks if the authoritative ns is digable
	#######################################
	nstqfunc () {
	xnsxx=$( nsfunction "$1" "x" )

	while IFS= read -r xline; do
	xcount=$(( $xcount + 1 ))
	nssfa=$( echo ${xline#*:} | tr -d '\040\011\012\015' )
	arayko[$xcount]="$nssfa"
	linecheck=$( dig a +short "${arayko[$xcount]}" @8.8.8.8 )
	lcdc=$( dig +short a example.com @${arayko[$xcount]} | tr -d '\040\011\012\015' )
		if [[ -z "$linecheck" ]] && [[ -z "${arayko[$(( $xcount - 1 ))]}" ]]; then
        xqns="8.8.8.8"
		elif [[ -z "$linecheck" ]] || [[ "${lcdc:0:2}" = ";;" ]]; then
        xqns="${arayko[$(( $xcount - 1 ))]}"
		else
        xqns="${arayko[$xcount]}"
		fi
	done < <(printf '%s\n' "$xnsxx")
	echo "$xqns"
	}

	if [[ $checknsrb = "n" ]]; then
	nstoquery="8.8.8.8"
	nscheck="x"
	elif [[ $checknsrb = "y" ]]; then
	nstoquery=$( nstqfunc "$nsxx")
	nscheck=$( nscheckfunc "$nsxx" | gawk '!seen[$0]++' | tr -d '\040\011\012\015' )
	else
	echo "wow"
	fi

	if [[ "$nscheck" = "y" ]]; then
	ns0frgt=$( nsfunction "$nsxx" "z" "\n")
	arfrgt=$( arfunction "$(dig +short $domain @8.8.8.8 )" )
	arecho=$(echo -e "Authoritative Name servers invalid.\nThe following is/are from 8.8.8.8:\n$arfrgt" )
	mrfrgt=$( mrfunction "$(dig mx +short $domain @8.8.8.8 | sort -n )" )
	mxrecho=$( echo -e "Authoritative Name servers invalid.\nThe following is/are from 8.8.8.8:\n$mrfrgt")

	echo -e "$ns0frgt\n__________________________\n\n$arecho\n__________________________\n$mxrecho\n__________________________\n"

	elif [[ "$nscheck" = "yx" ]]; then
	ns0frgt=$( nsfunction "$nsxx" "z" "\n")
	arfrgt=$( arfunction "$(dig +short $domain @8.8.8.8 )" )
	arecho=$(echo -e "Critical issue found on 1 or more authoritative name server.\nQueried 8.8.8.8 instead.\n$arfrgt")
	mrfrgt=$( mrfunction "$(dig mx +short $domain @8.8.8.8 | sort -n )" )
	mxrecho=$( echo -e "Critical issue found on 1 or more authoritative name server.\nQueried 8.8.8.8 instead.\n$mrfrgt")

	echo -e "$ns0frgt\n__________________________\n$arecho\n__________________________\n$mxrecho\n__________________________\n"

	elif [[ "$nscheck" = "x" ]] || [[ "$nscheck" = "xy" ]]; then
	nsfrgt=$( nsfunction "$nsxx" "" "" )
	arfrgt=$( arfunction "$nstoquery" "x" )
	mrfrgt=$( mrfunction "$nstoquery" "x" )

	echo -e "$nsfrgt\n__________________________\n\n$arfrgt\n__________________________\n\n$mrfrgt\n__________________________\n"
	else
    echo -e "\n\n\nSeriously?!? you ended up here?... wow!\n\n\n"
	fi

	;;
	############
	### CORE ###
	###########

	edu)

	zyx=$($zyxwhois $domain)
	arfredu=$( arfunction "$(dig +short $domain @8.8.8.8 )" )
	mrfredu=$( mrfunction "$(dig mx +short $domain @8.8.8.8 | sort -n )" 'y' )

	echo "\n${zyx#*-------------------------------------------------------------}\n__________________________\n\n$arfredu\n__________________________\n\n$mrfredu\n__________________________\n\n${zyx%-------------------------------------------------------------*}\n\n"

	exit 0
	;;

	gov)

	zyx=$($zyxwhois $domain)
	ar=$(dig +short $domain @8.8.8.8)
	arfrgov=$( arfunction "$ar" )
	mrfrgov=$( mrfunction "$(dig mx +short $domain @8.8.8.8 | sort -n )" 'y')
	zyx0=$(echo "$zyx" | gawk '/DOTGOV WHOIS Server ready/{flag=1;next}/>>>/{flag=0}flag' )

	echo -e "\n\n$zyx0\n__________________________\n\n$arfrgov\n__________________________\n\n$mrfrgov\n__________________________\n"
	exit 0
	;;

	mil)
	arfrmil=$( arfunction "$(dig +short $domain @8.8.8.8 )" )
	mrfrmil=$( mrfunction "$(dig mx +short $domain @8.8.8.8 | sort -n )" 'y' )

	echo -e "\nInput: $domain\n\n\nThis TLD has no whois server.\n\n.mil domains are exclusively for the use of the United States Department of Defense\n\nThe domain name mil is the sponsored top-level domain (sTLD) in the Domain Name System of the Internet for the United States Department of Defense and its subsidiary or affiliated organizations. More info at https://en.wikipedia.org/wiki/.mil\n\n__________________________\n\n$arfrmil\n__________________________\n\n$mrfrmil\n__________________________\n"
	exit 0
	;;

	$tldlist0)

	zyx=$($zyxwhois $domain)

	#dig A and MX with minimal essential output from Google DNS servers
	arfrct=$( arfunction "$(dig +short $domain @8.8.8.8 )" )
	mrfrct=$( mrfunction "$(dig mx +short $domain @8.8.8.8 | sort -n )" 'y' )

	echo -e "\nTLD does not have any configured custom result, \nfalling back to raw whois result.\n\n$zyx\n__________________________\n\n$arfrct\n__________________________\n\n$mrfrct\n__________________________"

	;;

	#special trimming for AU ccTLDs
	au)

	zyx=$($zyxwhois $domain )

	#dig A and MX with minimal essential output
	arfrctau=$( arfunction "$(dig +short $domain @8.8.8.8 )" )
	mrfrctau=$( mrfunction "$(dig mx +short $domain @8.8.8.8 | sort -n )" 'y' )

	if [[ ! -z $( echo "$zyx" | grep -w "WHOIS LIMIT EXCEEDED" ) ]]

	then
    echo -e "\nThe whois server/s of auDA (AU Domain Administration ) solely responds for whois queries regarding '.au' domains. And like most whois servers out there there is a limit on how many times their server/s will respond to whois queries from an I.P address on a given time. The IP address of this server has reach the said limit, you can either wait for this server to be able to query auDA's whois server/s again, or you can go to https://whois.auda.org.au to get the raw whois information of $domain directly from auDA's web interface.\n__________________________\n$arfrctau\n__________________________\n\n$mrfrctau \n__________________________\n"

	exit 0

	else

	registrar=$(echo "$zyx" | grep -i -e "registrar name:" -e "registrar:")

	dsfrctau=$( dsfunction "$(echo "$zyx" | grep -i -e "status:" )" )

	nsfrctau=$( nsfunction "$(echo "$zyx" | grep -i -e "name server:" )" )

	regcontact=$(echo "$zyx" | grep -i -e "Registrant Contact Name:")

	techcontact=$(echo "$zyx" | grep -i -e "Tech Contact Name:")

	echo -e "\n__________________________\n\nDomain Name: $domain\nRegistrar: ${registrar#*:}\n__________________________\n\nDomain Status:\n\n$dsfrctau\n__________________________\n$nsfrctau\n__________________________\n\n$regcontact\n$techcontact\n__________________________\n\n$arfrctau\n__________________________\n\n$mrfrctau\n__________________________\n"

	fi

	;;

	#special trimming for NZ ccTLDs
	nz)

	zyx=$($zyxwhois $domain)
	arfrctnz=$( arfunction "$(dig +short $domain @8.8.8.8 )")
	mrfrctnz=$( mrfunction "$(dig mx +short $domain @8.8.8.8 | sort -n )" 'y' )

	registrar=$(echo "$zyx" | grep -i -e "registrar_name:")

	regcoun=$( echo "$zyx" | grep -i -e "registrar_country:")

	#stores the domain status
	dsnzfunc () {
	dstat="$1"
	while IFS= read -r line; do
	echo "${line#*#}"
	done < <(printf '%s\n' "${dstat#*:}")
	}
	dsnzfuncr=$( dsnzfunc "$(echo "$zyx" | grep -i -e "query_status:" )" )

	lastmod=$(echo "$zyx" | grep -i -e "domain_datelastmodified:")

	nameservers=$(echo "$zyx" | grep -i -e "ns_name_.*")
	nsfrctnz=$( nsfunction "$nameservers")

	echo -e "\n__________________________\n\nDomain Name: $domain\nRegistrar: ${registrar#*:}\nRegistrar Country: ${regcoun#*:}\n__________________________\nDomain Status:\n$dsnzfuncr\n--------------------------\nLast Modified: ${lastmod#*:}\n__________________________\n$nsfrctnz\n__________________________\n$arfrctnz\n__________________________\n$mrfrctnz\n__________________________\n"
	;;

	#special whois result trim for UK TLDs
	uk)
	zyx=$($zyxwhois $domain)
	zyxuk0=$(echo "$zyx" | gawk '/Registrar:/{flag=1;next}/WHOIS lookup made at/{flag=0}flag' )
	arfrctuk=$( arfunction "$(dig +short $domain @8.8.8.8 )" )
	mrfrctuk=$( mrfunction "$(dig mx +short $domain @8.8.8.8 | sort -n )" 'y' )
	echo -e "\nDomain name: $domain\n\nRegistrar:\n$zyxuk0\n__________________________\n\n$arfrctuk\n__________________________\n\n$mrfrctuk\n__________________________\n\nRaw whois result below:\n\n$zyx\n"

	;;

	#special whois result trim for EU TLDs
	eu)
	zyx=$($zyxwhois $domain)
	zyxeu0=$(echo "$zyx" | gawk '/Domain:/{flag=1;next}/Keys:/{flag=0}flag' )

	arfrcteu=$( arfunction "$(dig +short $domain @8.8.8.8 )" )
	mrfrcteu=$( mrfunction "$(dig mx +short $domain @8.8.8.8 | sort -n )" 'y' )
	echo -e "\nDomain: $domain\n$zyxeu0\n__________________________\n$arfrcteu\n__________________________ \n\n$mrfrcteu\n__________________________\n\nRaw whois result below:\n\n$zyx\n\n"
	;;

	#special result for .ph ccTLD
	ph)
	arfrph=$( arfunction "$(dig +short $domain @8.8.8.8 )" )
	mrfrph=$( mrfunction "$(dig mx +short $domain @8.8.8.8 | sort -n )" 'y' )
	echo -e "\nFor the  Whois info of this .ph domain, \nVisit the link below:\n\nhttps://whois.dot.ph/?utf8=%E2%9C%93&search=$domain\n\n__________________________ \n\nDomain: $domain\n__________________________\n\n$arfrph\n__________________________\n\n$mrfrph\n__________________________\n"
	exit 0
	;;

	#special result for .sg ccTLD
	sg)
	arfrsg=$( arfunction "$(dig +short $domain @8.8.8.8)" )
	mrfrsg=$( mrfunction "$(dig mx +short $domain @8.8.8.8 | sort -n )" 'y' )
	echo -e "\nFor the  Whois info of this .sg domain, \nVisit the link below:\n\nhttps://www.sgnic.sg/domain-search.html?SearchKey=$domain\n\n__________________________ \n\nDomain: $domain\n__________________________ \n\n$arfrsg\n__________________________\n\n$mrfrsg\n__________________________\n"
	exit 0
	;;

	#special result for .vn ccTLD
	vn)
	arfrvn=$( arfunction "$(dig +short $domain @8.8.8.8 )" )
	mrfrvn=$( mrfunction "$(dig mx +short $domain @8.8.8.8 | sort -n )" )
	echo -e "\nFor the  Whois info of this .vn domain, \nVisit the link below:\n\nhttps://vnnic.vn/en/whois-information?lang=en\n\n__________________________\n\nDomain:$domain\n\n__________________________\n\n$arfrvn\n__________________________ \n\n$mrfrvn\n__________________________\n"
	exit 0
	;;

	jp)
	zyx=$($zyxwhois $domain);

	arfrjp=$( arfunction "$(dig +short $domain @8.8.8.8 )" )
	mrfrjp=$( mrfunction "$(dig mx +short $domain @8.8.8.8 | sort -n )" 'y' )
	echo -e "\n${zyx#*Domain Information:}\n\n__________________________\n\n$arfrjp \n__________________________\n\n$mrfrjp\n__________________________\n\n\nRaw whois result below:\n\n$zyx\n"
	;;

	#throw an error for everything else
	*)

	echo -e "\nInput : $domain\n\nNot a valid domain name (FQDN).\n"
	exit 0;

	;;
	esac

	fi

	fi

	registrant=$(echo "$zyx2" | grep -i -e "registrant .*:")
	admin=$(echo "$zyx2" | grep -i -e "admin .*:")
	tech=$(echo "$zyx2" | grep -i -e "tech .*:")

	if [[ -z "$registrant" ]]; then
	regwis="$(echo $whoisservergrep | tr -d '\040\011\012\015')"

	case "$regwis" in
	"RegistrarWHOISServer:http://api.fastdomain.com/cgi/whois")
	echo -e "\nGo to http://api.fastdomain.com/cgi/whois?domain=$domain for the raw whois info from the  FastDomain's whois server web interface.\nRegistry WHOIS Server: $trywis"

	exit 0
	;;

	*)
	echo "-----------------------------"

	if [[ -z "$whoisservergrep" ]]; then
	whoisservergrep="Registrar WHOIS Server: "
	echo "$whoisservergrep Not Found!"
	else

	if [[ -z "$whoisserver" ]]; then
    echo "$whoisservergrep Not Found!"
	else
	echo "$whoisservergrep"
	fi
	fi
	echo -e "Registry WHOIS Server: $trywis\n-----------------------------\n\n"
	;;
	esac

	else

	if [[ $checknsrb = 'y' ]]; then
	echo "-----------------------------"

	if [[ ! -z $registrant ]]; then
	echo -e "\n[ REGISTRANT: ]\n\n$registrant\n"
	fi

	if [[ ! -z $admin ]]; then
	echo -e "\n[ ADMIN: ]\n\n$admin\n"
	fi

	if [[ ! -z $tech ]]; then
	echo -e "\n[ TECH: ]\n\n$tech\n"
	fi

	fi

	echo "-----------------------------"

	if [[ -z "$whoisservergrep" ]]; then
	whoisservergrep="Registrar WHOIS Server:"
	echo "$whoisservergrep Not Found!"

	else

	if [[ -z "$whoisserver" ]]; then
    echo "$whoisservergrep Not Found!"
	else
    echo -e "$( echo "$whoisservergrep" | sed -e 's/^[ \t]*//' )"
	fi

	fi
	echo -e "Registry WHOIS Server: $trywis\n-----------------------------\n\n"

fi
exit 0
