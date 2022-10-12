@echo off

docker pull kernai/alfred:v1.3.5

docker run -d --rm ^
--name alfred ^
-v /var/run/docker.sock:/var/run/docker.sock ^
-v %cd%\refinery:/refinery kernai/alfred:v1.3.5 ^
python start.py %cd%\refinery windows > nul

docker logs -f alfred

