@echo off
setlocal enabledelayedexpansion

set LOCAL_VOLUME_POSTGRES=".\postgres-data"
set LOCAL_VOLUME_MINIO=".\minio-data"
set LOCAL_VOLUME_QDRANT=".\qdrant-storage"

rem grab MINIO_ENDPOINT from ipconfig
set ip_address_string="IPv4"
for /f "usebackq tokens=2 delims=:" %%f in (`ipconfig ^| findstr /c:%ip_address_string%`) do (
	set ip=%%f 
)

set ip=%ip: =%

set MINIO_ENDPOINT=http://%ip%:7053

rem grab CRED_ID from docker network
FOR /F "tokens=*" %%g IN ('docker network inspect bridge --format="{{json .IPAM.Config}}"') do (SET ip_str=%%g)
set ip_str=%ip_str:"=%
set ip_str=%ip_str:,=%

Call :findInStr %ip_str%, Gateway
set start=%pos%
set /a start+=8

Call :findInStr %ip_str%, }
set /a length=%pos%-%start%

CALL SET ip=%%ip_str:~%start%,%length%%%

set CRED_ENDPOINT=http://%ip%:7053


rem copy docker-compose-template
copy "refinery\template\docker-compose.yml" "refinery\docker-compose.yml" >NUL

rem replace values in file
powershell -Command "(gc refinery\docker-compose.yml) -replace '{MINIO_ENDPOINT}', '%MINIO_ENDPOINT%' | Out-File -encoding ASCII refinery\docker-compose.yml"
powershell -Command "(gc refinery\docker-compose.yml) -replace '{CRED_ENDPOINT}', '%CRED_ENDPOINT%' | Out-File -encoding ASCII refinery\docker-compose.yml"
powershell -Command "(gc refinery\docker-compose.yml) -replace '{LOCAL_VOLUME_POSTGRES}', '%LOCAL_VOLUME_POSTGRES%' | Out-File -encoding ASCII refinery\docker-compose.yml"
powershell -Command "(gc refinery\docker-compose.yml) -replace '{LOCAL_VOLUME_MINIO}', '%LOCAL_VOLUME_MINIO%' | Out-File -encoding ASCII refinery\docker-compose.yml"
powershell -Command "(gc refinery\docker-compose.yml) -replace '{LOCAL_VOLUME_QDRANT}', '%LOCAL_VOLUME_QDRANT%' | Out-File -encoding ASCII refinery\docker-compose.yml"

    docker pull kernai/refinery-lf-exec-env:latest
    docker pull kernai/refinery-ml-exec-env:latest
    docker pull kernai/refinery-record-ide-env:latest

IF NOT EXIST .\refinery\oathkeeper\jwks.json (
    docker run --rm docker.io/oryd/oathkeeper:v0.38 credentials generate --alg RS256 > refinery\oathkeeper\jwks.json
)


docker-compose -f refinery\docker-compose.yml up -d 

echo UI:           http://localhost:4455/app/
echo Minio:        %MINIO_ENDPOINT%
echo MailHog:      http://localhost:4436/

pause
goto :eof


:findInStr
Set "basestr=%~1"
Set "sstr=%~2"
set /a pos=0
Set "sst0=!basestr:*%sstr%=!"
if "%sst0%"=="%basestr%" echo "%sstr%" not found in "%basestr%"&goto :eof
Set "sst1=!basestr:%sstr%%sst0%=!"
if "%sst1%" neq "" for /l %%i in (0,1,8189) do if "!sst1:~%%i,1!" neq "" set /a pos+=1

EXIT /B 0
