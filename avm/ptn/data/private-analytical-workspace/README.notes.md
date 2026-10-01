
This pattern aims to speed up data science projects and create Azure environments
for data analysis in a secure and enterprise-ready way.

Data scientists should not worry about infrastructure details.<br>
Ideally, data scientists should only focus on the data analytics tools they need for the solution. For example Databricks, Machine learning, database, etc.<br>
Enterprise security, monitoring, secrets storage, databases, access over a private network should be built into the solution in a transparent way so cloud and security team can approve the whole solution easily.

One of the design goals of this pattern is to have all the services that are part of the solution
connected to one virtual network to make the traffic between services private (use of private endpoints).
A virtual network can be either created along with the solution or
an existing / pre-defined virtual network (Hub/Spoke model – spoke VNET made by network enterprise team) can be chosen.

The solution's services save diagnostics data to Azure Log Analytics Workspace,
either created along with the solution or an existing / pre-defined.
Secrets such as connection string or data source credentials should
go to secrets store securely. Analytical tools use secure credentials to access data sources.
Secrets can go to Azure Key Vault, either existing or new.

The solution will include at least a virtual network (either created or using VNET created
by enterprise network team), Azure Log Analytics workspace for diagnostics and monitoring
(either created or given by cloud team) and Azure Key Vault as secrets
store (either created or given by cloud team).

Every resource in the solution can be tagged and locked.
The owner role for every resource can be given with the ```solutionAdministrators.*``` parameter.</br>
All resources are named according to the provided input parameter ```name```.</br>
All resources gather diagnostic and monitoring data, which is then stored in either a newly created or an existing Log Analytics Workspace.

The solution may optionally include additional analytical services, for instance by enabling the ```enableDatabricks``` parameter.</br>
The parameter ```advancedOptions.*``` allows for finer customization of the solution.
Certain Azure services within the solution can be reached via a public endpoint (if preferred) and can also be limited using network access control lists by permitting only the public IP of the accessing client.

This solution invariably demands a Virtual network presence.
At the very least, it necessitates a single subnet to cater to private link endpoints.
The incorporation of additional optional services implies further prerequisites for the network,
such as subnets, their sizes, network security groups, NSG access control lists, (sometimes) private endpoints, DNS zones, etc.
For instance, activating the Azure Databricks service would automatically generate a virtual network and its essential components per established best practices.</br>
When an enterprise's virtual network is supplied by either the network or cloud team, it has to comply with the requirements of the services being activated.
It's crucial that Network Security Groups, Network Security Group Rules, DNS Zones and DNS forwarding, (sometimes) private endpoints, and domain zones for services like Key Vault and Azure Databricks, along with subnet delegations, are all set up correctly.
For example, refer to the documentation here: https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/vnet-inject#--virtual-network-requirements.

### Supported Use Cases

#### Use Case 1: Greenfield, isolated network deployment

This use case is fairly simple to provision while ensuring security.
Ideal for rapid problem-solving that requires an analytical workspace for swift development.
The solution will create all the required components such as Virtual Network, Monitoring, Key Vault, permissions, and analytical services.
All utilizing recommended practices.

Because of the isolated network configuration, public IP addresses of customers must be designated as authorized to access the environment through secure public endpoints.
The solution will only be accessible from predetermined public IP addresses. This use case may not be suitable for highly restrictive enterprises that have strict no public IP policies.</br>
The identity of the solution administrator or the managing group must be submitted to gain access and control over the solution.
There is no requirement to pre-establish a virtual network or any additional components.

##### Virtual Network

A Virtual Network will be created with all necessary components and will be established to accommodate the designated Azure Services.
This will include the creation of appropriate subnets, private links, and Network Security Groups.
Additionally, it will leverage Azure DNS along with Azure DNS zones for the configuration of private endpoints, which will be associated with the Virtual Network.

The assigned IP address range of a Virtual Network may conflict with that of an enterprise network. As a result, this virtual network should not be connected, or peered, with any enterprise network. In this use case, the virtual network is established as an isolated segment.

Since it's an isolated segment, in order to access client resources such as key vault and others, the client's public IP must be included in the allowed range within the ```advancedOptions.networkAcls.ipRules``` parameter.

For a dedicated virtual network to be provisioned for you (this use case), the Virtual Network ```virtualNetworkResourceId``` parameter needs to remain unfilled.

<a name="monitoring-uc1"></a>
##### Monitoring of the Solution

If the parameter ```logAnalyticsWorkspaceResourceId``` is left unspecified or set to ```null```, a new Azure Log Analytics Workspace will be created as part of the solution. The diagnostic settings for most services within the solution will be configured to channel into this newly created Azure Log Analytics Workspace.</br>
Additional creation configurations for the Azure Log Analytics Workspace are available under the parameter ```advancedOptions.logAnalyticsWorkspace.*```.</br>
The ```logAnalyticsWorkspaceResourceId``` parameter may be configured to use an existing Azure Log Analytics Workspace, which is beneficial for enterprises that prefer to centralize their diagnostic data.</br>

<a name="kv-uc1"></a>
##### Storing Secrets - Key Vault

If the parameter ```keyVaultResourceId``` is left unspecified or set to ```null```, a new Azure Key Vault will be created as part of the solution.</br>
Additional creation configurations for the Azure Key Vault are available under the parameter ```advancedOptions.keyVault.*```.</br>
As part of the solution, a private endpoint and a DNS Key Vault Zone are created. To handle secrets through the Azure Portal, Public Access must be provided for the given public IP within the parameter ```advancedOptions.networkAcls.ipRules```.</br>
For the handling of secrets, users need to have privileged roles. Those listed in the ```solutionAdministrators.*``` parameter will receive 'Key Vault Administrator' privileges specifically for Azure Key Vaults that are newly created.</br>

<a name="sol-admin-uc1"></a>
##### Solution Administrators

In order to grant administrative rights for the newly created services that have been added to the solution, you should utilize the parameter ```solutionAdministrators.*```. You can designate User or Entra ID Groups for this purpose.</br>
The specified identities will be granted ownership of the solution, enabling them to delegate permissions as necessary. Additionally, they will obtain 'Key Vault Administrator' rights, which apply solely to the Azure Key Vaults that have been created as part of the solution.</br>
It's essential to designate an individual as the Solution Administrator to utilize the solution effectively.</br>

<a name="adb-uc1"></a>
##### Analytical Service - Azure Databricks

If the parameter ```enableDatabricks``` is set to ```true```, a new Azure Databricks instance will be created as part of the solution.</br>
Additional creation configurations for the Azure Databricks are available under the parameter ```advancedOptions.databricks.*```.</br>
As part of the solution, two subnets with delegations, two private endpoints, network security groups and a Azure Databricks Zone are created.</br>
To access Azure Databricks integrated into the isolated Virtual Network, Public Access must be provided for the given public IP within the parameter ```advancedOptions.networkAcls.ipRules```.</br>
Additional manual setup is required to restrict public access for different clients. Refer to this guide for more information: <https://learn.microsoft.com/en-us/azure/databricks/security/network/front-end/ip-access-list#ip-access-lists-overview></br>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'UC1'
  params: {
    // Required parameters
    name: 'pawuc1'
    // Non-required parameters
    virtualNetworkResourceId: null        // null means new VNET will be created
    logAnalyticsWorkspaceResourceId: null // null means new Log Analytical Workspace will be created
    keyVaultResourceId: null              // null means new Azure key Vault will be created
    enableDatabricks: true                // Part of the solution and VNET will be new instance of the Azure Databricks
    solutionAdministrators: [
      {
        principalId: <EntraGroupId>       // Specified group will have enough permissions to manage the solution
        principalType: 'Group'            // Group and/or User type can be specified
      }
    ]
    advancedOptions: {
      networkAcls: { ipRules: [<AllowedPublicIPAddress>] } // Which public IP addresses of the end users can access the isolated solution (enables public endpoints for some services)
    }
    tags: { Owner: 'Contoso', 'Cost Center': '2345-324' }
  }
}
```

<a name="uc2"></a>
#### Use Case 2: Brownfield, Implementation in an Existing, Enterprise-Specific Virtual Network for a New Deployment

This use case seeks to align with the expectations of enterprise infrastructure.</br>
For instance, certain companies prohibit the use of public IP addresses in their solutions.</br>
The solution will provision certain elements such as Monitoring, Key Vault, permissions, and analytics services.</br>
However, additional configurations may be required before and after deployment.</br>
Choosing this option allows you to tailor the infrastructure, but typically requires customized services from the cloud, security, and network teams, leading to less agility and project delays.</br>
This case presents a balance between an extended deployment timeline and compliance with corporate policies and infrastructure requirements.</br>

Complexity could be notably high on the Virtual Network side.</br>
Anticipate the need for virtual network peering arrangements using a hub and spoke design, route tables, configuration of DNS, private zones, (sometimes) private endpoints, DNS forwarding for private links, virtual network delegations, and so on.</br>
Additionally, various analytics services may each have distinct virtual network requirements.

This use case does not require any public IP addresses to be exposed.</br>
All services can utilize private Enterprise Network access exclusively.

The identity of the solution administrator or the managing group must be submitted to gain access and control over the solution.

<a name="vnet-uc2"></a>
##### Virtual Network

The enterprise network team needs to set up a virtual network with necessary components and settings in advance. This must be a spoke-type network connected to the central hub network with central Enterprise Firewall and connectivity to enterprise network - following the hub and spoke architecture.

The Customer/Network team must set up a unique virtual network without overlapping the corporate address space, designate the right-sized subnets, manage network delegations, route tables, set up corporate DNS at the Virtual Network level, enroll private links in enterprise-grade private DNS zones with forwarding for resolving private links, and create specific Network Security Groups with tailored rules for certain services enabled in the solution.

Creating at least a /26 subnet is essential for hosting private endpoints. As additional analytical services are activated, there will generally be a need for a greater number of subnets of varying sizes.
The services within the solution vary in their requirements. For instance, consider the needs of Azure Databricks:

- https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/vnet-inject#network-security-group-rules-for-workspaces
- https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/udr

Review the necessary subnets, subnet sizing, routing, DNS settings, network security groups, delegations for 'Microsoft.Databricks/workspaces', and private endpoints.

If only full private access is required, the ```advancedOptions.networkAcls.ipRules``` parameter should not be configured.

When utilizing a pre-defined virtual network provided by the Enterprise Network team (this use case), the ```virtualNetworkResourceId``` parameter should be set to reference the existing Virtual Network.

##### Monitoring of the Solution

The rules outlined here: [Monitoring of the Solution for Use Case 1](#monitoring-uc1) apply to this use case as well.

<a name="kv-uc2"></a>
##### Storing Secrets - Key Vault

If the parameter ```keyVaultResourceId``` is left unspecified or set to ```null```, a new Azure Key Vault will be created as part of the solution.</br>
Additional creation configurations for the Azure Key Vault are available under the parameter ```advancedOptions.keyVault.*```.</br>

This use case resembles use case [Storing Secrets - Key Vault for Use Case 1](#kv-uc1).
The difference is that the customer usually needs full private access in own virtual network and must configure (sometimes) private endpoints for the created Azure Key Vault.
This includes registering DNS records pointing to the private IP address under the private endpoint for Network Interface Card.
Additionally, the customer must create or use an existing Azure Key Vault private DNS zone to support private endpoint resolution
and integrate it with enterprise DNS and DNS forwarding mechanisms.

To allow both private and public access, you can set the ```advancedOptions.networkAcls.ipRules``` parameter
to include the client's public IP (enables public endpoints for some services).

For the handling of secrets, users need to have privileged roles.
Those listed in the ```solutionAdministrators.*``` parameter will receive 'Key Vault Administrator'
privileges specifically for Azure Key Vaults that are newly created.</br>

##### Solution Administrators

The rules outlined here: [Solution Administrators for Use Case 1](#sol-admin-uc1) apply to this use case as well.

<a name="adb-uc2"></a>
##### Analytical Service - Azure Databricks

If the parameter ```enableDatabricks``` is set to ```true```, a new Azure Databricks instance will be created as part of the solution.</br>
Additional creation configurations for the Azure Databricks are available under the parameter ```advancedOptions.databricks.*```.</br>

This use case resembles use case [Analytical Service - Azure Databricks for Use Case 1](#adb-uc1).
The difference is that the customer usually needs full private access in own virtual network and must configure (sometimes) private endpoints for the created Azure Databricks.
This includes registering DNS records pointing to the private IP address under the private endpoint for Network Interface Card.
Additionally, the customer must create or use an existing Azure Databricks private DNS zone to support private endpoint resolution
and integrate it with enterprise DNS and DNS forwarding mechanisms.

This use case usually involves integrating with a private virtual network. Refer to: [Virtual Network for Use Case 2](#vnet-uc2).
The network team needs to set up the virtual network to include a private links subnet and two additional subnets delegated for Azure Databricks.
Then, create (sometimes) two private endpoints, network security groups, and an Azure Databricks Zone.

Refer to this guide for more information: <https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/vnet-inject>
and this: <https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/private-link></br>

To allow both private and public access, you can set the ```advancedOptions.networkAcls.ipRules``` parameter
to include the client's public IP (enables public endpoints for some services).
If you allow public access, additional manual setup is required to restrict public access for different clients.
Refer to this guide for more information: <https://learn.microsoft.com/en-us/azure/databricks/security/network/front-end/ip-access-list#ip-access-lists-overview></br>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'UC2'
  params: {
    // Required parameters
    name: 'pawuc2'
    // Non-required parameters
    virtualNetworkResourceId: '/subscriptions/{SUBSCRIPTION-ID}/resourceGroups/{NAME-OF-RG}/providers/Microsoft.Network/virtualNetworks/{NAME-OF-VNET}'
    logAnalyticsWorkspaceResourceId: null // null means new Log Analytical Workspace will be created
    keyVaultResourceId: null              // null means new Azure key Vault will be created
    enableDatabricks: true                // Part of the solution will be new instance of the Azure Databricks
    solutionAdministrators: [
      {
        principalId: <EntraGroupId>       // Specified group will have enough permissions to manage the solution
        principalType: 'Group'            // Group and/or User type can be specified
      }
    ]
    advancedOptions: {
      networkAcls: { ipRules: [<AllowedPublicIPAddress>] } // Which public IP addresses of the end users can access the solution (enables public endpoints for some services)
    }
    tags: { Owner: 'Contoso', 'Cost Center': '2345-324' }
  }
}
```

#### Use Case 3: Integration with existing core Infrastructure

This use case aims to meet the specific needs of enterprise infrastructure, similar to use case
[Use Case 2: Brownfield, Implementation in an Existing, Enterprise-Specific Virtual Network for a New Deployment](#uc2) but more advanced.</br>
It integrates with a pre-provisioned virtual network for private traffic and pre-provisioned Azure Key Vault and central Azure Log Analytics workspace.</br>
This allows the cloud and network teams to provide core components, and the solution linking them together.</br>

Cloud and network teams remain responsible for configuring prerequisites and providing elements like private endpoints (sometimes), private endpoint zones, DNS resolution, and access permissions.</br>
Find further information here: [Use Case 2: Brownfield, Implementation in an Existing, Enterprise-Specific Virtual Network for a New Deployment](#uc2)</br>

This use case does not require any public IP addresses to be exposed,
but you can enable public access with the ```advancedOptions.networkAcls.ipRules``` parameter if necessary.</br>
All services can utilize private Enterprise Network access exclusively.

##### Virtual Network

The rules outlined here: [Virtual Network for Use Case 2](#vnet-uc2) apply to this use case as well.

##### Monitoring of the Solution

The rules outlined here: [Monitoring of the Solution for Use Case 1](#monitoring-uc1) apply to this use case as well.

The ```logAnalyticsWorkspaceResourceId``` parameter should be set to use an existing Azure Log Analytics Workspace.</br>

The team responsible for resource management must set up Azure Log Analytics Workspace access for the necessary end users.</br>

##### Storing Secrets - Key Vault

The rules outlined here: [Storing Secrets - Key Vault for Use Case 2](#kv-uc2) apply to this use case as well.

The ```keyVaultResourceId``` parameter should be set to use an existing Azure Key Vault.</br>

The team responsible for resource management must set up Azure Key Vault access for the necessary end users.</br>

##### Solution Administrators

The rules outlined here: [Solution Administrators for Use Case 1](#sol-admin-uc1) apply to this use case as well.</br>
However, role assignments will apply exclusively to resources generated within this use case, excluding those pre-created by the network and cloud team.</br>

##### Analytical Service - Azure Databricks

The rules outlined here: [Analytical Service - Azure Databricks for Use Case 2](#adb-uc2) apply to this use case as well.

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'UC3'
  params: {
    // Required parameters
    name: 'pawuc3'
    // Non-required parameters
    virtualNetworkResourceId: '/subscriptions/{SUBSCRIPTION-ID}/resourceGroups/{NAME-OF-RG}/providers/Microsoft.Network/virtualNetworks/{NAME-OF-VNET}'
    logAnalyticsWorkspaceResourceId: '/subscriptions/{SUBSCRIPTION-ID}/resourceGroups/{NAME-OF-RG}/providers/Microsoft.OperationalInsights/workspaces/{NAME-OF-LOG}'
    keyVaultResourceId: '/subscriptions/{SUBSCRIPTION-ID}/resourceGroups/{NAME-OF-RG}/providers/Microsoft.KeyVault/vaults/{NAME-OF-KV}'
    enableDatabricks: true                // Part of the solution will be new instance of the Azure Databricks
    solutionAdministrators: [
      {
        principalId: <EntraGroupId>       // Specified group will have enough permissions to manage the solution
        principalType: 'Group'            // Group and/or User type can be specified
      }
    ]
    advancedOptions: {
      networkAcls: { ipRules: [<AllowedPublicIPAddress>] } // Which public IP addresses of the end users can access the solution (enables public endpoints for some services)
    }
    tags: { Owner: 'Contoso', 'Cost Center': '2345-324' }
  }
}
```

