<#
.SYNOPSIS
Get the formatted readme url

.DESCRIPTION

.PARAMETER ModuleRelativePath
Mandatory. The relative path of the module e.g. `avm/res/network/private-endpoint`

.EXAMPLE

`https://github.com/Azure/bicep-registry-modules/tree/${tag}/${ModuleRelativePath}/README.md`;

e.g. `https://github.com/Azure/bicep-registry-modules/tree/  avm-res-network-privateendpoint/1.0.0  /avm/res/network/private-endpoint/README.md`;

#>
