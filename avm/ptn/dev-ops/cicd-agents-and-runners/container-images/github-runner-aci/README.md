# Linux GitHub Runner Docker Image for Azure Container Instances

> Note: You can update the [Dockerfile](Dockerfile) to add any software that your require into the Azure DevOps agent, if you don't want to have to download the bits during all pipelines executions.

## Environment Variables

`GH_RUNNER_TOKEN`: The token used to authenticate the runner with GitHub. This can be a PAT or a self-hosted runner token. If supplying a self-hosted runner token, be aware that the token will expire after a few hours, so will only work with persistent runners.
`GH_RUNNER_URL`: The URL of the GitHub repository or organization (e.g. https://github.com/my-org or https://github.com/my-org/my-repo).
`GH_RUNNER_NAME`: The name of the runner as it appears in GitHub.
`GH_RUNNER_GROUP`: Optional. If not supplied, the runner will be added to the default group. This requires Enterprise licening.
`GH_RUNNER_MODE`: Supported values are `ephemeral` and `persistent`. Default is `ephemeral` if the env var is not supplied.

## Build it

```bash
docker build -t YOUR_IMAGE_NAME:YOUR_IMAGE_TAG .
```

## Push it

```bash
docker push YOUR_IMAGE_NAME:YOUR_IMAGE_TAG
```
