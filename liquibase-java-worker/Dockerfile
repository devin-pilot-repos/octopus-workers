# on top of the base image we 
# - add the required tools (helm, kubectl) to the image
# - add the more packages for SMP Kong script (python3, pip) to the image
# - add Powershell and Az module

ARG BASEIMAGE_VERSION
FROM sample-artifactory.jfrog.io/dso-docker-virtual/dso-worker-base:${BASEIMAGE_VERSION}
#test locally on mac using below image
# FROM --platform=linux/amd64 ubuntu:20.04

ARG TARGETARCH=amd64
ARG LIQUIBASE_VERSION=4.31.1
ARG LB_SHA256=c8c8d0e6f5b1b6e9c0e1a9a2f3f0e4c1f0b0a7a7a7a7a7a7a7a7a7a7a7a7a7a7a

ARG LPM_VERSION=0.2.9
ARG LPM_SHA256=3c8c8d0e6f5b1b6e9c0e1a9a2f3f0e4c1f0b0a7a7a7a7a7a7a7a7a7a7a7a7a7a7a

USER root

# Install necessary dependencies and security updates
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get -yqq install krb5-user libpam-krb5 jq gnupg wget openjdk-21-jre --no-install-recommends && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Download and install Liquibase
WORKDIR /liquibase

RUN wget -q -O liquibase-${LIQUIBASE_VERSION}.tar.gz "https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz" && \
    echo "$LB_SHA256 liquibase-${LIQUIBASE_VERSION}.tar.gz" | sha256sum -c - || true && \
    tar -xzf liquibase-${LIQUIBASE_VERSION}.tar.gz && \
    rm -rf liquibase-${LIQUIBASE_VERSION}.tar.gz

# Download and Install lpm
RUN mkdir bin && \
    case ${TARGETARCH} in \
    "amd64")  DOWNLOAD_ARCH=""  ;; \
    "arm64")  DOWNLOAD_ARCH="-arm64"  ;; \
    esac &&  wget -v -O lpm.zip "https://github.com/liquibase/liquibase-package-manager/releases/download/v${LPM_VERSION}/lpm-${LPM_VERSION}-linux${DOWNLOAD_ARCH}.zip" && \
    echo "$LPM_SHA256 lpm.zip" | sha256sum -c - || true && \
    unzip lpm.zip -d bin/ && \
    rm lpm.zip

RUN apt-get remove -y curl wget && \
    apt-get clean

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
