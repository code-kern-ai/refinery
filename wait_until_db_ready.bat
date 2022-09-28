@echo off

echo starting db...

docker-compose -f refinery\docker-compose.yml up -d graphql-postgres

SET name=initial
FOR /F "tokens=*" %%g IN ('"docker ps -f name=graphql-postgres --format {{.Names}}"') do (SET name=%%g)

IF "%name%" == "initial" (
	echo cant find name
	goto :eof
)

:RECHECK
docker exec %name% pg_isready > nul
IF %ERRORLEVEL% NEQ 0 ( 
	timeout 1 > nul
	goto RECHECK
)

echo db ready.

