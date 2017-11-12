#!/bin/sh

if [ -z "${1}" ]; then
   version="latest"
else
   version="${1}"
fi

IMAGE="yogeek/jenkins-dood:${version}"

# REGISTRY will take the value of $2 suffixed by "/" if $2 is set, empty otherwise
REGISTRY=$([[ -z $2 ]] && echo "" || echo "$2/")

echo "Pushing ${REGISTRY}${IMAGE} image..."
docker push ${REGISTRY}${IMAGE}
