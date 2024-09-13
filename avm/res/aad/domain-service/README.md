# Azure Active Directory Domain Services `[Microsoft.AAD/domainServices]`

This module deploys an Azure Active Directory Domain Services (AADDS) instance.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.AAD/domainServices` | [2022-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AAD/2022-12-01/domainServices) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/aad/domain-service:<version>`.

- [WAF-aligned](#example-1-waf-aligned)

### Example 1: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module domainService 'br/public:avm/res/aad/domain-service:<version>' = {
  name: 'domainServiceDeployment'
  params: {
    // Required parameters
    domainName: 'onmicrosoft.com'
    // Non-required parameters
    additionalRecipients: [
      '@noreply.github.com'
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    externalAccess: 'Enabled'
    ldaps: 'Enabled'
    location: '<location>'
    lock: {
      kind: 'None'
      name: 'myCustomLockName'
    }
    name: 'aaddswaf001'
    pfxCertificate: '<pfxCertificate>'
    pfxCertificatePassword: '<pfxCertificatePassword>'
    replicaSets: [
      {
        location: 'NorthEurope'
        subnetId: '<subnetId>'
      }
    ]
    sku: 'Standard'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "domainName": {
      "value": "onmicrosoft.com"
    },
    // Non-required parameters
    "additionalRecipients": {
      "value": [
        "@noreply.github.com"
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs"
            }
          ],
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "externalAccess": {
      "value": "Enabled"
    },
    "ldaps": {
      "value": "Enabled"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "None",
        "name": "myCustomLockName"
      }
    },
    "name": {
      "value": "aaddswaf001"
    },
    "pfxCertificate": {
      "value": "<pfxCertificate>"
    },
    "pfxCertificatePassword": {
      "value": "<pfxCertificatePassword>"
    },
    "replicaSets": {
      "value": [
        {
          "location": "NorthEurope",
          "subnetId": "<subnetId>"
        }
      ]
    },
    "sku": {
      "value": "Standard"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domainName`](#parameter-domainname) | string | The domain name specific to the Azure ADDS service. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`pfxCertificate`](#parameter-pfxcertificate) | securestring | The certificate required to configure Secure LDAP. Should be a base64encoded representation of the certificate PFX file and contain the domainName as CN. Required if secure LDAP is enabled and must be valid more than 30 days. |
| [`pfxCertificatePassword`](#parameter-pfxcertificatepassword) | securestring | The password to decrypt the provided Secure LDAP certificate PFX file. Required if secure LDAP is enabled. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalRecipients`](#parameter-additionalrecipients) | array | The email recipient value to receive alerts. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`domainConfigurationType`](#parameter-domainconfigurationtype) | string | The value is to provide domain configuration type. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`externalAccess`](#parameter-externalaccess) | string | The value is to enable the Secure LDAP for external services of Azure ADDS Services. |
| [`filteredSync`](#parameter-filteredsync) | string | The value is to synchronize scoped users and groups. |
| [`kerberosArmoring`](#parameter-kerberosarmoring) | string | The value is to enable to provide a protected channel between the Kerberos client and the KDC. |
| [`kerberosRc4Encryption`](#parameter-kerberosrc4encryption) | string | The value is to enable Kerberos requests that use RC4 encryption. |
| [`ldaps`](#parameter-ldaps) | string | A flag to determine whether or not Secure LDAP is enabled or disabled. |
| [`location`](#parameter-location) | string | The location to deploy the Azure ADDS Services. Uses the resource group location if not specified. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`name`](#parameter-name) | string | The name of the AADDS resource. Defaults to the domain name specific to the Azure ADDS service. The prefix of your specified domain name (such as dscontoso in the dscontoso.com domain name) must contain 15 or fewer characters. |
| [`notifyDcAdmins`](#parameter-notifydcadmins) | string | The value is to notify the DC Admins. |
| [`notifyGlobalAdmins`](#parameter-notifyglobaladmins) | string | The value is to notify the Global Admins. |
| [`ntlmV1`](#parameter-ntlmv1) | string | The value is to enable clients making request using NTLM v1. |
| [`replicaSets`](#parameter-replicasets) | array | Additional replica set for the managed domain. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`sku`](#parameter-sku) | string | The name of the SKU specific to Azure ADDS Services. |
| [`syncNtlmPasswords`](#parameter-syncntlmpasswords) | string | The value is to enable synchronized users to use NTLM authentication. |
| [`syncOnPremPasswords`](#parameter-synconprempasswords) | string | The value is to enable on-premises users to authenticate against managed domain. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`tlsV1`](#parameter-tlsv1) | string | The value is to enable clients making request using TLSv1. |

### Parameter: `domainName`

The domain name specific to the Azure ADDS service.

- Required: Yes
- Type: string
- Example:
  ```Bicep
  - 'contoso.onmicrosoft.com'
  - 'aaddscontoso.com'
  ```

### Parameter: `pfxCertificate`

The certificate required to configure Secure LDAP. Should be a base64encoded representation of the certificate PFX file and contain the domainName as CN. Required if secure LDAP is enabled and must be valid more than 30 days.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `pfxCertificatePassword`

The password to decrypt the provided Secure LDAP certificate PFX file. Required if secure LDAP is enabled.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `additionalRecipients`

The email recipient value to receive alerts.

- Required: No
- Type: array
- Default: `[]`
- Example:
  ```Bicep
  - ['john@doh.org']
  - ['john@doh.org','jane@doh.org']
  ```

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-diagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `domainConfigurationType`

The value is to provide domain configuration type.

- Required: No
- Type: string
- Default: `'FullySynced'`
- Allowed:
  ```Bicep
  [
    'FullySynced'
    'ResourceTrusting'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `externalAccess`

The value is to enable the Secure LDAP for external services of Azure ADDS Services.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `filteredSync`

The value is to synchronize scoped users and groups.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `kerberosArmoring`

The value is to enable to provide a protected channel between the Kerberos client and the KDC.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `kerberosRc4Encryption`

The value is to enable Kerberos requests that use RC4 encryption.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `ldaps`

A flag to determine whether or not Secure LDAP is enabled or disabled.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `location`

The location to deploy the Azure ADDS Services. Uses the resource group location if not specified.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `name`

The name of the AADDS resource. Defaults to the domain name specific to the Azure ADDS service. The prefix of your specified domain name (such as dscontoso in the dscontoso.com domain name) must contain 15 or fewer characters.

- Required: No
- Type: string
- Default: `[parameters('domainName')]`

### Parameter: `notifyDcAdmins`

The value is to notify the DC Admins.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `notifyGlobalAdmins`

The value is to notify the Global Admins.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `ntlmV1`

The value is to enable clients making request using NTLM v1.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `replicaSets`

Additional replica set for the managed domain.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-replicasetslocation) | string | Virtual network location. |
| [`subnetId`](#parameter-replicasetssubnetid) | string | The id of the subnet that Domain Services will be deployed on. The subnet has some requirements, which are outlined in the [notes section](#Network-Security-Group-NSG-requirements-for-AADDS) of the documentation. |

### Parameter: `replicaSets.location`

Virtual network location.

- Required: Yes
- Type: string

### Parameter: `replicaSets.subnetId`

The id of the subnet that Domain Services will be deployed on. The subnet has some requirements, which are outlined in the [notes section](#Network-Security-Group-NSG-requirements-for-AADDS) of the documentation.

- Required: Yes
- Type: string
- Example: `/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/<resourceGroup>/providers/Microsoft.Network/virtualNetworks/<vnetName>/subnets/<subnetName>`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `sku`

The name of the SKU specific to Azure ADDS Services.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Enterprise'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `syncNtlmPasswords`

The value is to enable synchronized users to use NTLM authentication.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `syncOnPremPasswords`

The value is to enable on-premises users to authenticate against managed domain.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object
- Example:
  ```Bicep
  {
      "key1": "value1",
      "key2": "value2"
  }
  ```

### Parameter: `tlsV1`

The value is to enable clients making request using TLSv1.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The domain name of the Azure Active Directory Domain Services(Azure ADDS). |
| `resourceGroupName` | string | The name of the resource group the Azure Active Directory Domain Services(Azure ADDS) was created in. |
| `resourceId` | string | The resource ID of the Azure Active Directory Domain Services(Azure ADDS). |

## Notes

This module requires prerequisites, that can't be done via ARM/Bicep at the moment. The prerequisites to create a managed domain are outlined [here](https://learn.microsoft.com/en-us/entra/identity/domain-services/template-create-instance#prerequisites).

>**Note**: Please make sure you follow the steps to make sure the prerequisites are fullfilled before using the module.

### Create a Service Principal

Follow the steps [Create required Microsoft Entra resources](https://learn.microsoft.com/en-us/entra/identity/domain-services/template-create-instance#create-required-microsoft-entra-resources), which are summarized in the following steps:

1. Prepare PowerShell for Graph interaction
   - [Install the Microsoft Graph PowerShell SDK](https://learn.microsoft.com/en-us/powershell/microsoftgraph/installation?view=graph-powershell-1.0) ```Install-Module Microsoft.Graph -Scope CurrentUser```
   - Import the needed module ```Import-Module -Name Microsoft.Graph.Identity.Governance -Force```

1. [Assign](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/manage-roles-portal) the [Application Developer](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference#application-developer) to the current user to add the required Service Principal.

   ```powershell
   # Connect (will open a browser)
   Connect-MgGraph -Scopes "User.Read.All,Application.ReadWrite.All"
   # Replace with your user
   $user = Get-MgUser -Filter "userPrincipalName eq 'johndoe@contoso.com'"
   # Get the role to assign it to the user
   $roledefinition = Get-MgRoleManagementDirectoryRoleDefinition -Filter "DisplayName eq 'Application Developer'"
   # Assign the role (without PIM)
   $roleassignment = New-MgRoleManagementDirectoryRoleAssignment -DirectoryScopeId '/' -RoleDefinitionId $roledefinition.Id -PrincipalId $user.Id
   ```

   If you have PIM activated, assign the role like this:

   ```powershell
   # limit the assignment to 1 hour
   $params = @{
      "PrincipalId" = $user.Id
      "RoleDefinitionId" = $roledefinition.Id
      "Justification" = "Add eligible assignment"
      "DirectoryScopeId" = "/"
      "Action" = "AdminAssign"
      "ScheduleInfo" = @{
         "StartDateTime" = Get-Date
         "Expiration" = @{
            "Type" = "AfterDuration"
            "Duration" = "PT1H"
         }
      }
   }
   New-MgRoleManagementDirectoryRoleEligibilityScheduleRequest -BodyParameter $params | Format-List Id, Status, Action, AppScopeId, DirectoryScopeId, RoleDefinitionId, IsValidationOnly, Justification, PrincipalId, CompletedDateTime, CreatedDateTime
   ```

3. Create the necessary Service Principal

   ```powershell
   New-MgServicePrincipal -AppId 2565bd9d-da50-47d4-8b85-4c97f669dc36 -DisplayName "Domain Controller Services"
   ```

#### GitHub Action deployment testing

In order to provision Entra Domain Services, the Service Principal that has been set up in [Setup your Azure test environment](https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#1-setup-your-azure-test-environment) needs two additional roles, as of [Tutorial: Create and configure a Microsoft Entra Domain Services managed domain - Prerequisites](https://learn.microsoft.com/en-us/entra/identity/domain-services/tutorial-create-instance#prerequisites).

### Network Security Group (NSG) requirements for AADDS

- A network security group has to be created and assigned to the designated AADDS subnet before deploying this module
  - The following inbound rules should be allowed on the network security group
    | Name | Protocol | Source Port Range | Source Address Prefix | Destination Port Range | Destination Address Prefix |
    | - | - | - | - | - | - |
    | AllowSyncWithAzureAD | TCP | `*` | `AzureActiveDirectoryDomainServices` | `443` | `*` |
    | AllowPSRemoting | TCP | `*` | `AzureActiveDirectoryDomainServices` | `5986` | `*` |
    | AllowLDAPs | TCP | `*` | `VirtualNetwork` | `5986` | `*` |
- Associating a route table to the AADDS subnet is not recommended
- The network used for AADDS must have its [DNS Servers configured](https://learn.microsoft.com/en-us/azure/active-directory-domain-services/tutorial-configure-networking#configure-dns-servers-in-the-peered-virtual-network) (e.g. with IPs `10.0.1.4` & `10.0.1.5`)

### Create self-signed certificate for secure LDAP
Follow the below PowerShell commands to get base64 encoded string of a self-signed certificate (with a `pfxCertificatePassword`)

```PowerShell
$pfxCertificatePassword = ConvertTo-SecureString '[[YourPfxCertificatePassword]]' -AsPlainText -Force
$certInputObject = @{
    Subject           = 'CN=*.[[YourDomainName]]'
    DnsName           = '*.[[YourDomainName]]'
    CertStoreLocation = 'cert:\LocalMachine\My'
    KeyExportPolicy   = 'Exportable'
    Provider          = 'Microsoft Enhanced RSA and AES Cryptographic Provider'
    NotAfter          = (Get-Date).AddMonths(3)
    HashAlgorithm     = 'SHA256'
}
$rawCert = New-SelfSignedCertificate @certInputObject
Export-PfxCertificate -Cert ('Cert:\localmachine\my\' + $rawCert.Thumbprint) -FilePath "$home/aadds.pfx" -Password $pfxCertificatePassword -Force
$rawCertByteStream = Get-Content "$home/aadds.pfx" -AsByteStream
$pfxCertificate = [System.Convert]::ToBase64String($rawCertByteStream)
```

### References

- [Prerequisites to use PowerShell or Graph Explorer for Microsoft Entra roles](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/prerequisites)
- [Assign Microsoft Entra roles to users](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/manage-roles-portal)
- [New-MgServicePrincipal](https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.applications/new-mgserviceprincipal)
- [Create a Microsoft Entra Domain Services managed domain using an Azure Resource Manager template](https://learn.microsoft.com/en-us/entra/identity/domain-services/template-create-instance)

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
