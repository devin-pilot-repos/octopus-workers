# MuleSoft Worker

The MuleSoft Worker builds on top of the base worker image ```${BASEIMAGE_VERSION}``` and adds 

- aws-cli (latest)
- anypoint-cli ```${AnyPointCLI_Version}}```  

with the prerequisite node/npm ```${Nodejs_Version}```

Additionally, python/pip is installed since the mulesoft deployments also use the apigatewayconfiguration.py 

The versions are set at the workflow run to allow for easy upgrades

## anypoint-cli-v4

Temporarily, two versions of anypoint-cli are installed: v3 locked at 3.21.7 and v4 based on the provided parameter