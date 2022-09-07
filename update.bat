@echo off

echo Checking for updates...
for /f "tokens=*" %%a in ('powershell -Command "Invoke-WebRequest -URI http://localhost:7062/has_updates?as_html_response=true"') do (set HAS_UPDATES=%%a)
if "%HAS_UPDATES%"=="True" (
    echo Updates found, updating...
) elif "%HAS_UPDATES%"=="False" (
    echo No updates available. You are up to date.
    exit
) else (
    echo Refinery doesn't seem to run. It cannot be checked if any updates are available.
    echo Do you want to try to update anyway? (y/n)
    set /p UPDATE_ANYWAY=
    if "%UPDATE_ANYWAY%"=="y" (
        echo Updating...
    ) else (
        echo Exiting...
        exit
    )
)

echo Stopping running containers...
call stop.bat

echo Pulling repository from github...
git checkout release
git pull

echo Updating kern-refinery python package...
:: TODO: check if kern-refinery is installed, update if so
pip install -U kern-refinery

echo Pulling newest images of exec envs...
docker pull kernai/refinery-lf-exec-env:latest
docker pull kernai/refinery-ml-exec-env:latest
docker pull kernai/refinery-record-ide-env:latest

echo Pulling newest images of refinery...
docker-compose -f refinery\docker-compose.yml pull


echo Starting refinery containers...
call start.bat
::TODO add sleep

echo Triggering refinery-updater...
powershell -Command "Invoke-WebRequest -URI http://localhost:7062/update_to_newest"

echo Refinery has been updated to the latest version and is running on:
echo UI:           http://localhost:4455/app/
echo Minio:        %MINIO_ENDPOINT%
echo MailHog:      http://localhost:4436/

pause