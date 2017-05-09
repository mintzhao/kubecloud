#!/usr/bin/env bash

build(){
    docker run --rm -v $GOPATH:/go -w /go/src/kubernetes/TOOLS/ha golang:1.8 go build -v -i -o ha
    docker build --no-cache -t docker.cloudin.com/google_containers/cluster-ha .
}

push(){
    docker push docker.cloudin.com/google_containers/cluster-ha
}

case "$1" in
    build)
        build
        ;;
    push)
        build
        push
        ;;
    *)
        echo "Usage: $0 {build|push}"
        ;;
esac