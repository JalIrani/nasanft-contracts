@ECHO OFF
if "%~1"=="" (
	echo No wallet name has been specified.
	exit 1
)

set walletsDir=./wallets
FOR /F "tokens=* USEBACKQ" %%F IN (`solana-keygen pubkey %walletsDir%/%1.json`) DO (
SET pubkey=%%F
)

rem Docs say max of only 1 sol per request but smart contract says max of 2
rem Docs say 1 sol per request smart contract technically allows 2 per request
rem but it seems when asking for 2 you get rate limited faster
solana airdrop 1 %pubkey% --url https://api.devnet.solana.com