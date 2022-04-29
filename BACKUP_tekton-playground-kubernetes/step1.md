#### Try it out

This is a sandbox environment with [Tekton Pipelines v0.13.2](https://github.com/tektoncd/pipeline/releases/tag/v0.13.2) and [Tekton Dashboard v0.7.0](https://github.com/tektoncd/dashboard/releases/tag/v0.7.0) installed on a 2 node cluster.

Check out some of the [examples](https://github.com/tektoncd/pipeline/tree/master/examples) from the Tekton Pipeline repo.
`kubectl port-forward -n tekton-pipelines --address=0.0.0.0 service/tekton-dashboard 9097:9097`{{execute T1}}

For example:
`kubectl apply -f https://raw.githubusercontent.com/tektoncd/pipeline/master/examples/v1beta1/pipelineruns/output-pipelinerun.yaml`{{execute T2}}

You can track the progress of your `TaskRuns` or `PipelineRuns` using:

`kubectl get pipelineruns`{{execute T2}}

`kubectl get taskruns`{{execute T2}}

or check out the Tekton Dashboard at https://[[HOST_SUBDOMAIN]]-9097-[[KATACODA_HOST]].environments.katacoda.com/
