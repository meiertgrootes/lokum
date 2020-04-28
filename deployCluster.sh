#!/usr/bin/env bash

docker run --rm --net=host -it \
  -v $(pwd)/config:/lokum/config \
  -v $(pwd)/deployment:/lokum/deployment \
  nlesc/eecolokum:latest
