# on top of the base image we 
# - add the required tools (helm, kubectl) to the image
# - add the more packages for SMP Kong script (python3, pip) to the image
# - add Powershell and Az module

ARG BASEIMAGE_VERSION=latest
FROM sample-artifactory.jfrog.io/dso-docker-virtual/dso-worker-base:${BASEIMAGE_VERSION}
#test locally on mac using below image
# FROM --platform=linux/amd64 ubuntu:20.04

ARG TARGETARCH=amd64
ARG LIQUIBASE_VERSION=4.31.1
ARG LB_SHA256=0555808b59941d497f0c1114c3f2225698afde11c60d191c88e449506a60a3ea

ARG LPM_VERSION=0.2.9
ARG LPM_SHA256=b9caecd34c98a6c19a2bc582e8064aff5251c5f1adbcd100d3403c5eceb5373a

USER root

# Install necessary dependencies
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get -yqq install krb5-user libpam-krb5 jq gnupg openjdk-17-jre --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Download and install Liquibase
WORKDIR /liquibase

RUN curl -s -L -o liquibase-${LIQUIBASE_VERSION}.tar.gz "https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz" && \
    echo "$LB_SHA256 liquibase-${LIQUIBASE_VERSION}.tar.gz" | sha256sum -c - && \
    tar -xzf liquibase-${LIQUIBASE_VERSION}.tar.gz && \
    rm -rf liquibase-${LIQUIBASE_VERSION}.tar.gz

# Download and Install lpm
RUN mkdir bin && \
    case ${TARGETARCH} in \
    "amd64")  DOWNLOAD_ARCH=""  ;; \
    "arm64")  DOWNLOAD_ARCH="-arm64"  ;; \
    esac &&  curl -L -o lpm.zip "https://github.com/liquibase/liquibase-package-manager/releases/download/v${LPM_VERSION}/lpm-${LPM_VERSION}-linux${DOWNLOAD_ARCH}.zip" && \
    echo "$LPM_SHA256 lpm.zip" | sha256sum -c - && \
    unzip lpm.zip -d bin/ && \
    rm lpm.zip

RUN apt-get clean

# Setup symbolic links
RUN ln -s /liquibase/liquibase /usr/local/bin/liquibase && \
    ln -s /liquibase/bin/lpm /usr/local/bin/lpm

ENV LIQUIBASE_HOME=/liquibase

# Install Drivers
RUN lpm update && \
    lpm add mysql --global && \
    /liquibase/liquibase --version

#Run Container as Octopus user
USER Octopus
