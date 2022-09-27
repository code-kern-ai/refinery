echo migrating db...

FOR /F "tokens=*" %%g IN ('"docker ps -q -f name=refinery_graphql-postgres_1"') do (SET container=%%g)
if [%container%]==[] (
    :UPPER_RECHECK
    docker exec refinery_graphql-postgres_1 pg_isready
    IF %ERRORLEVEL% NEQ 0 ( 
    timeout 1
        goto UPPER_RECHECK
    )
    docker run --rm ^
    --name refinery-gateway-migration ^
    -e POSTGRES=postgresql://postgres:onetask@graphql-postgres:5432 ^
    --network refinery_default ^
    --entrypoint /usr/local/bin/alembic ^
    kernai/refinery-gateway upgrade head
)

FOR /F "tokens=*" %%g IN ('"docker ps -q -f name=refinery-graphql-postgres-1"') do (SET containerx=%%g)
if [%containerx%]==[] (
    :RECHECK
    docker exec refinery-graphql-postgres-1 pg_isready
    IF %ERRORLEVEL% NEQ 0 ( 
    timeout 1
        goto RECHECK
    )
    docker run --rm ^
    --name refinery-gateway-migration ^
    -e POSTGRES=postgresql://postgres:onetask@graphql-postgres:5432 ^
    --network refinery_default ^
    --entrypoint /usr/local/bin/alembic ^
    kernai/refinery-gateway upgrade head
)
echo migration done.