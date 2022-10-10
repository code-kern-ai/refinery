@echo off

docker run -d --rm --name alfred^
-v /var/run/docker.sock:/var/run/docker.sock^
-v %cd%\refinery:/refinery kernai/alfred:v1.3.4^
python start.py %cd%\refinery > nul

docker logs -f alfred

