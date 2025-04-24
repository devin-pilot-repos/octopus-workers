# Octopus Worker image BASE

To use the new automatic de-registration of worker on shutdown add a **PreStop** command handler in the **Lifecycle Hooks** part in the **Container** definition of the **Deploy Kubernetes Containers** process step:

```
/scripts/deregister-tentacle.sh
```

PreStop handler: see https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/

## Build and Deploy

Use the Workflow in Git Actions to have the image build and pushed to JFrog.

## Testing

### Build locally

```
docker build [--platform linux/x86_64] [--build-arg Tentacle_Version=<version>] -t <imagename> .
```

Example: build with specific version of tentacle, for pushing to jfrog

```
docker build --platform linux/x86_64 --build-arg Tentacle_Version=8.1.2007 -t sample-artifactory.jfrog.io/dso-docker-virtual/dso-worker-base:8.1.2007 .
```

### Run locally

Create the environment file `.env` locally and set up required variables for the worker registration (matching the ENV in the Dockerfile)

```
ACCEPT_EULA=Y
MachinePolicy=WorkerPodCleanup
ServerApiKey=<API-Key>
ServerPort=10943
ServerUrl=https://stg-sample-instance.octopus.app
Space=Default
TargetWorkerPool=DSO Tooling UBUNTU HELM-3-8-2
```

```
docker run [--platform linux/x86_64] --rm [-it] --name <containername> --env-file .env  <imagename> [command]
```

Specifying a command to execute will skip the worker registration script that otherwise runs by default

Example: start a container into bash shell

```
docker run --platform linux/x86_64 --rm -it --name dso-worker --env-file .env sample-artifactory.jfrog.io/dso-docker-virtual/dso-worker-base:8.1.2007 bash
```

### De-registering from within the container:

If the image was started without command or the tentacle scripts were run you can de-register the worker again:

```
tentacle deregister-worker --server=https://stg-sample-instance.octopus.app --apiKey=$ServerApiKey
```

## Build Info

### Worker image (tentacle)

The image is based on the Octopus Vendor worker Dockerfile https://github.com/OctopusDeploy/OctopusTentacle/blob/main/docker/linux/Dockerfile

The files in ./docker/linux/script are from the same repository.  
Then the configure-tentacle.sh was **replaced** with the same file pulled from https://hub.docker.com/r/octopuslabs/tentacle-multiserverpolling. This version of the configure script handles worker registration against **multiple** server nodes.

The version of the tentacle to install needs to be specified in the workflow and it becomes part of the image tag
