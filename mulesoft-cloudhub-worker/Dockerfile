# on top of the base image we 
# - add the required tools (helm, kubectl) to the image
# - add the more packages for SMP Kong script (python3, pip) to the image
# - add Powershell and Az module

ARG BASEIMAGE_VERSION
FROM sample-artifactory.jfrog.io/dso-docker-virtual/dso-worker-base:${BASEIMAGE_VERSION}

# specify the versions of tools to install, override via --build-arg
ARG Nodejs_Version=18.19.1
ARG AnyPointCLI_Version=latest

USER root

WORKDIR /tmp

# Install prerequisites, git is needed for anysoft-cli package
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y jq git python3-pip python3-openssl && \
    pip install --upgrade pip && \
    pip install cryptography==42.0.5 && \
    pip install setuptools==75.1.0 && \
    pip install packaging==24.1 && \
    pip install wheel==0.44.0 && \
    pip install pyopenssl==24.0.0
    
# Install Nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install anypoint-cli
RUN npm install -g anypoint-cli-v4@${AnyPointCLI_Version}

WORKDIR /

# clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# Switch back to Octopus user
USER Octopus
