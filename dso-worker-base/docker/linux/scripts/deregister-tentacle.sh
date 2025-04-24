#!/bin/bash
# use the uppercase env var if available
if [[ ! -z "$SERVERAPIKEY" ]]; then
    ServerApiKey=$SERVERAPIKEY
fi

# de-register the worker based on the ENV that is set during pod creation
if [[ ! -z "$ServerUrl" ]]; then
    echo "De-Register this tentacle from server: $ServerUrl"
    tentacle deregister-worker --server=$ServerUrl --apiKey=$ServerApiKey --space=$Space
fi
