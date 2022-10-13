@echo off

call stop.bat update

git checkout main
git pull

call start.bat update

pause