# on top of the base image we 
# - add the required tools (helm, kubectl) to the image
# - add the more packages for SMP Kong script (python3, pip) to the image
# - add Powershell and Az module

ARG BASEIMAGE_VERSION=latest
FROM sample-artifactory.jfrog.io/dso-docker-virtual/dso-worker-base:${BASEIMAGE_VERSION}
#test locally on mac using below image
#FROM --platform=linux/amd64 ubuntu:20.04

ARG cf_Version=8.13.0

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# Download and extract the Cloud Foundry CLI package
# list of releases https://github.com/cloudfoundry/cli/releases
RUN wget -O /tmp/cf.tgz "https://packages.cloudfoundry.org/stable?release=linux64-binary&version=${cf_Version}" && \
    tar -xzf /tmp/cf.tgz -C /tmp && \
    mv /tmp/* /usr/local/bin/ 
#   rm /usr/local/bin/cf.tgz

WORKDIR /

# We know this won't reduce the image size at all. It's just to make the filesystem a little tidier.
RUN rm -rf /tmp/*

VOLUME /var/lib/docker

#Run Container as Octopus user
USER Octopus

#Need to add SAP BTP multiapps PLUGIN to CF CLI for making sure the deploy works
RUN cf install-plugin multiapps -f
