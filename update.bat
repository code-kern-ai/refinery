@echo off
setlocal enabledelayedexpansion

echo Checking refinery installation...
if exist "%~dp0\refinery\docker-compose.yml" (
    echo Refinery is installed.
) else (
    echo Refinery is not installed. Run start.bat to install the latest version.
    pause
    goto :eof
)

echo Checking for updates...
for /f %%a in (
    'curl -X "GET" -s "http://localhost:7062/has_updates?as_html_response=true"'
) do (
    set HAS_UPDATES=%%a
)
if "%HAS_UPDATES%" == "True" (
    echo Updates found, updating...
) else if "%HAS_UPDATES%" == "False" (
    echo No updates available. You are up to date.
    pause
    goto :eof
) else (
    echo Refinery doesn't seem to run or in a version < 1.2.0. It cannot be checked whether any updates are available.
    set /p UPDATE_ANYWAY="Do you want to try to update anyway? (y/n) "
    if "!UPDATE_ANYWAY!" == "y" (
    echo Updating...
) else (
    echo Exiting...
    pause
    goto :eof
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
            echo Continuing update with the local version...
        ) else (
            echo Stopping the update...
            echo Exiting...
            pause
            goto :eof
        )
    )
)

echo Checking if kern-refinery is installed...
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

echo Triggering refinery-updater to update database...
curl -X "POST" "http://localhost:7062/update_to_newest" > nul

echo Refinery has been updated to the latest version!

pause