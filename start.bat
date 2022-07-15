@echo off
setlocal enabledelayedexpansion

rem grab MINIO_ENDPOINT from ipconfig
set ip_address_string="IPv4 Address"
for /f "usebackq tokens=2 delims=:" %%f in (`ipconfig ^| findstr /c:%ip_address_string%`) do (
	set ip=%%f 
    goto :meof
)
:meof

set ip=%ip: =%

set MINIO_ENDPOINT=http://%ip%:7053

rem copy docker-compose-template
copy "refinery\template\docker-compose.yml" "refinery\docker-compose.yml" >NUL

rem replace values in file
powershell -Command "(gc refinery\docker-compose.yml) -replace '{MINIO_ENDPOINT}', '%MINIO_ENDPOINT%' | Out-File -encoding ASCII docker\docker-compose.yml"

docker pull kernai/refinery-lf-exec-env:latest
docker pull kernai/refinery-ml-exec-env:latest
docker pull kernai/refinery-record-ide-env:latest

IF NOT EXIST .\refinery\oathkeeper\jwks.json (
    docker run --rm docker.io/oryd/oathkeeper:v0.38 credentials generate --alg RS256 > refinery\oathkeeper\jwks.json
)


docker-compose -f refinery\docker-compose.yml up -d 

echo "UI:           http://localhost:4455/app/"
echo "Minio:        %MINIO_ENDPOINT%"

pause