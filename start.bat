@echo off

:: path of the working directory with slashes instead of backslashes
:: removes the colon, and prepends a slash
set "PWD=%cd%"
set "PWD=%PWD:\=/%"
set "PWD=%PWD::=%"
set "PWD=/%PWD%"

docker pull kernai/alfred:v1.3.4

docker run -d --rm ^
--name alfred ^
-v /var/run/docker.sock:/var/run/docker.sock ^
-v %PWD%/refinery:/refinery kernai/alfred:v1.3.4 ^
python start.py %PWD%/refinery windows > nul

docker logs -f alfred

