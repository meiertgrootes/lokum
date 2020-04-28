#!/bin/bash

curDate=$(date +%d%m%Y)

docker build --file Dockerfile2 --network=host -t nlesc/mlokum:${curDate} -t nlesc/mlokum:latest .
#docker push nlesc/lokum:$curDate
