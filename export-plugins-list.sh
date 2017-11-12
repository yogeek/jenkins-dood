#!/bin/sh

USER=root
PASSWORD=xxxx
JENKINS_IP=192.168.99.100
JENKINS_PORT=8080

JENKINS_HOST=${SUER}:${PASSWORD}@http://${JENKINS_IP}:${JENKINS_PORT}

curl -sSL "http://${JENKINS_HOST}/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" | pe
rl -pe 's/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1 \2\n/g'|sed 's/ /:/'  > plugins.txt
