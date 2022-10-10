@echo off

:: docker pull kernai/alfred:latest

docker run -d --rm --name alfred^
-v /var/run/docker.sock:/var/run/docker.sock^
-v %cd%\refinery:/refinery kernai/alfred:latest^
python start.py %cd%\refinery > nul

docker logs -f alfred

