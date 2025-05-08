FROM octopusdeploy/tentacle:6.3.0

# disable docker in docker since it would require privileged mode
ENV DISABLE_DIND=Y


RUN apt-get update && \
    apt upgrade -y && \
    apt-get install -y curl git unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
WORKDIR /tmp

# Install awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install --update

# https://learn.microsoft.com/en-us/powershell/scripting/install/install-debian?view=powershell-7.4
RUN curl https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb --output packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell && \
    apt-get clean && \
    pwsh --version

# Get AZ Powershell modules
# https://learn.microsoft.com/en-us/powershell/azure/install-az-ps
RUN pwsh -c 'Install-Module -Name Az -Repository PSGallery -Force -Scope AllUsers -MinimumVersion 11.0.0' && \
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
