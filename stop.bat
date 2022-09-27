@echo off

echo "We are currently experiencing some issues with refinery."
echo "We are working on it. Sorry, for the inconvenience."
echo "If you pull the repository and this message is still there, please try to pull it at a later time."
exit 1

docker-compose -f refinery\docker-compose.yml down --remove-orphans
if "%1" neq "update" pause