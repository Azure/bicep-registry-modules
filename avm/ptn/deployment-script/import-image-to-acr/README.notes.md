
The deployment script service will need and provision a Storage Account as well as a Container Instance to execute the provided script. _The deployment script resource is available only in the regions where Azure Container Instances is available._

> The service cleans up these resources after the deployment script finishes. You incur charges for these resources until they are removed.

### Authentication to source Container Registry

Authentication is possible by setting the ```sourceRegistryUsername``` and ```sourceRegistryPassword``` parameters. An example that uses Key Vault is in the max sample. It is commented out, as for the shared environments no user exists, that could be used to access e.g. docker hub images.

### Private network access

Using a Container Registry that is not available via public network access is possible as well. In this case a subnet needs to be passed to the module. A working configuration is in the max examples for this module.

Links:

- [Access a private virtual network from a Bicep deployment script](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-vnet)
- [Run Bicep deployment script privately over a private endpoint](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-vnet-private-endpoint)

### Renaming the image

In the case an image is updated later from a pipeline, it can makes sense to initially upload a dummy image from e.g. a public registry. However, you might want to change the name and tag from that image for processes to pick up the image before **your image** has actually be published to the registry.

The pattern module [avm/ptn/app/container-job](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/authorization/policy-assignment) uses this module to create the job initially with an image that is available, which most likely will be updated later and the job will pick up the new image then.

