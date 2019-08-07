#!/bin/sh

readonly DOCKER_IMG='python-scrapy-test:latest'

docker build -t ${DOCKER_IMG} .
docker run --rm -t ${DOCKER_IMG}

