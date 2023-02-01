@ECHO OFF
if "%~1"=="" (
	echo No wallet name has been specified.
	exit 1
)
set walletsDir=./wallets
FOR /F "tokens=* USEBACKQ" %%F IN (`solana-keygen pubkey %walletsDir%/%1.json`) DO (
SET pubkey=%%F
)
echo %pubkey%