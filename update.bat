@echo off

echo Checking for updates...
for /f "delims=" %%a in ('powershell -Command "Invoke-WebRequest -URI http://localhost:7062/has_updates?as_html_response=true"') do set HAS_UPDATES=%%a
if "%HAS_UPDATES%"=="True" (
    echo Updates found, updating...
) else (
    echo No updates found, exiting...
    exit
)

echo Stopping running containers...
call stop.bat

echo Pulling repository from github...
git checkout release
git pull

echo Updating kern-refinery python package...
pip install -U kern-refinery

echo Pulling newest images of exec envs...
docker pull kernai/refinery-lf-exec-env:latest
docker pull kernai/refinery-ml-exec-env:latest
docker pull kernai/refinery-record-ide-env:latest

echo Pulling newest images of refinery...
docker-compose -f refinery\docker-compose.yml pull

echo Starting refinery containers...
call start.bat

echo Triggering refinery-updater...
powershell -Command "Invoke-WebRequest -URI http://localhost:7062/update_to_newest"

echo Refinery has been updated to the latest version and is running on:
echo UI:           http://localhost:4455/app/
echo Minio:        %MINIO_ENDPOINT%
echo MailHog:      http://localhost:4436/

pause