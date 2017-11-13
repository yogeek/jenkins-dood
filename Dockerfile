FROM jenkins/jenkins:lts

USER root
# TODO the group ID for docker group on docker-machine is 100
# and to run docker commands, jenkins must have the same group id inside,
# otherwise the socket file is not accessible.
# But 100 is already the group id of a group named "users" in jenkins docker image
# So for the time being,we delete it and give the gid 100 to docker group
# before adding jenkins to it...
# RUN groupdel users && \
#     groupadd -g 100 docker && \
#     usermod -a -G docker jenkins

# Install sudo
RUN apt-get update && \
    apt-get -y install sudo && \
    apt-get clean
# Add jenkins to sudoers to be able to add it to docker group in entrypoint
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER jenkins

# Install useful plugins from file
# This kind of file can be created with "export-plugins-list.sh" script
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Diable banner to install additionnal  plugins
# https://github.com/jenkinsci/docker/blob/master/README.md
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
