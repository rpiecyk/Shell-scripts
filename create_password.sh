#!/bin/bash

set -euo pipefail

# Check if a valid # of arguments is given #
if [ $# -lt 2 ]
then
        echo -e "\nThis script requires 2 arguments. \n\
Usage: $0 24 sign || \n       $0 36 nosign\n"
        exit 1
fi

# Check if the first argument is greater than 23 #
while [ "$1" -lt 24 ] 
do
	echo -e "\nYou used a number that is too small. Try 24 or higher.\n"
	exit 2
done

# Check if the second argument is correct; generate passwd #
case "$2" in
                "sign" ) head /dev/urandom | tr -dc \
'A-Za-z0-9[~\!@\#\$%^&\*\(\)\-\+\{\}\\\/=]{$2,}."><:;\?|`' | \
head -c $1 ; echo ''
		exit 0
		;;
                "nosign" ) head /dev/urandom | tr -dc 'A-Za-z0-9' | \
head -c $1 ; echo ''
		exit 0
		;;
 		*) echo -e "\nYour second argument is incorrect. \n\
Try to use \"sign\" or \"nosign\" instead of \"$2\"\n"
		exit 3
		;;
esac

echo -e "\nSth went wrong, check the code.\n" && exit 4
