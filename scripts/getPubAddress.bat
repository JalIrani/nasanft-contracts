ECHO @OFF
if "%~1"=="" (
	echo No wallet name has been specified.
	exit 1
)
CALL %~dp0setEnv

rem set pubKey variable to the result of the command to get the public address
FOR /F "tokens=* USEBACKQ" %%F IN (`solana-keygen pubkey %walletsDir%/%1.json`) DO (
SET pubkey=%%F
)
rem print public key
echo %pubkey%