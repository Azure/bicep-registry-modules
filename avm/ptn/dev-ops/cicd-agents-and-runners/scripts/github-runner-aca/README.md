# Linux GitHub Runner Docker Image for Azure Container Apps

> Note: You can update the [Dockerfile](dockerfile) to add any software that your require into the GitHub Runner, if you don't want to have to download the bits during all pipelines executions.

This docker file is used as a basic image for the Azure Verified Module to run GitHub Actions in Azure Container Apps.

## Credits

The original Dockerfile and shell scripts are derived from [myoung34/docker-github-actions-runner](https://github.com/myoung34/docker-github-actions-runner).

## Environment Variables

`REPO_URL`: The URL of the repository to add the runner to.
`ORG_NAME`: The name of the organization that the repository belongs to.
`ENTERPRISE_NAME`: The name of the enterprise that the repository belongs to.
`ACCESS_TOKEN`: The token used to authenticate the runner with GitHub. This is a PAT (Personal Access Token) with the relevant scopes that requires a long expiration date.
`RUNNER_NAME_PREFIX`: The prefix for the runner name.
`RANDOM_RUNNER_SUFFIX`: Whether to add a random string to the RUNNER_NAME_PREFIX to create a unique runner name. Default is `true`.
`RUNNER_SCOPE`: The scope of the runner. Valid values are `repo`, `org` and `ent`.
`RUNNER_GROUP`: The runner group if using them.
`EPHEMERAL`: Whether the runner is ephemeral or not.

## Build it

```bash
docker build --progress=plain --no-cache -t YOUR_IMAGE_NAME:YOUR_IMAGE_TAG .
```

## Push it

```bash
docker push YOUR_IMAGE_NAME:YOUR_IMAGE_TAG
```
