#!/bin/sh
if [ -z "$1" ];
then
      echo No wallet name has been specified.
	  exit 1
fi
. $(dirname "$0")/setEnv.sh

#create wallet
solana-keygen new --no-bip39-passphrase --outfile $walletsDir/$1.json
#Optionally set default wallet
if [ "$2" = "--not-default" ];
then
	echo --not-default specified: This wallet will not be set as the default wallet
else
	echo --not-default not specified: This will be set as the default wallet
	solana config set --keypair "$walletsDir/$1.json"
fi
#set pubKey variable to the result of the command to get the public address
pubkey=`solana-keygen pubkey $walletsDir/$1.json`

#verify we got the right public key
solana-keygen verify $pubkey $walletsDir/$1.json