@echo off


docker-compose -f refinery\docker-compose.yml down --remove-orphans
if "%1" neq "update" pause
