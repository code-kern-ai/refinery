@echo off

:: path of the working directory with slashes instead of backslashes
:: removes the colon, and prepends a slash
set "PWD=%cd%"
set "PWD=%PWD:\=/%"
set "PWD=%PWD::=%"
set "PWD=/%PWD%"

:: grab MINIO_ENDPOINT from ipconfig
Call :setMinioEndpoint

docker pull kernai/alfred:v1.3.7

docker run -d --rm ^
--name alfred ^
-v /var/run/docker.sock:/var/run/docker.sock ^
-v %PWD%/refinery:/refinery kernai/alfred:v1.3.7 ^
python start.py %PWD%/refinery windows > nul

docker logs -f alfred

goto :eof

:setMinioEndpoint
set ip_address_string="IPv4"
for /f "usebackq tokens=2 delims=:" %%f in (`ipconfig ^| findstr /c:%ip_address_string%`) do (
	set ip=%%f
)
set ip=%ip: =%
set MINIO_ENDPOINT=http://%ip%:7053


:findstr
Set "basestr=%~1"
Set "sstr=%~2"
set /a pos=0
Set "sst0=!basestr:*%sstr%=!"
if "%sst0%"=="%basestr%" echo "%sstr%" not found in "%basestr%"&goto :eof
Set "sst1=!basestr:%sstr%%sst0%=!"
if "%sst1%" neq "" for /l %%i in (0,1,8189) do if "!sst1:~%%i,1!" neq "" set /a pos+=1^M
