#!/bin/sh

# For jenkins to be able to use docker commands inside the container, 'jenkins'
# user must be in the group having the id of the docker group...of the host !
# But the docker group does not exist inside the container !
# So we pass the host docker group id in a environment variable
# in order to put jenkins in the docker group dynamically (at run)
# and not statically (in Dockerfile)
DOCKER_GID=$(getent group docker | cut -d: -f3)
# awk solution
# awk -F\: '{print "Group " $1 " with GID=" $3}' /etc/group | grep docker

docker run --rm -it \
    -e DOCKER_GID=${DOCKER_GID}
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v $(which docker):/usr/bin/docker \
		-v jenkins-data:/var/jenkins_home  \
    # http://container-solutions.com/continuous-delivery-with-docker-on-mesos-in-less-than-a-minute/
		#-v $(pwd):/var/jenkins_data \
		-p 8080:8080 \
    -p 50000:50000 \
		yogeek/jenkins-dood
