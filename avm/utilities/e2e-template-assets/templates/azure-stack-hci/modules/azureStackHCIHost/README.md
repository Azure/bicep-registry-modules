# HCI Azure Host Deployment Bicep Module

This module is designed for use in testing Azure Stack HCI scenarios using nested virtualization on a VM deployed in Azure.

The module creates an Azure VM, then uses a series of PowerShell Managed Run Commands and Deployment Scripts to prepare the host VM and deploy the nested Azure Stack HCI VMs. To simplify the design, the host VM is also configured as an AD domain controller, DNS server, DHCP server, and RRAS router, in addition to a Hyper-v host. The deployment is zero-touch to support pipeline deployments.

The HCI Node VMs are brought to the point of Arc initialization. Deployment of the Azure Stack HCI cluster on top of the node VMs requires additional steps, either taken through the Portal or another IaC template.

## Capabilities

- HCI Cluster Size: The number of Azure Stack HCI nodes is determined by the `hciNodeCount` parameter. For each node, an additional data disk is added to the host VM. The host VM must be sized appropriately to accomodate the count of nodes (RAM and CPUs), but the solution is best suited for smaller clusters (1-4 nodes)
- Spot VM: The host VM can be configured as a spot VM to reduce cost; however depending on the evication rate of the chosen spot SKU, this may be problematic--for example, if the VM is evicted during deployment of the HCI cluster.
- Switched and switchless support: the module supports switched and switchless cluster designs with the `switchlessStorageConfig` parameter
- Idempotency: The deployment has been written to be idempotent in most scenarios, so re-running after fixing an issue with a failed deployment is valid.
- Existing VNET association: the host VM can be connected to an existing VNET by passing the `vnetSubnetID` parameter--which can help with troubleshooting; otherwise, a new VNET is created.
- VHDX or ISO HCI OS source: the HCI node VMs are built with the Azure Stack HCI OS installed. The OS can be sourced from either a VHDX or an ISO file using either the `hciVHDXDownloadURL` or `hciISODownloadURL` parameters.

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

## Using this module

To use this Bicep module, you'll need to download a copy then supply values for the required parameters. Follow these steps:

1. Clone the repository with Git: `git clone https://github.com/Azure/bicep-registry-modules.git`
1. Navigate to this directory `avm\utilities\e2e-template-assets\templates\azure-stack-hci\modules\azureStackHCIHost` and review the parameters at the top of the `hciHostDeployment.bicep` file. Provide values as required by hardcoding them into the Bicep file or by building a parameters file.
1. Run the Bicep deployment. For example: `az deployment group create -f .\avm\utilities\e2e-template-assets\templates\azure-stack-hci\modules\azureStackHCIHost\hciHostDeployment.bicep`
1. When the deployment completes, the HCI nodes will be ready for an HCI cluster to be deployed on them. For example, you could use the Bicep module at this path `avm\res\azure-stack-hci\cluster\main.bicep` or using the Azure Portal.
