#!/bin/sh
if [ -z "$1" ]; then
	echo No wallet name has been specified.
	exit 1
fi
. $(dirname "$0")/setEnv.sh

#set pubKey variable to the result of the command to get the public address
pubkey=`solana-keygen pubkey $walletsDir/$1.json`
#print public key
echo $pubkey