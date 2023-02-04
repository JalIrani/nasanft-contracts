@ECHO OFF
if "%~1"=="" (
	echo No wallet name has been specified.
	exit 1
)
CALL %~dp0setEnv

rem create wallet
solana-keygen new --no-bip39-passphrase --outfile %walletsDir%/%1.json
rem set pubKey variable to the result of the command to get the public address
FOR /F "tokens=* USEBACKQ" %%F IN (`solana-keygen pubkey %walletsDir%/%1.json`) DO (
SET pubkey=%%F
)
rem verify we got the right public key
solana-keygen verify %pubkey% %walletsDir%/%1.json