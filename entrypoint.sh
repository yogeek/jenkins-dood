#!/bin/sh

# This entrypoint aims to dynamically add jenkins to a group which allows it
# to use the docker binary of the host inside the container
# (because we mount the docker binary and socket as volume in docker run)

# Host docker group id has been passed in a environment variable by docker run
if [ -z "${DOCKER_GID}" ]
then
    echo "
USAGE:
  This image must be run passing by the DOCKER_GID in environment variable
  in order to be able to use the docker binary of the host

  docker run -e DOCKER_GID=$(getent group docker | cut -d: -f3) ...
"
    exit 1
# 'jenkins' user must be in a group which gid is $DOCKER_GID
else
  # Is a group with gid=DOCKER_GID already exists ?
  # (normally yes, 'users' group in the officiel jenkins image)
  dockergroup=$(getent group $DOCKER_GID | cut -d: -f1)
  # If such a group does not exist, we create a brand new docker group with the good gid
  if [ -z ${dockergroup} ]
  then
    echo "No group with ${DOCKER_GID} gid : we create docker group with this id"
    sudo groupadd -g ${DOCKER_GID} docker
  # If such a group already exist, it will serve as the 'docker' group inside the container
  # (in linux permission management, only id and gid matters, not names)
  else
    echo "A group already exists with ${DOCKER_GID} gid (${dockergroup}) : we take this group as docker group"
  fi
  # Add jenkins user to docker group
  sudo gpasswd -a jenkins ${dockergroup}
  # Hack to reload group assignments without logging out
  # https://superuser.com/a/609141
  exec sudo su -l jenkins
fi

# We want to keep the original behaviour of the image
# https://github.com/jenkinsci/docker/blob/master/Dockerfile
# Original entrypoint of jenkins base image is :
# ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
# So we launch the same commands passing by the arguments
/bin/tini -- /usr/local/bin/jenkins.sh "$@"
