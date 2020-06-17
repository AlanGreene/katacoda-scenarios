#### Try it out

Check versions:
`tkn version`{{execute}}

Try out some of the [examples](https://github.com/tektoncd/pipeline/tree/master/examples) from the Tekton Pipeline repo.

For example:
`kubectl apply -f https://raw.githubusercontent.com/tektoncd/pipeline/master/examples/v1beta1/pipelineruns/output-pipelinerun.yaml`{{execute}}

You can track the progress of the `PipelineRuns` using:

`kubectl get pipelineruns`{{execute}}

`tkn pipelinerun list`{{execute}}

or check out the Tekton Dashboard at https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/
