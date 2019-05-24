#!/bin/bash
set -e

echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin

if [[ $TRAVIS_EVENT_TYPE == "cron" ]]; then
    DOCKER_TAG="nightly"
else
    DOCKER_TAG="latest"
fi

docker build -t sqlflow/sqlflow:$DOCKER_TAG -f ./Dockerfile .
# Test coverage note pushing images
# docker push sqlflow/sqlflow:$DOCKER_TAG

echo $COVERALLS_TOKEN

docker run --rm -it -v $GOPATH:/go sqlflow/sqlflow:$DOCKER_TAG \
bash -c "go get golang.org/x/tools/cmd/cover && go get github.com/mattn/goveralls && /go/bin/goveralls --help"
