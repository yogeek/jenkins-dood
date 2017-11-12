# Jenkins with DooD

Jenkins Docker image allowing to use docker commands inside the container.
Useful to use docker-based plugin (docker slaves plugin, docker plugin...) inside a jenkins container.

## DooD ()"Docker-outside-of-Docker") principle

DooD (Docker-outside-of-Docker) is an alternative to DinD (Docker-in-Docker)
to use docker command inside a docker container.
DooD is simpler than DinD (you do not need to install docker inside the container) and allows you to reuse the Docker images and cache of the host.
Basically, the containers created inside a DooD container are siblings to the hosts ones.

## Usage

Simple launch :
```
./build.sh
./run.sh
```

Export a list of plugins from an existing Jenkins server :
```
# Fill export-plugins-list.sh with your jenkins credentials
./export-plugins-list.sh > plugins.txt
./build.sh
./run.sh
```
