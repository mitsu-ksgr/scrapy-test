#!/bin/sh

readonly DOCKER_IMG='python-scrapy-test:latest'

docker build -t ${DOCKER_IMG} .

# ./run.sh st ProjectName
if [ $# -eq 2 ]; then
    if [ "$1" = 'st' ]; then
        docker run --rm \
            -v "$(pwd)/src":/out \
            -t ${DOCKER_IMG} \
            -s "$2"

        sudo chown -R $USER:$USER ./src/$2
        exit 0
    fi
fi

# ./run.sh
docker run --rm \
    -v "$(pwd)/out":/out \
    -t ${DOCKER_IMG} \
    $@

