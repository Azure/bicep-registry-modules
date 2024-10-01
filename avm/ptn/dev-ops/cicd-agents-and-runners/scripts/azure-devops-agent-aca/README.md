# Linux Azure DevOps Agent Docker Image for Azure Container Apps

> Note: You can update the [Dockerfile](dockerfile) to add any software that your require into the Azure DevOps Agent, if you don't want to have to download the bits during all pipelines executions.

This docker file is used as a basic image for the Azure Verified Module to run Azure DevOps Agents in Azure Container Apps.

## Credits

The original Dockerfile and shell scripts are derived from [Microsoft Learn](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops#linux).

## Environment Variables

`AZP_URL`: The URL of the Azure DevOps organization.
`AZP_TOKEN`: The token used to authenticate the runner with Azure DevOps. This is a PAT (Personal Access Token) with the relevant scopes that requires a long expiration date.
`AZP_POOL`: The name of the agent pool.
`AZP_AGENT_NAME`: The name of the agent.
`AZP_AGENT_NAME_PREFIX`: The prefix for the agent name. Overrides `AZP_AGENT_NAME`.
`AZP_RANDOM_AGENT_SUFFIX`: Whether to add a random string to the `AZP_AGENT_NAME_PREFIX` to create a unique agent name. Default is `true`.

## Build it

```bash
docker build -t YOUR_IMAGE_NAME:YOUR_IMAGE_TAG .
```

## Push it

```bash
docker push YOUR_IMAGE_NAME:YOUR_IMAGE_TAG
```
