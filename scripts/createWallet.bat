@ECHO OFF
if "%~1"=="" (
	echo No wallet name has been specified.
	exit 1
)
set walletsDir=./wallets
solana-keygen new --no-bip39-passphrase --outfile %walletsDir%/%1.json
FOR /F "tokens=* USEBACKQ" %%F IN (`solana-keygen pubkey %walletsDir%/%1.json`) DO (
SET pubkey=%%F
)
solana-keygen verify %pubkey% %walletsDir%/%1.json