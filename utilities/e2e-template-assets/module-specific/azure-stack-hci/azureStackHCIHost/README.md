# HCI Assets for deployment validation

The templates & scripts in this folder are designed to support the testing of Azure Stack HCI scenarios using nested virtualization on a VM deployed in Azure.

The module creates an Azure VM, then uses a series of PowerShell Managed Run Commands and Deployment Scripts to prepare the host VM and deploy the nested Azure Stack HCI VMs. To simplify the design, the host VM is also configured as an AD domain controller, DNS server, DHCP server, and RRAS router, in addition to a Hyper-v host. The deployment is zero-touch to support pipeline deployments.

The HCI Node VMs are brought to the point of Arc initialization. Deployment of the Azure Stack HCI cluster on top of the node VMs requires additional steps, either taken through the Portal or another IaC template.

## Capabilities

- HCI Cluster Size: The number of Azure Stack HCI nodes is determined by the `hciNodeCount` parameter. For each node, an additional data disk is added to the host VM. The host VM must be sized appropriately to accommodate the count of nodes (RAM and CPUs), but the solution is best suited for smaller clusters (1-4 nodes)
- Spot VM: The host VM can be configured as a spot VM to reduce cost; however depending on the evication rate of the chosen spot SKU, this may be problematic--for example, if the VM is evicted during deployment of the HCI cluster.
- Switched and switchless support: the module supports switched and switchless cluster designs with the `switchlessStorageConfig` parameter
- Idempotence: The deployment has been written to be idempotent in most scenarios, so re-running after fixing an issue with a failed deployment is valid.
- Existing VNET association: the host VM can be connected to an existing VNET by passing the `vnetSubnetID` parameter--which can help with troubleshooting; otherwise, a new VNET is created.
- VHDX or ISO HCI OS source: the HCI node VMs are built with the Azure Stack HCI OS installed. The OS can be sourced from either a VHDX or an ISO file using either the `hciVHDXDownloadURL` or `hciISODownloadURL` parameters.
- Deployment with a proxy and/or Arc Gateway

## Troubleshooting

### Credentials

By default, the Domain Admin account and local administrator accounts have the username `admin-hci` and the password for these accounts is set by the `localAdminPassword` parameter. If you pass a random value to this parameter, but later need the password for troubleshooting a deployment issue, here are a couple options:

- Use a Run Command on the host VM to reset the admin password. Ex: `net user admin-hci '<aNewKnownValue1>'`
- Use a Run Command to decrypt the exported password stored locally on the host VM. Note, this password is encrypted to the SYSTEM account, so you must use Run Command or a tool like PSExec to decrypt it. Ex:

    ```powershell
    $c = Import-CliXML -Path 'C:\temp\hciHostDeployAdminCred.xml'
    $c.GetNetworkCredential().password
    ```

### Logging

All Run Command scripts log activity to the `C:\temp\hciHostDeploy.log` path on the host VM.

It is also possible to review Run Command output with a REST call, making sure you expand the instance view. For example: `invoke-azrest -path '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>/providers/Microsoft.Compute/virtualMachines/hciHost01/runCommands/runCommand6?api-version=2024-07-01&$expand=instanceView'`

## Using this module for a host through Arc initialization-only deployment

To use this Bicep module, you'll need to download a copy then supply values for the required parameters. Follow these steps:

1. Clone the repository with Git: `git clone https://github.com/Azure/bicep-registry-modules.git`
1. Navigate to this directory `avm\utilities\e2e-template-assets\templates\azure-stack-hci\modules\azureStackHCIHost` and review the parameters at the top of the `hciHostDeployment.bicep` file. Provide values as required by hardcoding them into the Bicep file or by building a parameters file.
1. Run the Bicep deployment. For example: `az deployment group create -f .\avm\utilities\e2e-template-assets\templates\azure-stack-hci\modules\azureStackHCIHost\hciHostDeployment.bicep`
1. When the deployment completes, the HCI nodes will be ready for an HCI cluster to be deployed on them. For example, you could use the Bicep module at this path `avm\res\azure-stack-hci\cluster\main.bicep` or using the Azure Portal.

## Using this template for an end-to-end HCI cluster deployment in Azure

To use this Bicep module, you'll need to download a copy then supply values for the required parameters. Follow these steps:

1. Clone the repository with Git: `git clone https://github.com/Azure/bicep-registry-modules.git`
1. Pick one of the E2E test templates in `avm\res\azure-stack-hci\cluster\tests\e2e`. NOTE: these templates all deploy to 'southeastasia' - to use another location, modify the `enforcedLocation` variable.
1. Create a parameter object in PowerShell to pass to the deployment. For example:

    ```powershell
    $templateParameterObjectAIRS = @{
        'arbDeploymentServicePrincipalSecret' = (Read-Host -AsSecureString -Prompt 'arbDeploymentServicePrincipalSecret')
        'localAdminAndDeploymentUserPass'     = (Read-Host -AsSecureString -Prompt 'localAdminAndDeploymentUserPass')
        'arbDeploymentSPObjectId'             = '4aceef22-f89f-42e8-8d8b-5aa3fb8fb57b'
        'arbDeploymentAppId'                  = '6e9515aa-715d-4a18-bdfe-463e8a004ffe'
        'hciResourceProviderObjectId'         = 'e44d5f5e-21c6-4b3a-b697-e1236d00b006'
        'location'                            = 'southeastasia'
        'deploymentPrefix'                    = -join ((97..122) | Get-Random -Count 5 | ForEach-Object { [char]$_ })
    }
    ```
1. Execute the deployment. Example: `new-AzSubscriptionDeployment -TemplateFile C:\Users\mbratschun\repos\bicep-registry-modules\avm\res\azure-stack-hci\cluster\tests\e2e\2nodeswitched.defaults\main.test.bicep -TemplateParameterObject $templateParameterObjectBAMI24H2 -Location southeastasia`
