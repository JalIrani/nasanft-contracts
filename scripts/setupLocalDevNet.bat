@ECHO OFF
solana-test-validator
solana config set --url localhost

solana config set --url https://api.devnet.solana.com

echo For best results CLI version should be same as Cluster version

rem set cliVersion variable to the result of the command to get the cli version
FOR /F "tokens=* USEBACKQ" %%F IN (`solana --version`) DO (
SET cliVersion=%%F
)
echo CLI Version: %cliVersion%

rem rem set clusterVersion variable to the result of the command to get the cluster version
FOR /F "tokens=* USEBACKQ" %%F IN (`solana cluster-version`) DO (
SET clusterVersion=%%F
)
echo Cluster Version: %cliVersion%
