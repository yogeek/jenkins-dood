#!/bin/sh

# For jenkins to be able to use docker commands inside the container, 'jenkins'
# user must be in the group having the id of the docker group...of the host !
# But the docker group does not exist inside the container !
# So we pass the host docker group id in a environment variable
# in order to put jenkins in the docker group dynamically (at run)
# For that, we use "--group-add" docker run option to add the corresponding group

# Search for docker group GID
if [[ $(command -v getent >/dev/null 2>&1) ]]
then
  DOCKER_GID=$(getent group docker | cut -d: -f3)
else
  # getent not installed => /etc/group and awk instead
  DOCKER_GID=$(cat /etc/group | grep docker: | awk -F\: '{print $3}')
fi

docker run --rm -it \
    -e DOCKER_GID=${DOCKER_GID} \
    --group-add ${DOCKER_GID} \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v $(which docker):/usr/bin/docker \
		-v jenkins-data:/var/jenkins_home  \
		-p 8080:8080 \
    -p 50000:50000 \
		yogeek/jenkins-dood
