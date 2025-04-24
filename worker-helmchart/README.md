TODO: evaluate vendor provided helm chart once released, see https://github.com/OctopusDeploy/helm-charts

TODO: using Octopus Structured Variable replacement would avoid the additional values file with the placeholders. Unfortunately, as of April 2023, Structured Variables are not yet supported for the helm chart step template, check https://octopus.com/docs/projects/steps/configuration-features/structured-configuration-variables-feature


# Content

Helm chart to use in a Runbook for Worker deployment in Octopus

# Usage

In an octopus Runbook, reference the JFrog Repo as a helm feed and select the ```dso-octopus-worker``` helmchart. 

As Template Values, use ```Files in Chart Package``` and give the file name ```values-octopus-variables.yaml```

## values-octopus-variables.yaml

This is a values file prepared to be used in Octopus. It contains ```#{Placeholders}``` instead of actual values that will get filled with **Variables** defined in the Runbook project.

## Test locally
```
helm template --name-template=dso-octopus-worker .\dso-octopus-worker\ -f .\dso-octopus-worker\values[-octopus-variables].yaml --output-dir rendered
```

## Build

Workflow ```build-helmchart``` will push new version of the helm chart to dso-ci-helm repo on JFrog
