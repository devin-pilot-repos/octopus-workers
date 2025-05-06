# on top of the base image we 
# - add the required tools (helm, kubectl) to the image
# - add the more packages for SMP Kong script (python3, pip) to the image
# - add Powershell and Az module

ARG BASEIMAGE_VERSION=latest
FROM sample-artifactory.jfrog.io/dso-docker-virtual/dso-worker-base:latest

# specify the versions of tools to install, override via --build-arg
ARG Kubectl_Version=v1.32.3
ARG Helm_Version=v3.17.1
ARG SOPS_VERSION=v3.9.3

USER root

WORKDIR /tmp

# download and install kubectl
RUN curl -LO "https://dl.k8s.io/release/${Kubectl_Version}/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    kubectl version --client

# download and install helm3
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3  && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh --version ${Helm_Version} 
RUN helm version

# apt-get install -y dos2unix jq python3-pip python3-openssl software-properties-common && \

# add dependencies to build specific python version
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y dos2unix jq python3-pip software-properties-common && \
    apt-get install -y libbz2-dev libncurses5-dev libffi-dev libsqlite3-dev liblzma-dev libreadline-dev libssl-dev && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# install sops for new kong gateway scripting
RUN curl -LO https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64 && \
    mv sops-${SOPS_VERSION}.linux.amd64 /usr/local/bin/sops && \
    chmod +x /usr/local/bin/sops && \
    sops -v

WORKDIR /

# We know this won't reduce the image size at all. It's just to make the filesystem a little tidier.
RUN rm -rf /tmp/*

#Run Container as Octopus user
USER Octopus

# Install old python and related as per SMP EC2 setup
RUN pip install --upgrade pip && \
    pip install cryptography==43.0.1 setuptools==75.1.0 wheel==0.44.0

## Installing pyenv and setting global as python v3.12
## Note: To use python installed with pyenv; need to `source ~.profile` in octopus step template

RUN curl https://pyenv.run | bash

RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile && \
    echo 'eval "$(pyenv init -)"' >> ~/.profile 
#RUN cat ~/.profile
# RUN . ~/.profile  # does not work with plain sh shell, need to run the commands below
RUN export PYENV_ROOT="$HOME/.pyenv" && \
    export PATH="$PYENV_ROOT/bin:$PATH" && \
    eval "$(pyenv init -)" && \
    pyenv install 3.12 && \
    pyenv global 3.12        
