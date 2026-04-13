metadata name = 'Azure Security Center (Defender for Cloud)'
metadata description = '''This module deploys an Azure Security Center (Defender for Cloud) Configuration.

For the associated policy assignments (e.g., Deploy-MDFC-Config), use the [ALZ Bicep Accelerator](https://aka.ms/alz/acc/bicep) or reference the [Deploy-MDFC-Config policy initiative](https://www.azadvertizer.net/azpolicyinitiativesadvertizer/Deploy-MDFC-Config_20240319.html) directly.
'''

targetScope = 'subscription'

// ============== //
//   Parameters   //
// ============== //

@description('Optional. Location deployment metadata.')
param location string = deployment().location

@description('Optional. Microsoft Defender for Cloud pricing plan configurations. Each entry specifies a Defender plan name, pricing tier, and optional subPlan, enforce, and extensions settings.')
param defenderPlans defenderPlanType[]?

@description('Optional. Security contact configuration for Microsoft Defender for Cloud notifications.')
param securityContactProperties resourceInput<'Microsoft.Security/securityContacts@2023-12-01-preview'>.properties?

@description('Optional. Device Security group properties.')
param deviceSecurityGroupProperties resourceInput<'Microsoft.Security/deviceSecurityGroups@2019-08-01'>.properties?

@description('Optional. Security Solution data for IoT.')
param ioTSecuritySolutionProperties ioTSecuritySolutionType?

@description('Optional. Continuous export (security automation) configurations. Each entry creates a Microsoft.Security/automations resource that exports alerts and/or recommendations to a Log Analytics workspace, Event Hub, or Logic App.')
param securityAutomations securityAutomationType[]?

@description('Optional. Server vulnerability assessment settings. Configures the vulnerability assessment provider (e.g., Microsoft Defender Vulnerability Management).')
param serverVulnerabilityAssessmentsSettings serverVulnerabilityAssessmentsSettingType?

@description('Optional. Custom security standards to create. Each entry defines a standard with assessments to apply.')
param securityStandards securityStandardType[]?

@description('Optional. Standard assignments to create. Each entry assigns a security standard to a scope.')
param standardAssignments standardAssignmentType[]?

@description('Optional. Custom security recommendations to create. Each entry defines a custom recommendation with a KQL query.')
param customRecommendations customRecommendationType[]?

@description('Optional. Defender for Cloud integration settings (MCAS, WDATP, Sentinel). Each entry enables or disables a specific integration.')
param securitySettings securitySettingType[]?

@description('Optional. Custom assessment metadata definitions. Used to define custom assessments that pair with custom recommendations.')
param assessmentMetadataList assessmentMetadataType[]?

@description('Optional. Alert suppression rules to reduce alert noise. Each entry creates a suppression rule for a specific alert type.')
param alertsSuppressionRules alertsSuppressionRuleType[]?

@description('Optional. Governance rules to drive security remediation. Each entry defines ownership, remediation timeframes, and notification settings.')
param governanceRules governanceRuleType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ============== //
//   Variables    //
// ============== //

var defaultDefenderPlans = [
  { name: 'VirtualMachines', pricingTier: 'Free' }
  { name: 'SqlServers', pricingTier: 'Free' }
  { name: 'AppServices', pricingTier: 'Free' }
  { name: 'StorageAccounts', pricingTier: 'Free' }
  { name: 'SqlServerVirtualMachines', pricingTier: 'Free' }
  { name: 'KeyVaults', pricingTier: 'Free' }
  { name: 'Arm', pricingTier: 'Free' }
  { name: 'OpenSourceRelationalDatabases', pricingTier: 'Free' }
  { name: 'Containers', pricingTier: 'Free' }
  { name: 'CosmosDbs', pricingTier: 'Free' }
  { name: 'CloudPosture', pricingTier: 'Free' }
  { name: 'Api', pricingTier: 'Free' }
]

var effectiveDefenderPlans = defenderPlans ?? defaultDefenderPlans

// ============== //
//   Resources    //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-07-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.ptn.security-securitycenter.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

@batchSize(1)
resource pricingTiers 'Microsoft.Security/pricings@2024-01-01' = [
  for (plan, index) in effectiveDefenderPlans: {
    name: plan.name
    properties: {
      pricingTier: plan.pricingTier
      subPlan: plan.?subPlan
      enforce: plan.?enforce
      extensions: plan.?extensions
    }
  }
]

resource deviceSecurityGroups 'Microsoft.Security/deviceSecurityGroups@2019-08-01' = if (!empty(deviceSecurityGroupProperties ?? {})) {
  name: 'deviceSecurityGroups'
  properties: deviceSecurityGroupProperties!
}

module iotSecuritySolutions 'modules/iotSecuritySolutions.bicep' = if (!empty(ioTSecuritySolutionProperties ?? {})) {
  name: '${uniqueString(deployment().name)}-ASC-IotSecuritySolutions'
  scope: resourceGroup(ioTSecuritySolutionProperties!.resourceGroup)
  params: {
    name: ioTSecuritySolutionProperties!.name
    ioTSecuritySolutionProperties: {
      workspace: ioTSecuritySolutionProperties!.workspace
      displayName: ioTSecuritySolutionProperties!.displayName
      status: ioTSecuritySolutionProperties!.?status
      export: ioTSecuritySolutionProperties!.?export
      disabledDataSources: ioTSecuritySolutionProperties!.?disabledDataSources
      iotHubs: ioTSecuritySolutionProperties!.iotHubs
      userDefinedResources: ioTSecuritySolutionProperties!.?userDefinedResources
      recommendationsConfiguration: ioTSecuritySolutionProperties!.?recommendationsConfiguration
    }
  }
}

resource securityContacts 'Microsoft.Security/securityContacts@2023-12-01-preview' = if (!empty(securityContactProperties ?? {})) {
  name: 'default'
  properties: securityContactProperties!
}

module automations 'modules/securityAutomation.bicep' = [
  for (automation, index) in (securityAutomations ?? []): {
    name: '${uniqueString(deployment().name)}-ASC-Automation-${index}'
    scope: resourceGroup(automation.resourceGroupName)
    params: {
      name: automation.name
      location: automation.?location ?? location
      tags: automation.?tags
      automationDescription: automation.?description
      isEnabled: automation.?isEnabled ?? true
      scopes: automation.scopes
      sources: automation.sources
      actions: automation.actions
    }
  }
]

resource serverVulnerabilityAssessments 'Microsoft.Security/serverVulnerabilityAssessmentsSettings@2023-05-01' = if (serverVulnerabilityAssessmentsSettings != null) {
  name: 'azureServersSetting'
  kind: 'AzureServersSetting'
  properties: {
    selectedProvider: serverVulnerabilityAssessmentsSettings!.selectedProvider
  }
}

resource securityStandardResources 'Microsoft.Security/securityStandards@2024-08-01' = [
  for (standard, index) in (securityStandards ?? []): {
    name: standard.name
    properties: {
      displayName: standard.displayName
      description: standard.?description
      assessments: standard.?assessments
      cloudProviders: standard.?cloudProviders
      policySetDefinitionId: standard.?policySetDefinitionId
    }
  }
]

resource standardAssignmentResources 'Microsoft.Security/standardAssignments@2024-08-01' = [
  for (assignment, index) in (standardAssignments ?? []): {
    name: assignment.name
    properties: {
      assignedStandard: assignment.assignedStandard
      description: assignment.?description
      displayName: assignment.?displayName
      effect: assignment.?effect
      excludedScopes: assignment.?excludedScopes
      expiresOn: assignment.?expiresOn
      metadata: assignment.?metadata
    }
  }
]

resource customRecommendationResources 'Microsoft.Security/customRecommendations@2024-08-01' = [
  for (rec, index) in (customRecommendations ?? []): {
    name: rec.name
    properties: {
      displayName: rec.displayName
      description: rec.?description
      severity: rec.severity
      securityIssue: rec.?securityIssue
      query: rec.query
      remediationDescription: rec.?remediationDescription
      cloudProviders: rec.?cloudProviders
    }
  }
]

resource securitySettingResources 'Microsoft.Security/settings@2022-05-01' = [
  for (setting, index) in (securitySettings ?? []): {
    name: setting.name
    kind: setting.kind
    properties: {
      enabled: setting.enabled
    }
  }
]

resource assessmentMetadataResources 'Microsoft.Security/assessmentMetadata@2025-05-04' = [
  for (metadata, index) in (assessmentMetadataList ?? []): {
    name: metadata.name
    properties: {
      displayName: metadata.displayName
      description: metadata.?description
      severity: metadata.severity
      assessmentType: metadata.assessmentType
      categories: metadata.?categories
      implementationEffort: metadata.?implementationEffort
      remediationDescription: metadata.?remediationDescription
      threats: metadata.?threats
      userImpact: metadata.?userImpact
    }
  }
]

#disable-next-line use-recent-api-versions // No GA version available
resource alertsSuppressionRuleResources 'Microsoft.Security/alertsSuppressionRules@2019-01-01-preview' = [
  for (rule, index) in (alertsSuppressionRules ?? []): {
    name: rule.name
    properties: {
      alertType: rule.alertType
      reason: rule.reason
      state: rule.state
      comment: rule.?comment
      expirationDateUtc: rule.?expirationDateUtc
      suppressionAlertsScope: rule.?suppressionAlertsScope
    }
  }
]

#disable-next-line use-recent-api-versions // No GA version available
resource governanceRuleResources 'Microsoft.Security/governanceRules@2022-01-01-preview' = [
  for (rule, index) in (governanceRules ?? []): {
    name: rule.name
    properties: {
      displayName: rule.displayName
      ruleType: rule.ruleType
      sourceResourceType: rule.sourceResourceType
      rulePriority: rule.rulePriority
      ownerSource: rule.ownerSource
      conditionSets: rule.conditionSets
      description: rule.?description
      isDisabled: rule.?isDisabled
      isGracePeriod: rule.?isGracePeriod
      remediationTimeframe: rule.?remediationTimeframe
      includeMemberScopes: rule.?includeMemberScopes
      excludedScopes: rule.?excludedScopes
      governanceEmailNotification: rule.?governanceEmailNotification
    }
  }
]

// ============== //
//    Outputs     //
// ============== //

@description('The name of the security center.')
output name string = 'Security'

@description('The list of Defender plan names that were configured.')
output configuredDefenderPlans array = [for (plan, index) in effectiveDefenderPlans: plan.name]

// ============== //
//  Definitions   //
// ============== //

@export()
@description('The type for a Defender plan configuration.')
type defenderPlanType = {
  @description('Required. The Defender plan name (e.g., VirtualMachines, SqlServers, AppServices, StorageAccounts, Containers, KeyVaults, Arm, CloudPosture, Api, CosmosDbs, OpenSourceRelationalDatabases, SqlServerVirtualMachines).')
  name: string

  @description('Required. The pricing tier for the Defender plan.')
  pricingTier: resourceInput<'Microsoft.Security/pricings@2024-01-01'>.properties.pricingTier

  @description('Optional. The sub-plan to select when more than one is available (e.g., P1 or P2 for VirtualMachines, DefenderForStorageV2 for StorageAccounts).')
  subPlan: resourceInput<'Microsoft.Security/pricings@2024-01-01'>.properties.subPlan?

  @description('Optional. If set to True, prevents descendants from overriding this pricing configuration. Only available for subscription-level pricing.')
  enforce: resourceInput<'Microsoft.Security/pricings@2024-01-01'>.properties.enforce?

  @description('Optional. List of extensions offered under the plan (e.g., OnUploadMalwareScanning, SensitiveDataDiscovery, AgentlessVmScanning, ContainerSensor).')
  extensions: resourceInput<'Microsoft.Security/pricings@2024-01-01'>.properties.extensions?
}

@description('The type for IoT Security Solution data.')
type ioTSecuritySolutionType = {
  @description('Required. The name of the IoT Security Solution.')
  name: string

  @description('Required. The resource group to deploy the IoT Security Solution into.')
  resourceGroup: string

  @description('Required. The workspace resource ID.')
  workspace: string

  @description('Required. The display name of the IoT Security Solution.')
  displayName: string

  @description('Optional. Status of the IoT Security Solution.')
  status: string?

  @description('Optional. List of additional export to workspace data options.')
  export: resourceInput<'Microsoft.Security/iotSecuritySolutions@2019-08-01'>.properties.export?

  @description('Optional. Disabled data sources.')
  disabledDataSources: resourceInput<'Microsoft.Security/iotSecuritySolutions@2019-08-01'>.properties.disabledDataSources?

  @description('Required. IoT Hub resource IDs.')
  iotHubs: resourceInput<'Microsoft.Security/iotSecuritySolutions@2019-08-01'>.properties.iotHubs

  @description('Optional. Properties of the IoT Security Solution\'s user defined resources.')
  userDefinedResources: resourceInput<'Microsoft.Security/iotSecuritySolutions@2019-08-01'>.properties.userDefinedResources?

  @description('Optional. List of the configuration status for each recommendation type.')
  recommendationsConfiguration: resourceInput<'Microsoft.Security/iotSecuritySolutions@2019-08-01'>.properties.recommendationsConfiguration?
}

@export()
@description('The type for a security automation (continuous export) configuration.')
type securityAutomationType = {
  @description('Required. The name of the security automation resource.')
  name: string

  @description('Required. The resource group to deploy the automation into.')
  resourceGroupName: string

  @description('Optional. Location for the automation resource. Defaults to the deployment location.')
  location: string?

  @description('Optional. Tags for the automation resource.')
  tags: resourceInput<'Microsoft.Security/iotSecuritySolutions@2019-08-01'>.tags?

  @description('Optional. Description of the security automation.')
  description: string?

  @description('Optional. Whether the security automation is enabled. Defaults to true.')
  isEnabled: bool?

  @description('Required. The scopes on which the automation logic is applied (subscription or resource group IDs).')
  scopes: resourceInput<'Microsoft.Security/automations@2023-12-01-preview'>.properties.scopes

  @description('Required. The source event types which evaluate the automation rules.')
  sources: resourceInput<'Microsoft.Security/automations@2023-12-01-preview'>.properties.sources

  @description('Required. The actions triggered when all rules evaluate to true.')
  actions: resourceInput<'Microsoft.Security/automations@2023-12-01-preview'>.properties.actions
}

@description('The type for server vulnerability assessments settings.')
type serverVulnerabilityAssessmentsSettingType = {
  @description('Required. The selected vulnerability assessments provider (e.g., MdeTvm for Microsoft Defender Vulnerability Management).')
  selectedProvider: 'MdeTvm'
}

@export()
@description('The type for a custom security standard.')
type securityStandardType = {
  @description('Required. The name (GUID) of the security standard.')
  name: string

  @description('Required. The display name of the security standard.')
  displayName: resourceInput<'Microsoft.Security/securityStandards@2024-08-01'>.properties.displayName

  @description('Optional. Description of the security standard.')
  description: resourceInput<'Microsoft.Security/securityStandards@2024-08-01'>.properties.description?

  @description('Optional. List of assessment keys to apply to the standard scope.')
  assessments: resourceInput<'Microsoft.Security/securityStandards@2024-08-01'>.properties.assessments?

  @description('Optional. List of cloud providers the standard supports.')
  cloudProviders: resourceInput<'Microsoft.Security/securityStandards@2024-08-01'>.properties.cloudProviders?

  @description('Optional. The policy set definition ID associated with the standard.')
  policySetDefinitionId: resourceInput<'Microsoft.Security/securityStandards@2024-08-01'>.properties.policySetDefinitionId?
}

@export()
@description('The type for a standard assignment.')
type standardAssignmentType = {
  @description('Required. The name (GUID) of the standard assignment.')
  name: string

  @description('Required. The resource ID of the assigned standard.')
  assignedStandard: resourceInput<'Microsoft.Security/standardAssignments@2024-08-01'>.properties.assignedStandard

  @description('Optional. Description of the assignment.')
  description: resourceInput<'Microsoft.Security/standardAssignments@2024-08-01'>.properties.description?

  @description('Optional. Display name of the assignment.')
  displayName: resourceInput<'Microsoft.Security/standardAssignments@2024-08-01'>.properties.displayName?

  @description('Optional. The effect of the assignment (e.g., Audit, Exempt).')
  effect: resourceInput<'Microsoft.Security/standardAssignments@2024-08-01'>.properties.effect?

  @description('Optional. List of scopes excluded from the assignment.')
  excludedScopes: resourceInput<'Microsoft.Security/standardAssignments@2024-08-01'>.properties.excludedScopes?

  @description('Optional. Expiration date of the assignment.')
  expiresOn: resourceInput<'Microsoft.Security/standardAssignments@2024-08-01'>.properties.expiresOn?

  @description('Optional. Additional metadata for the assignment.')
  metadata: resourceInput<'Microsoft.Security/standardAssignments@2024-08-01'>.properties.metadata?
}

@export()
@description('The type for a custom security recommendation.')
type customRecommendationType = {
  @description('Required. The name (GUID) of the custom recommendation.')
  name: string

  @description('Required. The display name of the recommendation.')
  displayName: resourceInput<'Microsoft.Security/customRecommendations@2024-08-01'>.properties.displayName

  @description('Optional. Description of the recommendation.')
  description: resourceInput<'Microsoft.Security/customRecommendations@2024-08-01'>.properties.description?

  @description('Required. The severity of the recommendation.')
  severity: resourceInput<'Microsoft.Security/customRecommendations@2024-08-01'>.properties.severity

  @description('Optional. The security issue category.')
  securityIssue: resourceInput<'Microsoft.Security/customRecommendations@2024-08-01'>.properties.securityIssue?

  @description('Required. KQL query representing the recommendation results.')
  query: resourceInput<'Microsoft.Security/customRecommendations@2024-08-01'>.properties.query

  @description('Optional. The remediation description.')
  remediationDescription: resourceInput<'Microsoft.Security/customRecommendations@2024-08-01'>.properties.remediationDescription?

  @description('Optional. List of cloud providers the recommendation applies to.')
  cloudProviders: resourceInput<'Microsoft.Security/customRecommendations@2024-08-01'>.properties.cloudProviders?
}

@export()
@description('The type for a Defender for Cloud integration setting (MCAS, WDATP, Sentinel).')
type securitySettingType = {
  @description('Required. The setting name (MCAS, WDATP, WDATP_EXCLUDE_LINUX_PUBLIC_PREVIEW, WDATP_UNIFIED_SOLUTION, or Sentinel).')
  name: 'MCAS' | 'WDATP' | 'WDATP_EXCLUDE_LINUX_PUBLIC_PREVIEW' | 'WDATP_UNIFIED_SOLUTION' | 'Sentinel'

  @description('Required. The kind of setting (DataExportSettings for MCAS/WDATP, AlertSyncSettings for Sentinel).')
  kind: 'AlertSyncSettings' | 'DataExportSettings'

  @description('Required. Whether the setting is enabled.')
  enabled: bool
}

@export()
@description('The type for a custom assessment metadata definition.')
type assessmentMetadataType = {
  @description('Required. The name (GUID) of the assessment metadata.')
  name: string

  @description('Required. The display name of the assessment.')
  displayName: resourceInput<'Microsoft.Security/assessmentMetadata@2025-05-04'>.properties.displayName

  @description('Optional. Description of the assessment.')
  description: resourceInput<'Microsoft.Security/assessmentMetadata@2025-05-04'>.properties.description?

  @description('Required. The severity of the assessment.')
  severity: resourceInput<'Microsoft.Security/assessmentMetadata@2025-05-04'>.properties.severity

  @description('Required. The assessment type (BuiltIn, CustomPolicy, CustomerManaged, VerifiedPartner).')
  assessmentType: resourceInput<'Microsoft.Security/assessmentMetadata@2025-05-04'>.properties.assessmentType

  @description('Optional. Categories the assessment belongs to.')
  categories: resourceInput<'Microsoft.Security/assessmentMetadata@2025-05-04'>.properties.categories?

  @description('Optional. The implementation effort required.')
  implementationEffort: resourceInput<'Microsoft.Security/assessmentMetadata@2025-05-04'>.properties.implementationEffort?

  @description('Optional. The remediation description.')
  remediationDescription: resourceInput<'Microsoft.Security/assessmentMetadata@2025-05-04'>.properties.remediationDescription?

  @description('Optional. Threats the assessment mitigates.')
  threats: resourceInput<'Microsoft.Security/assessmentMetadata@2025-05-04'>.properties.threats?

  @description('Optional. The user impact of the assessment.')
  userImpact: resourceInput<'Microsoft.Security/assessmentMetadata@2025-05-04'>.properties.userImpact?
}

@export()
@description('The type for an alert suppression rule.')
type alertsSuppressionRuleType = {
  @description('Required. The unique name of the suppression rule.')
  name: string

  @description('Required. The alert type to suppress. Use \'*\' for all alert types.')
  alertType: resourceInput<'Microsoft.Security/alertsSuppressionRules@2019-01-01-preview'>.properties.alertType

  @description('Required. The reason for dismissing the alert.')
  reason: resourceInput<'Microsoft.Security/alertsSuppressionRules@2019-01-01-preview'>.properties.reason

  @description('Required. The state of the rule (Enabled, Disabled, or Expired).')
  state: resourceInput<'Microsoft.Security/alertsSuppressionRules@2019-01-01-preview'>.properties.state

  @description('Optional. Comment regarding the rule.')
  comment: resourceInput<'Microsoft.Security/alertsSuppressionRules@2019-01-01-preview'>.properties.comment?

  @description('Optional. Expiration date of the rule in UTC. If not provided, the rule will not expire.')
  expirationDateUtc: resourceInput<'Microsoft.Security/alertsSuppressionRules@2019-01-01-preview'>.properties.expirationDateUtc?

  @description('Optional. The suppression conditions — all conditions must be true to suppress the alert.')
  suppressionAlertsScope: resourceInput<'Microsoft.Security/alertsSuppressionRules@2019-01-01-preview'>.properties.suppressionAlertsScope?
}

@export()
@description('The type for a governance rule.')
type governanceRuleType = {
  @description('Required. The unique name of the governance rule.')
  name: string

  @description('Required. The display name of the governance rule.')
  displayName: resourceInput<'Microsoft.Security/governanceRules@2022-01-01-preview'>.properties.displayName

  @description('Required. The rule type (e.g., Integrated, ServiceNow).')
  ruleType: resourceInput<'Microsoft.Security/governanceRules@2022-01-01-preview'>.properties.ruleType

  @description('Required. The source resource type (e.g., Assessments).')
  sourceResourceType: resourceInput<'Microsoft.Security/governanceRules@2022-01-01-preview'>.properties.sourceResourceType

  @description('Required. The rule priority (0-1000, lower is higher priority).')
  rulePriority: resourceInput<'Microsoft.Security/governanceRules@2022-01-01-preview'>.properties.rulePriority

  @description('Required. The owner source for the rule.')
  ownerSource: resourceInput<'Microsoft.Security/governanceRules@2022-01-01-preview'>.properties.ownerSource

  @description('Required. The condition sets that determine when the rule applies.')
  conditionSets: resourceInput<'Microsoft.Security/governanceRules@2022-01-01-preview'>.properties.conditionSets

  @description('Optional. Description of the governance rule.')
  description: resourceInput<'Microsoft.Security/governanceRules@2022-01-01-preview'>.properties.description?

  @description('Optional. Whether the rule is disabled.')
  isDisabled: resourceInput<'Microsoft.Security/governanceRules@2022-01-01-preview'>.properties.isDisabled?

  @description('Optional. Whether there is a grace period on the governance rule.')
  isGracePeriod: resourceInput<'Microsoft.Security/governanceRules@2022-01-01-preview'>.properties.isGracePeriod?

  @description('Optional. Remediation timeframe (e.g., 7.00:00:00 for 7 days).')
  remediationTimeframe: resourceInput<'Microsoft.Security/governanceRules@2022-01-01-preview'>.properties.remediationTimeframe?

  @description('Optional. Whether to include member scopes.')
  includeMemberScopes: resourceInput<'Microsoft.Security/governanceRules@2022-01-01-preview'>.properties.includeMemberScopes?

  @description('Optional. Excluded scopes to filter out descendants.')
  excludedScopes: resourceInput<'Microsoft.Security/governanceRules@2022-01-01-preview'>.properties.excludedScopes?

  @description('Optional. Email notification settings for the governance rule.')
  governanceEmailNotification: resourceInput<'Microsoft.Security/governanceRules@2022-01-01-preview'>.properties.governanceEmailNotification?
}
