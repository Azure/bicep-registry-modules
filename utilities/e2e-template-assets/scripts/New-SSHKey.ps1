<#
.SYNOPSIS
Generate a new Public SSH Key or fetch it from an existing Public SSH Key resource.

.DESCRIPTION
Generate a new Public SSH Key or fetch it from an existing Public SSH Key resource.

.PARAMETER SSHKeyName
Mandatory. The name of the Public SSH Key Resource as it would be deployed in Azure

.PARAMETER ResourceGroupName
Mandatory. The resource group name of the Public SSH Key Resource as it would be deployed in Azure

.EXAMPLE
./New-SSHKey.ps1 -SSHKeyName 'myKeyResource' -ResourceGroupName 'ssh-rg'

Generate a new Public SSH Key or fetch it from an existing Public SSH Key resource 'myKeyResource' in Resource Group 'ssh-rg'
#>
param(
    [Parameter(Mandatory = $true)]
    [string] $SSHKeyName,

    [Parameter(Mandatory = $true)]
    [string] $ResourceGroupName
)

if (-not ($sshKey = Get-AzSshKey -ResourceGroupName $ResourceGroupName | Where-Object { $_.Name -eq $SSHKeyName })) {
    Write-Verbose "No SSH key [$SSHKeyName] found in Resource Group [$ResourceGroupName]. Generating new." -Verbose
    $null = ssh-keygen -f generated -N (Get-Random -Maximum 99999)
    $publicKey = Get-Content 'generated.pub' -Raw
    # $privateKey = cat generated | Out-String
} else {
    Write-Verbose "SSH key [$SSHKeyName] found in Resource Group [$ResourceGroupName]. Returning." -Verbose
    $publicKey = $sshKey.publicKey
}
# Write into Deployment Script output stream
$DeploymentScriptOutputs = @{
    # Requires conversion as the script otherwise returns an object instead of the plain public key string
    publicKey = $publicKey | Out-String
}
