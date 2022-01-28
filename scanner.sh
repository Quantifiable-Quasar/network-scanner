#!/bin/sh

Help()
{
	echo "Basic network scanner"
	echo "Outfile is output.txt and contains all the up hosts"
	echo "-n: specify a network"
	echo "    ex. - ./scanner.sh -n 192.168.1"
	echo "    default is the connected LAN"
}

if [[ "$1" == "-h" || "$1" == "--h" || "$1" == "-help" || "$1" == "--help" ]]
then
	Help
	exit 0
fi

echo -n ""  > output.txt

network=$(ip route show | grep 'default via' | cut -d ' ' -f 3 | cut -d "." -f 1-3)
if [ $network 2> /dev/null != "" ]
then
	echo
	echo "Error: Invalid network"
	echo
	exit
fi

while getopts n: flag
do 
	case "$flag" in
		n) network=${OPTARG};;
	       \?) echo "Error: Invalid option"
		   exit;; 
	esac
done

for i in $(seq 254)
do
	is_up=$(ping -W 1 -c 1 $network.$i | grep 'from')
	if [ "$is_up" != '' ]
	then
		echo $network.$i is up
		echo $network.$i >> output.txt
	else
		echo $network.$i is down
	fi
done
echo =======================
echo alive hosts: 
cat output.txt
