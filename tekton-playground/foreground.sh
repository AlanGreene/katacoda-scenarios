#!/bin/bash

echo "Waiting for setup to complete"; while [ ! -f /opt/.backgroundfinished ] ; do sleep 2; done; echo "Done"

kubectl get pods -n tekton-pipelines
