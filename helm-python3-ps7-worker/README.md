# helm-python3-ps7-az-linux

Based on the DSO Octopus Worker Base image, adding required toolset

- helm 3 (default)
- kubectl

To use the new automatic de-registration of worker on shutdown add a **PreStop** command handler in the **Lifecycle Hooks** part in the **Container** definition of the **Deploy Kubernetes Containers** process step:

```
/scripts/deregister-tentacle.sh
```

PreStop handler: see https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/

## Build and Deploy

Use the Workflow in Git Actions to have the image build and pushed to JFrog.  
When starting a Build the version of the Base Image, Kubectl and Helm can be specified.

## Testing

### Build locally

```
docker build [--platform linux/x86_64] --build-arg BASEIMAGE_VERSION=<version> [--build-arg Kubectl_Version=<version>] [--build-arg Helm_Version=<version>] -t <imagename> .
```

Example: build with specific version of dso base image, kubectl v1.32.2 and helm v3.17.0 for pushing to jfrog

```
docker build --platform linux/x86_64 --build-arg BASEIMAGE_VERSION=88 --build-arg Kubectl_Version=v1.32.2 --build-arg Helm_Version=v3.17.0 -t sample-artifactory.jfrog.io/dso-docker-virtual/dso-helm-python3-ps7-worker:88-v1.32.2-v3.17.0 .
```

### Run locally

Create the environment file `.env` locally and set up required variables for the worker registration (matching the ENV in the Dockerfile)

```
ACCEPT_EULA=Y
MachinePolicy=Default Machine Policy
ServerApiKey=<API-Key>
ServerPort=10943
ServerUrl=https://stg-sample-instance.octopus.app
Space=Default
TargetWorkerPool=Default Worker Pool
```

```
docker run [--platform linux/x86_64] --rm [-it] --name <containername> --env-file .env  <imagename> [command]
```

Specifying a command to execute will skip the worker registration script that otherwise runs by default

Example: start a container into bash shell

```
docker run --platform linux/x86_64 --rm -it --name dso-worker --env-file .env sample-artifactory.jfrog.io/dso-docker-virtual/dso-helm-python3-ps7-worker:88-v1.32.2-v3.17.0 bash
```

### De-registering from within the container:

If the image was started without command or the tentacle scripts were run you can de-register the worker again:

```
tentacle deregister-worker --server=https://stg-sample-instance.octopus.app --apiKey=$ServerApiKey
```

## Build Info

### Additional tools

The base worker image is enhanced with tools for the common deployment tasks. The vendor Dockerfile for the worker-tools https://github.com/OctopusDeploy/WorkerTools/blob/master/ubuntu.18.04/Dockerfile is partly merged into our Docker file to install:

#### **Kubectl**

The version of kubectl to include needs to be specified in the workflow and it becomes part of the image tag

#### **Helm 3**

Helm 3 is installed as the default version.

#### **Powershell 7**

Basic part of the worker so powershell scripts can be run.

#### **SMP Kong specific**

For the typical SMP deployments with Kong registration Python3 + pip is added 