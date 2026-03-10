# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/container-service/managed-cluster/CHANGELOG.md).

## 0.12.0

### Changes

- Updated ARM API versions to `2025-09-01` in the main module and child modules.
- Added new parameters `advancedNetworking`, `aiToolchainOperatorProfile`, `bootstrapProfile`, `fqdnSubdomain`, `ipFamilies`, `natGatewayProfile`, `networkMode`,`nodeProvisioningProfile`, `podCidrs`, `serviceCidrs`, `staticEgressGatewayProfile` and `windowsProfile` following the API specification.
- `agent-pool` child module: Added new parameters, following the API specification: `capacityReservationGroupResourceId`, `gatewayProfile`, `gpuInstanceProfile`, `gpuProfile`, `hostGroupId`, `kubeletConfig`, `localDNSProfile`, `messageOfTheDay`, `networkProfile`, `podIPAllocationMode`, `powerState` and `virtualMachinesProfile`.
- `agent-pool` child module: Added new allowed values to `osSku` parameter: `AzureLinux3`, `Ubuntu2204`, `Ubuntu2404`, `Windows2025`.
- `maintenance-configuration` child module: Added new parameters `notAllowedTime` and `timeInWeek` for blackout windows and weekly maintenance schedules.

### Breaking Changes

- API version updates may introduce new required parameters or behavior changes in the underlying Azure Resource Manager API
- Replaced individual parameters with API-typed parameters: `aadProfile`, `aksServicePrincipalProfile`, `backendPoolType`, `defaultIngressControllerType`, `httpProxyConfig`, `identityProfile`, `loadBalancerSku`, `networkDataplane`, `networkPlugin`, `networkPolicy`, `nodeProvisioningProfileMode`, `nodeResourceGroupProfile`, `outboundType`, `skuName`, `skuTier`, `supportPlan` and `tags`.
- Removed individual `adminUsername` and `sshPublicKey` parameters in favor of `linuxProfile`, which now includes these settings.
- Removed individual API server access parameters `authorizedIPRanges`, `disableRunCommand`, `enablePrivateCluster`, `enablePrivateClusterPublicFQDN`, `privateDNSZone` in favor of `apiServerAccessProfile`, which now includes these settings.
- Removed individual autoscaler parameters `autoScalerProfileScanInterval`, `autoScalerProfileScaleDownDelayAfterAdd`, `autoScalerProfileScaleDownDelayAfterDelete`, `autoScalerProfileScaleDownDelayAfterFailure`, `autoScalerProfileScaleDownUnneededTime`, `autoScalerProfileScaleDownUnreadyTime`, `autoScalerProfileUtilizationThreshold`, `autoScalerProfileMaxGracefulTerminationSec`, `autoScalerProfileBalanceSimilarNodeGroups`, `autoScalerProfileDaemonsetEvictionForEmptyNodes`, `autoScalerProfileDaemonsetEvictionForOccupiedNodes`, `autoScalerProfileIgnoreDaemonsetsUtilization`, `autoScalerProfileExpander`, `autoScalerProfileMaxEmptyBulkDelete`, `autoScalerProfileMaxNodeProvisionTime`, `autoScalerProfileMaxTotalUnreadyPercentage`, `autoScalerProfileNewPodScaleUpDelay`, `autoScalerProfileOkTotalUnreadyCount`, `autoScalerProfileSkipNodesWithLocalStorage`, `autoScalerProfileSkipNodesWithSystemPods` in favor of `autoScalerProfile`, which now includes these settings.
- Removed individual auto upgrade parameters `autoUpgradeProfileUpgradeChannel` and `autoNodeOsUpgradeProfileUpgradeChannel` in favor of `autoUpgradeProfile`, which now includes these settings.
- Removed individual pod identity parameters `podIdentityProfileAllowNetworkPluginKubenet`, `podIdentityProfileEnable`, `podIdentityProfileUserAssignedIdentities` and `podIdentityProfileUserAssignedIdentityExceptions` in favor of `podIdentityProfile`, which now includes these settings.
- Removed individual security parameters `enableWorkloadIdentity`, `enableAzureDefender`, `securityGatingConfig`, `enableImageCleaner`, `enableImageIntegrity`, `enableNodeRestriction` and `imageCleanerIntervalHours` in favor of `securityProfile`, which now includes these settings. Please note that some security settings have been removed in the API version 2025-09-01.
- Removed parameters `kedaAddon` and `vpaAddon`, now they're part of `workloadAutoScalerProfile`.
- Removed individual Azure Monitor parameters `appMonitoring`, `enableContainerInsights`, `disableCustomMetrics`, `disablePrometheusMetricsScraping`, `syslogPort` as the properties wre removed from the `azureMonitorProfile` in the api version `2025-09-01`.
- Removed individual Azure Monitor parameters `enableAzureMonitorProfileMetrics`, `metricLabelsAllowlist` and `metricAnnotationsAllowList` in favor of `azureMonitorProfile`.
- Removed Istio-specific parameters `istioServiceMeshEnabled`, `istioServiceMeshRevisions`, `istioServiceMeshInternalIngressGatewayEnabled` and `istioServiceMeshCertificateAuthority` in favor of generic `serviceMeshProfile`
- `agent-pool` child module: Updated parameters `gpuInstanceProfile`, `kubeletDiskType`, `linuxOSConfig`, `mode`, `osDiskType`, `osType`, `scaleDownMode`, `scaleSetEvictionPolicy`, `scaleSetPriority`, `tags`, `workloadRuntime` and `windowsProfile` to use  resource input types from `Microsoft.ContainerService/managedClusters/agentPools@2025-09-01` for consistency with the RP schema and built-in validation.
- `agent-pool` child module: Updated parameters `nodeLabels`, `nodeTaints` to use strong types.
- `agent-pool` child module: Removed parameter `maxSurge`, now it's part of `upgradeSettings`.
- `agent-pool` child module: Removed parameters `enableSecureBoot`, `enableVTPM` and `sshAccess`, now they're part of `securityProfile`.
- `maintenance-configuration` child module: Updated `maintenanceWindow` parameter to use strong types from `Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2025-09-01`.
- Changed `fluxExtension.configurations` to `fluxExtension.fluxConfigurations` for consistency
- SKU tier value changed from lowercase `'free'` to `'Free'` (capital F) to match API specification

## 0.11.1

### Changes

- Update `discEncryptionSetResourceId` parameter description

### Breaking Changes

- None

## 0.11.0

### Changes

- Updated ARM API versions:
  - Updated `Microsoft.ContainerService/managedClusters` from previous version to `2025-05-02-preview`
  - Updated `Microsoft.ContainerService/managedClusters/agentPools` to `2025-05-02-preview`
  - Updated `Microsoft.ContainerService/managedClusters/maintenanceConfigurations` to `2025-05-01`
- Updated some parameter types to reference newer API versions for better type safety
- Updated resource templates and JSON output to use the latest API versions
- Adding Linux and Windows profile config to `Microsoft.ContainerService/managedClusters/agentPools`

### Breaking Changes

- API version updates may introduce new required parameters or behavior changes in the underlying Azure Resource Manager API
- Some parameter schemas may have changed due to the updated API versions

## 0.10.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added types to `tags`, `httpProxyConfig` & `identityProfile` parameters
- Updated version of referenced `avm/res/kubernetes-configuration/extension` module to `0.3.6` and adding a pass-thru of the `targetNamespace` parameter

### Breaking Changes

- None

## 0.10.0

### Changes

- Adding load balancer configuration options
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.9.0

### Changes

- Initial version

### Breaking Changes

- None
