@ECHO OFF
solana config set --url https://api.devnet.solana.com

echo For best results CLI version should be same as Cluster version

FOR /F "tokens=* USEBACKQ" %%F IN (`solana --version`) DO (
SET cliVersion=%%F
)
echo CLI Version: %cliVersion%

FOR /F "tokens=* USEBACKQ" %%F IN (`solana cluster-version`) DO (
SET clusterVersion=%%F
)
echo Cluster Version: %cliVersion%
