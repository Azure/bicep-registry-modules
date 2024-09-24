# Linux Azure DevOps Agent Docker Image for Azure Container Instances

IMPORTANT: This code is completely stolen from https://github.com/Azure/terraform-azurerm-aci-devops-agent

This image is based on the [official documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops#linux).

> Note: You can update the [Dockerfile](Dockerfile) to add any software that your require into the Azure DevOps agent, if you don't want to have to download the bits during all pipelines executions.

## Build it

```bash
docker build -t YOUR_IMAGE_NAME:YOUR_IMAGE_TAG .
```

## Push it

```bash
docker push YOUR_IMAGE_NAME:YOUR_IMAGE_TAG
```
