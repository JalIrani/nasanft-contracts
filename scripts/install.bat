@ECHO OFF
if "%~1"=="" (
	echo No installerDir has been specified.
	exit 1
)
curl https://release.solana.com/v1.14.13/solana-install-init-x86_64-pc-windows-msvc.exe --output $1 --create-dirs
%1 v1.14.13
solana --version