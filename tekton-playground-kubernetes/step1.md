#### Try it out

This is a sandbox environment with [Tekton Pipelines v0.13.1](https://github.com/tektoncd/pipeline/releases/tag/v0.13.1) and [Tekton Dashboard v0.7.0](https://github.com/tektoncd/dashboard/releases/tag/v0.7.0).

Check out some of the [examples](https://github.com/tektoncd/pipeline/tree/master/examples) from the Tekton Pipeline repo.

For example:
`kubectl apply -f https://raw.githubusercontent.com/tektoncd/pipeline/master/examples/v1beta1/pipelineruns/output-pipelinerun.yaml`{{execute}}

You can track the progress of your `TaskRuns` or `PipelineRuns` using:

`kubectl get pipelineruns`{{execute}}

`kubectl get taskruns`{{execute}}

or check out the Tekton Dashboard at http://[[HOST_SUBDOMAIN]]-9097-[[KATACODA_HOST]].environments.katacoda.com/
