# Deploy the long-lifecycle resources

At this point, you have a spoke virtual network ready to land your workload into. However, workloads have resources that live on different lifecycle cadences. Here you'll be deploying the resources that have a lifecycle longer than any of your application platform components.

## Expected results

Workloads often have resources that exist on different lifecycles. Some are singletons, and not tied to the deployment stamp of the application platform. Others come and go with the application platform and are part of the application's stamp. Yet others might even be tied to the deployment of code within the application platform. In this deployment, you'll be deploying resources that are not expected to be tied to the same lifecycle as the instance of the Azure Container App, and are in fact dependencies for any given instance and could be used by multiple instances if you had multiple stamps.


### Resources

- Azure Container Registry
- Azure Key Vault
- Private Link for each, including related DNS Private Zone configuration
- User managed identities for the workload

By default, they are deployed to the spoke resource group.

## Steps

1. Create the regional resources that the Azure Container Apps platform and its applications will be dependant on.

   ```bash
   RESOURCEID_VNET_HUB=$(az deployment sub show -n acalza01-hub --query properties.outputs.hubVNetId.value -o tsv)
   RESOURCENAME_RESOURCEGROUP_SPOKE=$(az deployment sub show -n acalza01-spokenetwork --query properties.outputs.spokeResourceGroupName.value -o tsv)
   RESOURCEID_VNET_SPOKE=$(az deployment sub show -n acalza01-spokenetwork --query properties.outputs.spokeVNetId.value -o tsv)
   LOG_ANALYTICS_WS_ID=$(az deployment sub show -n acalza01-spokenetwork --query properties.outputs.logAnalyticsWorkspaceId.value -o tsv)

   echo RESOURCEID_VNET_HUB: $RESOURCEID_VNET_HUB && \
   echo RESOURCENAME_RESOURCEGROUP_SPOKE: $RESOURCENAME_RESOURCEGROUP_SPOKE && \
   echo RESOURCEID_VNET_SPOKE: $RESOURCEID_VNET_SPOKE  && \
   echo LOG_ANALYTICS_WS_ID: $LOG_ANALYTICS_WS_ID

   # [This takes about four minutes to run (if you add deployRedis=false).]
   az deployment group create \
      -n acalza01-dependencies \
      -g $RESOURCENAME_RESOURCEGROUP_SPOKE \
      -f 03-supporting-services/deploy.supporting-services.bicep \
      -p 03-supporting-services/deploy.supporting-services.parameters.jsonc \
      -p hubVNetId=${RESOURCEID_VNET_HUB} spokeVNetId=${RESOURCEID_VNET_SPOKE} \
      -p logAnalyticsWorkspaceId=${LOG_ANALYTICS_WS_ID}
   ```

## Private DNS Zones

Private DNS zones in this reference implementation are deployed at the hub level. For any resource that requires a private endpoint, the workload team (as part of the deployment of the LZA), will create the appropriate private DNS Zones & records, as well as the link to the Virtual Networks that need to resolve DNS names of the private Azure resources. The workload, in the LZA implementation, is using Azure DNS for resolution. Since this reference implementation is expected to be deployed isolated from existing infrastructure, Private DNS Zones are deployed in this way (in the hub, without Azure Policies etc), in order to resemple the recommendations of the CAF/ESLZ [Private Link and DNS integration at scale](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale), without over-complicating the Azure Container Apps LZA implementation.


## Next step

:arrow_forward: [Deploy Azure Container Apps environment](../04-container-apps-environment/README.md)
