@echo off

SET name=initial
FOR /F "tokens=*" %%g IN ('"docker ps -f name=graphql-postgres --format {{.Names}}"') do (SET name=%%g)

IF "%name%" == "initial" (
	echo cant find name
	goto :eof
)

FOR /F "tokens=*" %%g IN ('docker exec %name% psql -d postgresql://postgres:onetask@graphql-postgres:5432 -c "SELECT COUNT(*) FROM  pg_tables WHERE schemaname = 'public' AND tablename  = 'alembic_version';" -qtAX') do (SET result=%%g)

IF "%result%" == "0" (
	echo creating table
	docker exec %name% psql -d postgresql://postgres:onetask@graphql-postgres:5432 -c "CREATE TABLE alembic_version (version_num VARCHAR(32) NOT NULL, PRIMARY KEY (version_num))" -qtAX
	echo table created
) ELSE (
	goto :eof
)

goto VERSION_87f463aa5112



:END

goto :eof

:VERSION_87f463aa5112

echo checking version 87f463aa5112

FOR /F "tokens=*" %%g IN ('docker exec %name% psql -d postgresql://postgres:onetask@graphql-postgres:5432 -c "SELECT COUNT(*) FROM information_schema.columns WHERE table_name='attribute' and column_name='source_code';" -qtAX') do (SET result=%%g)

IF "%result%" == "0" (
	goto VERSION_9618924f9679
) ELSE (
	Call :setVersion 87f463aa5112
	goto END
)

:VERSION_9618924f9679
echo checking version 9618924f9679
FOR /F "tokens=*" %%g IN ('docker exec %name% psql -d postgresql://postgres:onetask@graphql-postgres:5432 -c "SELECT COUNT(*) FROM  pg_tables WHERE schemaname = 'public' AND tablename  = 'labeling_access_link';" -qtAX') do (SET result=%%g)

IF "%result%" == "0" (
	goto VERSION_5b3a4deea1c4
) ELSE (
	Call :setVersion 9618924f9679
	goto END
)

:VERSION_5b3a4deea1c4
echo checking version 5b3a4deea1c4
FOR /F "tokens=*" %%g IN ('docker exec %name% psql -d postgresql://postgres:onetask@graphql-postgres:5432 -c "SELECT COUNT(*) FROM  pg_tables WHERE schemaname = 'public' AND tablename  = 'app_version';" -qtAX') do (SET result=%%g)

IF "%result%" == "0" (
	goto VERSION_992352f4c1f9
) ELSE (
	Call :setVersion 5b3a4deea1c4
	goto END
)

:VERSION_992352f4c1f9
echo checking version 992352f4c1f9
FOR /F "tokens=*" %%g IN ('docker exec %name% psql -d postgresql://postgres:onetask@graphql-postgres:5432 -c "SELECT COUNT(*) FROM  pg_tables WHERE schemaname = 'public' AND tablename  = 'organization';" -qtAX') do (SET result=%%g)

IF "%result%" == "0" (
	goto NO_VERSION
) ELSE (
	Call :setVersion 992352f4c1f9
	goto END
)

:NO_VERSION
echo nothing found assuming inital db
docker exec %name% psql -d postgresql://postgres:onetask@graphql-postgres:5432 -c "DROP TABLE alembic_version" -qtAX	
goto END


:setVersion
Set "version=%~1"

FOR /F "tokens=*" %%g IN ('docker exec %name% psql -d postgresql://postgres:onetask@graphql-postgres:5432 -c "SELECT COUNT(*) FROM alembic_version;" -qtAX') do (SET result=%%g)
	
IF "%result%" == "0" (	
	echo setting version to %version%
	docker exec %name% psql -d postgresql://postgres:onetask@graphql-postgres:5432 -c "INSERT INTO alembic_version VALUES('%version%')" -qtAX	
	echo version is %version%
)



EXIT /B 0
