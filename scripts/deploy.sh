#!/bin/sh
if [ -z "$1" ]; then
	echo No wallet name has been specified.
	exit 1
fi

. $(dirname "$0")/setEnv.sh
#deploy
anchor deploy --provider.wallet "$walletsDir/$1.json"