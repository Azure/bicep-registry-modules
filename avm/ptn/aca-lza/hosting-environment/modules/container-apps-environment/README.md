# Deploy the Azure Container Apps Environment

With your spoke virtual network in place and the services that Azure Containers Apps needs in this architecture in place, you're ready to deploy the application platform.

## Expected results

The application platform, Azure Containers Apps, and its logging sinks within Azure Monitor will now be deployed. The workload is not deployed as part of step. Non-mission critical workload lifecycles are usually not tied to the lifecycle of the application platform, and as such are deployed isolated from infrastructure deployments, such as this one. Some cross-cutting concerns and platform feature enablement is usually handled however at this stage.

![A picture of the resources of this architecture, now with the application platform.](./media/container-apps-environment.png)

### Resources

- Container Apps Environment Environment
- Log Analytics Workspace
- Application Insights (optional)
- Dapr Telemetry with Application Insights (optional)
- Private DNS Zone for Container Apps Environment

## Steps

1. Create the Azure Container Apps application platform resources.

   ```bash
   RESOURCEID_VNET_HUB=$(az deployment sub show -n acalza01-hub --query properties.outputs.hubVNetId.value -o tsv)
   RESOURCENAME_RESOURCEGROUP_SPOKE=$(az deployment sub show -n acalza01-spokenetwork --query properties.outputs.spokeResourceGroupName.value -o tsv)
   RESOURCENAME_VNET_SPOKE=$(az deployment sub show -n acalza01-spokenetwork --query properties.outputs.spokeVNetName.value -o tsv)
   LOG_ANALYTICS_WS_ID=$(az deployment sub show -n acalza01-spokenetwork --query properties.outputs.logAnalyticsWorkspaceId.value -o tsv)

   echo RESOURCEID_VNET_HUB: $RESOURCEID_VNET_HUB && \
   echo RESOURCENAME_RESOURCEGROUP_SPOKE: $RESOURCENAME_RESOURCEGROUP_SPOKE && \
   echo RESOURCENAME_VNET_SPOKE: $RESOURCENAME_VNET_SPOKE && \
   echo LOG_ANALYTICS_WS_ID: $LOG_ANALYTICS_WS_ID

   # [This takes about 11 minutes to run.]
   az deployment group create \
      -n acalza01-appplat \
      -g $RESOURCENAME_RESOURCEGROUP_SPOKE \
      -f 04-container-apps-environment/deploy.aca-environment.bicep \
      -p 04-container-apps-environment/deploy.aca-environment.parameters.jsonc \
      -p hubVNetId=${RESOURCEID_VNET_HUB} spokeVNetName=${RESOURCENAME_VNET_SPOKE} enableApplicationInsights=true enableDaprInstrumentation=true \
      -p logAnalyticsWorkspaceId=${LOG_ANALYTICS_WS_ID}
   ```

1. Explore your final infrastructure. *Optional.*

   Now would be a good time to familiarize yourself with all core resources that are part of this architecture, as they are all deployed. This includes the networking layer, the application platform, and all supporting resources. It does not include any of the resources that are specific to a workload (such as public Internet ingress through an application gateway). Check out the following resource groups in the [Azure portal](https://portal.azure.com).

   ```bash
   RESOURCENAME_RESOURCEGROUP_HUB=$(az deployment sub show -n acalza01-hub --query properties.outputs.resourceGroupName.value -o tsv)

   echo Hub Resource Group: $RESOURCENAME_RESOURCEGROUP_HUB && \
   echo Spoke Resource Group: $RESOURCENAME_RESOURCEGROUP_SPOKE
   ```

## Next step

:arrow_forward: [Deploy a sample application](../05-hello-world-sample-app/README.md)
