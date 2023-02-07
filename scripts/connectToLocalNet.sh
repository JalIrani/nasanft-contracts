#!/bin/sh
. $(dirname "$0")/setEnv.sh
#For wsl Validator doesnt like running on /mnt/
cd ~
solana config set --url localhost
solana-test-validator &

#give validator some time to start
sleep 3

echo For best results CLI version should be same as Cluster version

#set cliVersion variable to the result of the command to get the cli version
cliVersion=`solana --version`
echo CLI Version: $cliVersion

#set clusterVersion variable to the result of the command to get the cluster version
clusterVersion=`solana cluster-version`
echo Cluster Version: $clusterVersion

wait