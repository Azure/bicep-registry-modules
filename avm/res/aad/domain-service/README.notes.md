
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

### Replica Set

Replica Sets are not provisioned during the initial deployment. Once the first Replica Set has been deployed, additional Replica Sets will be provisioned.
You can deploy any additional virtual networks, subnets and NSGs required during the initial deployment.

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

