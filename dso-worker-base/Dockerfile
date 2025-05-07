FROM octopusdeploy/tentacle:latest

# disable docker in docker since it would require privileged mode
ENV DISABLE_DIND=Y


RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl git unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
WORKDIR /tmp

# Install awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install --update

# https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.2#debian
RUN curl https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb --output packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell && \
    apt-get clean && \
    pwsh --version

# Get AZ Powershell modules
# https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-3.6.1
RUN pwsh -c 'Install-Module -Name Az.Keyvault -Repository PSGallery -Force -Scope AllUsers -MaximumVersion 4.9.0' && \
    pwsh -c 'Disable-AzDataCollection'

COPY docker/linux/scripts/* /scripts/
RUN chmod +x /scripts/*.sh

WORKDIR /

RUN rm -rf /tmp/*

# for argocd: we need a python3 symlink
RUN ln -s /usr/bin/python3 /usr/bin/python

# Add a user 'Octopus' with the userId that owns the tentacle files in /opt/octopus/tentacle
# while the original docker runs as root, we change it to dedicated user
RUN useradd -m -u 1001 Octopus

# prepare filesystem: the Octopus user needs to write there
RUN mkdir --mode 775 /etc/octopus && \ 
    chown Octopus /etc/octopus

# Run Container as Octopus user
USER Octopus

# trick to override base image's ENTRYPOINT and use our own start procedure via CMD
ENTRYPOINT ["/usr/bin/env"]
CMD . /scripts/setup-env.sh && /scripts/configure-tentacle.sh && /scripts/run-tentacle.sh
