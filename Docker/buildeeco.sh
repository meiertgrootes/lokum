#!/bin/bash

curDate=$(date +%d%m%Y)

docker build --file eecoDockerfile --network=host -t nlesc/eecolokum:${curDate} -t nlesc/eecolokum:latest .
#docker push nlesc/lokum:$curDate
