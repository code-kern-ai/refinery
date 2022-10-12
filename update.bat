@echo off

call stop.bat

git checkout main
git pull

call start.bat
