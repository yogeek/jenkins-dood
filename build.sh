#!/bin/sh

if [ -z "${1}" ]; then
   version="latest"
else
   version="${1}"
fi

IMAGE="yogeek/jenkins-dood:${version}"

echo "Building ${IMAGE} image..."
docker build -t ${IMAGE} .
