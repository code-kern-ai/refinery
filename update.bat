@echo off
setlocal enabledelayedexpansion

echo Checking refinery installation...
if exist "%~dp0\refinery\docker-compose.yml" (
    echo Refinery is installed.
) else (
    echo Refinery is not installed. Run start.bat to install the latest version.
    pause
    exit
)

echo Checking for updates...
for /f "tokens=1" %%a in (
    'powershell -Command ("Invoke-WebRequest -URI http://localhost:7062/has_updates?as_html_response=true).Content"'
) do (
    set HAS_UPDATES=%%a
)
if "%HAS_UPDATES%" == "True" (
    echo Updates found, updating...
) else if "%HAS_UPDATES%" == "False" (
    echo No updates available. You are up to date.
    pause
    exit
) else (
    echo "Refinery doesn't seem to run or in a version < 1.2.0. It cannot be checked if any updates are available."
    set /p UPDATE_ANYWAY="Do you want to try to update anyway? (y/n) "
    if "!UPDATE_ANYWAY!" == "y" (
    echo Updating...
) else (
    echo Exiting...
    pause
    exit
)
)

echo Stopping running containers...
call stop.bat update


echo Checking current branch...
git branch | findstr "^V\* release" > nul
if !ERRORLEVEL! == 0 (
    echo On release branch, pulling latest changes from github...
    git pull
) else (
    echo The current branch is not the release branch.
    set /p CHECKOUT_RELEASE="Do you want to checkout the release branch and continue updating? (y/n) "
    if "!CHECKOUT_RELEASE!" == "y" (
        echo Checking out release branch and pulling latest changes...
        git checkout release
        git pull
    ) else (
        set /p CONTINUE="Do you want to continue with the local version? (y/n) "
        if "!CONTINUE!" == "y" (
            echo Continuing update on the current branch...
        ) else (
            echo Stopping the update...
            echo Exiting...
            pause
            exit
        )
    )
)

echo Updating kern-refinery python package...
pip3 freeze | findstr "kern-refinery" > nul
if !ERRORLEVEL! == 0 (
    echo kern-refinery is installed. Updating...
    pip3 install --upgrade kern-refinery
) else (
    echo kern-refinery is not installed. Skipping update...
)

echo Pulling newest images of exec envs...
docker pull kernai/refinery-lf-exec-env:latest
docker pull kernai/refinery-ml-exec-env:latest
docker pull kernai/refinery-record-ide-env:latest

echo Pulling newest images of refinery...
docker-compose -f refinery\docker-compose.yml pull


echo Starting refinery containers...
call start.bat update

echo Triggering refinery-updater...
powershell -Command "Invoke-WebRequest -URI http://localhost:7062/update_to_newest -Method POST"

echo Refinery has been updated to the latest version and is running on:
echo UI:           http://localhost:4455/app/
echo Minio:        %MINIO_ENDPOINT%
echo MailHog:      http://localhost:4436/

pause