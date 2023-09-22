#region helper

<#
.SYNOPSIS
If a deployment failed, get its error message

.DESCRIPTION
If a deployment failed, get its error message based on the deployment name in the given scope

.PARAMETER DeploymentScope
Mandatory. The scope to fetch the deployment from (e.g. resourcegroup, tenant,...)

.PARAMETER DeploymentName
Mandatory. The name of the deployment to search for (e.g. 'storageAccounts-20220105T0701282538Z')

.PARAMETER ResourceGroupName
Optional. The resource group to search the deployment in, if the scope is 'resourcegroup'

.EXAMPLE
Get-ErrorMessageForScope -DeploymentScope 'resourcegroup' -DeploymentName 'storageAccounts-20220105T0701282538Z' -ResourceGroupName 'validation-rg'

Get the error message of any failed deployment into resource group 'validation-rg' that has the name 'storageAccounts-20220105T0701282538Z'

.EXAMPLE
Get-ErrorMessageForScope -DeploymentScope 'subscription' -DeploymentName 'resourcegroups-20220106T0401282538Z'

Get the error message of any failed deployment into the current subscription that has the name 'storageAccounts-20220105T0701282538Z'
#>
function Get-ErrorMessageForScope {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $DeploymentScope,

        [Parameter(Mandatory)]
        [string] $DeploymentName,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName = ''
    )

    switch ($deploymentScope) {
        'resourcegroup' {
            $deployments = Get-AzResourceGroupDeploymentOperation -DeploymentName $deploymentName -ResourceGroupName $resourceGroupName
            break
        }
        'subscription' {
            $deployments = Get-AzDeploymentOperation -DeploymentName $deploymentName
            break
        }
        'managementgroup' {
            $deployments = Get-AzManagementGroupDeploymentOperation -DeploymentName $deploymentName
            break
        }
        'tenant' {
            $deployments = Get-AzTenantDeploymentOperation -DeploymentName $deploymentName
            break
        }
    }
    if ($deployments) {
        return ($deployments | Where-Object { $_.ProvisioningState -ne 'Succeeded' }).StatusMessage
    }
}

<#
.SYNOPSIS
Run a template deployment using a given parameter file

.DESCRIPTION
Run a template deployment using a given parameter file.
Works on a resource group, subscription, managementgroup and tenant level

.PARAMETER templateFilePath
Mandatory. The path to the deployment file

.PARAMETER parameterFilePath
Optional. Path to the parameter file from root. Can be a single file, multiple files, or directory that contains (.json) files.

.PARAMETER location
Mandatory. Location to test in. E.g. WestEurope

.PARAMETER resourceGroupName
Optional. Name of the resource group to deploy into. Mandatory if deploying into a resource group (resource group level)

.PARAMETER subscriptionId
Optional. ID of the subscription to deploy into. Mandatory if deploying into a subscription (subscription level) using a Management groups service connection

.PARAMETER managementGroupId
Optional. Name of the management group to deploy into. Mandatory if deploying into a management group (management group level)

.PARAMETER additionalTags
Optional. Provde a Key Value Pair (Object) that will be appended to the Parameter file tags. Example: @{myKey = 'myValue',myKey2 = 'myValue2'}.

.PARAMETER additionalParameters
Optional. Additional parameters you can provide with the deployment. E.g. @{ resourceGroupName = 'myResourceGroup' }

.PARAMETER retryLimit
Optional. Maximum retry limit if the deployment fails. Default is 3.

.PARAMETER doNotThrow
Optional. Do not throw an exception if it failed. Still returns the error message though

.EXAMPLE
New-TemplateDeploymentInner -templateFilePath 'C:/key-vault/vault/main.json' -parameterFilePath 'C:/key-vault/vault/.test/parameters.json' -location 'WestEurope' -resourceGroupName 'aLegendaryRg'

Deploy the main.json of the KeyVault module with the parameter file 'parameters.json' using the resource group 'aLegendaryRg' in location 'WestEurope'

.EXAMPLE
New-TemplateDeploymentInner -templateFilePath 'C:/key-vault/vault/main.bicep' -location 'WestEurope' -resourceGroupName 'aLegendaryRg'

Deploy the main.bicep of the KeyVault module using the resource group 'aLegendaryRg' in location 'WestEurope'

.EXAMPLE
New-TemplateDeploymentInner -templateFilePath 'C:/resources/resource-group/main.json' -location 'WestEurope'

Deploy the main.json of the ResourceGroup module without a parameter file in location 'WestEurope'
#>
function New-TemplateDeploymentInner {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory)]
        [string] $templateFilePath,

        [Parameter(Mandatory = $false)]
        [string] $parameterFilePath,

        [Parameter(Mandatory = $false)]
        [string] $resourceGroupName = '',

        [Parameter(Mandatory)]
        [string] $location,

        [Parameter(Mandatory = $false)]
        [string] $subscriptionId,

        [Parameter(Mandatory = $false)]
        [string] $managementGroupId,

        [Parameter(Mandatory = $false)]
        [PSCustomObject] $additionalTags,

        [Parameter(Mandatory = $false)]
        [Hashtable] $additionalParameters,

        [Parameter(Mandatory = $false)]
        [switch] $doNotThrow,

        [Parameter(Mandatory = $false)]
        [int]$retryLimit = 3
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper
        . (Join-Path (Get-Item -Path $PSScriptRoot).parent.FullName 'sharedScripts' 'Get-ScopeOfTemplateFile.ps1')
    }

    process {
        $deploymentNamePrefix = Split-Path -Path (Split-Path $templateFilePath -Parent) -LeafBase
        if ([String]::IsNullOrEmpty($deploymentNamePrefix)) {
            $deploymentNamePrefix = 'templateDeployment-{0}' -f (Split-Path $templateFilePath -LeafBase)
        }

        $modulesRegex = '.+[\\|\/]modules[\\|\/]'
        if ($templateFilePath -match $modulesRegex) {
            # If we can assume we're operating in a module structure, we can further fetch the provider namespace & resource type
            $shortPathElem = (($templateFilePath -split $modulesRegex)[1] -replace '\\', '/') -split '/' # e.g., app-configuration, configuration-store, .test, common, main.test.bicep
            $providerNamespace = $shortPathElem[0] # e.g., app-configuration
            $providerNamespaceShort = ($providerNamespace -split '-' | ForEach-Object { $_[0] }) -join '' # e.g., ac

            $resourceType = $shortPathElem[1] # e.g., configuration-store
            $resourceTypeShort = ($resourceType -split '-' | ForEach-Object { $_[0] }) -join '' # e.g. cs

            $testFolderShort = Split-Path (Split-Path $templateFilePath -Parent) -Leaf  # e.g., common

            $deploymentNamePrefix = "$providerNamespaceShort-$resourceTypeShort-$testFolderShort" # e.g., ac-cs-common
        }

        $DeploymentInputs = @{
            TemplateFile = $templateFilePath
            Verbose      = $true
            ErrorAction  = 'Stop'
        }

        # Parameter file provided yes/no
        if (-not [String]::IsNullOrEmpty($parameterFilePath)) {
            $DeploymentInputs['TemplateParameterFile'] = $parameterFilePath
        }

        # Additional parameter object provided yes/no
        if ($additionalParameters) {
            $DeploymentInputs += $additionalParameters
        }

        # Additional tags provides yes/no
        # Append tags to parameters if resource supports them (all tags must be in one object)
        if ($additionalTags) {

            # Parameter tags
            if (-not [String]::IsNullOrEmpty($parameterFilePath)) {
                $parameterFileTags = (ConvertFrom-Json (Get-Content -Raw -Path $parameterFilePath) -AsHashtable).parameters.tags.value
            }
            if (-not $parameterFileTags) { $parameterFileTags = @{} }

            # Pipeline tags
            if ($additionalTags) { $parameterFileTags += $additionalTags } # If additionalTags object is provided, append tag to the resource

            # Overwrites parameter file tags parameter
            Write-Verbose ("additionalTags: $(($additionalTags) ? ($additionalTags | ConvertTo-Json) : '[]')")
            $DeploymentInputs += @{Tags = $parameterFileTags }
        }

        #######################
        ## INVOKE DEPLOYMENT ##
        #######################
        $deploymentScope = Get-ScopeOfTemplateFile -TemplateFilePath $templateFilePath
        [bool]$Stoploop = $false
        [int]$retryCount = 1
        $usedDeploymentNames = @()

        do {
            # Generate a valid deployment name. Must match ^[-\w\._\(\)]+$
            do {
                $deploymentName = ('{0}-t{1}-{2}' -f $deploymentNamePrefix, $retryCount, (Get-Date -Format 'yyyyMMddTHHMMssffffZ'))[0..63] -join ''
            } while ($deploymentName -notmatch '^[-\w\._\(\)]+$')

            Write-Verbose "Deploying with deployment name [$deploymentName]" -Verbose
            $usedDeploymentNames += $deploymentName
            $DeploymentInputs['DeploymentName'] = $deploymentName

            try {
                switch ($deploymentScope) {
                    'resourcegroup' {
                        if (-not [String]::IsNullOrEmpty($subscriptionId)) {
                            Write-Verbose ('Setting context to subscription [{0}]' -f $subscriptionId)
                            $null = Set-AzContext -Subscription $subscriptionId
                        }
                        if (-not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction 'SilentlyContinue')) {
                            if ($PSCmdlet.ShouldProcess("Resource group [$resourceGroupName] in location [$location]", 'Create')) {
                                $null = New-AzResourceGroup -Name $resourceGroupName -Location $location
                            }
                        }
                        if ($PSCmdlet.ShouldProcess('Resource group level deployment', 'Create')) {
                            $res = New-AzResourceGroupDeployment @DeploymentInputs -ResourceGroupName $resourceGroupName
                        }
                        break
                    }
                    'subscription' {
                        if (-not [String]::IsNullOrEmpty($subscriptionId)) {
                            Write-Verbose ('Setting context to subscription [{0}]' -f $subscriptionId)
                            $null = Set-AzContext -Subscription $subscriptionId
                        }
                        if ($PSCmdlet.ShouldProcess('Subscription level deployment', 'Create')) {
                            $res = New-AzSubscriptionDeployment @DeploymentInputs -Location $location
                        }
                        break
                    }
                    'managementgroup' {
                        if ($PSCmdlet.ShouldProcess('Management group level deployment', 'Create')) {
                            $res = New-AzManagementGroupDeployment @DeploymentInputs -Location $location -ManagementGroupId $managementGroupId
                        }
                        break
                    }
                    'tenant' {
                        if ($PSCmdlet.ShouldProcess('Tenant level deployment', 'Create')) {
                            $res = New-AzTenantDeployment @DeploymentInputs -Location $location
                        }
                        break
                    }
                    default {
                        throw "[$deploymentScope] is a non-supported template scope"
                        $Stoploop = $true
                    }
                }
                if ($res.ProvisioningState -eq 'Failed') {
                    # Deployment failed but no exception was thrown. Hence we must do it for the command.

                    $errorInputObject = @{
                        DeploymentScope   = $deploymentScope
                        DeploymentName    = $deploymentName
                        ResourceGroupName = $resourceGroupName
                    }
                    $exceptionMessage = Get-ErrorMessageForScope @errorInputObject

                    throw "Deployed failed with provisioning state [Failed]. Error Message: [$exceptionMessage]. Please review the Azure logs of deployment [$deploymentName] in scope [$deploymentScope] for further details."
                }
                $Stoploop = $true
            } catch {
                if ($retryCount -ge $retryLimit) {
                    if ($doNotThrow) {

                        # In case a deployment failes but not throws an exception (i.e. the exception message is empty) we try to fetch it via the deployment name
                        if ([String]::IsNullOrEmpty($PSitem.Exception.Message)) {
                            $errorInputObject = @{
                                DeploymentScope   = $deploymentScope
                                DeploymentName    = $deploymentName
                                ResourceGroupName = $resourceGroupName
                            }
                            $exceptionMessage = Get-ErrorMessageForScope @errorInputObject
                        } else {
                            $exceptionMessage = $PSitem.Exception.Message
                        }

                        return @{
                            DeploymentNames = $usedDeploymentNames
                            Exception       = $exceptionMessage
                        }
                    } else {
                        throw $PSitem.Exception.Message
                    }
                    $Stoploop = $true
                } else {
                    Write-Verbose "Resource deployment Failed.. ($retryCount/$retryLimit) Retrying in 5 Seconds.. `n"
                    Write-Verbose ($PSitem.Exception.Message | Out-String) -Verbose
                    Start-Sleep -Seconds 5
                    $retryCount++
                }
            }
        }
        until ($Stoploop -eq $true -or $retryCount -gt $retryLimit)

        Write-Verbose 'Result' -Verbose
        Write-Verbose '------' -Verbose
        Write-Verbose ($res | Out-String) -Verbose
        return @{
            DeploymentNames  = $usedDeploymentNames
            DeploymentOutput = $res.Outputs
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
#endregion

<#
.SYNOPSIS
Run a template deployment using a given parameter file

.DESCRIPTION
Run a template deployment using a given parameter file.
Works on a resource group, subscription, managementgroup and tenant level

.PARAMETER templateFilePath
Mandatory. The path to the deployment file

.PARAMETER parameterFilePath
Optional. Path to the parameter file from root. Can be a single file, multiple files, or directory that contains (.json) files.

.PARAMETER location
Mandatory. Location to test in. E.g. WestEurope

.PARAMETER resourceGroupName
Optional. Name of the resource group to deploy into. Mandatory if deploying into a resource group (resource group level)

.PARAMETER subscriptionId
Optional. ID of the subscription to deploy into. Mandatory if deploying into a subscription (subscription level) using a Management groups service connection

.PARAMETER managementGroupId
Optional. Name of the management group to deploy into. Mandatory if deploying into a management group (management group level)

.PARAMETER additionalTags
Optional. Provide a Key Value Pair (Object) that will be appended to the Parameter file tags. Example: @{myKey = 'myValue', myKey2 = 'myValue2'}.

.PARAMETER additionalParameters
Optional. Additional parameters you can provide with the deployment. E.g. @{ resourceGroupName = 'myResourceGroup' }

.PARAMETER retryLimit
Optional. Maximum retry limit if the deployment fails. Default is 3.

.PARAMETER doNotThrow
Optional. Do not throw an exception if it failed. Still returns the error message though

.EXAMPLE
New-TemplateDeployment -templateFilePath 'C:/key-vault/vault/main.bicep' -parameterFilePath 'C:/key-vault/vault/.test/parameters.json' -location 'WestEurope' -resourceGroupName 'aLegendaryRg'

Deploy the main.bicep of the 'key-vault/vault' module with the parameter file 'parameters.json' using the resource group 'aLegendaryRg' in location 'WestEurope'

.EXAMPLE
New-TemplateDeployment -templateFilePath 'C:/resources/resource-group/main.bicep' -location 'WestEurope'

Deploy the main.bicep of the 'resources/resource-group' module in location 'WestEurope' without a parameter file

.EXAMPLE
New-TemplateDeployment -templateFilePath 'C:/resources/resource-group/main.json' -parameterFilePath 'C:/resources/resource-group/.test/parameters.json' -location 'WestEurope'

Deploy the main.json of the 'resources/resource-group' module with the parameter file 'parameters.json' in location 'WestEurope'
#>
function New-TemplateDeployment {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $templateFilePath,

        [Parameter(Mandatory = $false)]
        [string[]] $parameterFilePath,

        [Parameter(Mandatory)]
        [string] $location,

        [Parameter(Mandatory = $false)]
        [string] $resourceGroupName = '',

        [Parameter(Mandatory = $false)]
        [string] $subscriptionId,

        [Parameter(Mandatory = $false)]
        [string] $managementGroupId,

        [Parameter(Mandatory = $false)]
        [Hashtable] $additionalParameters,

        [Parameter(Mandatory = $false)]
        [PSCustomObject] $additionalTags,

        [Parameter(Mandatory = $false)]
        [switch] $doNotThrow,

        [Parameter(Mandatory = $false)]
        [int]$retryLimit = 3
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {
        ## Assess Provided Parameter Path
        if ((-not [String]::IsNullOrEmpty($parameterFilePath)) -and (Test-Path -Path $parameterFilePath -PathType 'Container') -and $parameterFilePath.Length -eq 1) {
            ## Transform Path to Files
            $parameterFilePath = Get-ChildItem $parameterFilePath -Recurse -Filter *.json | Select-Object -ExpandProperty FullName
            Write-Verbose "Detected Parameter File(s)/Directory - Count: `n $($parameterFilePath.Count)"
        }

        ## Iterate through each file
        $deploymentInputObject = @{
            templateFilePath     = $templateFilePath
            additionalTags       = $additionalTags
            additionalParameters = $additionalParameters
            location             = $location
            resourceGroupName    = $resourceGroupName
            subscriptionId       = $subscriptionId
            managementGroupId    = $managementGroupId
            doNotThrow           = $doNotThrow
            retryLimit           = $retryLimit
        }
        if ($parameterFilePath) {
            if ($parameterFilePath -is [array]) {
                $deploymentResult = [System.Collections.ArrayList]@()
                foreach ($path in $parameterFilePath) {
                    if ($PSCmdlet.ShouldProcess("Deployment for parameter file [$parameterFilePath]", 'Trigger')) {
                        $deploymentResult += New-TemplateDeploymentInner @deploymentInputObject -parameterFilePath $path
                    }
                }
                return $deploymentResult
            } else {
                if ($PSCmdlet.ShouldProcess("Deployment for single parameter file [$parameterFilePath]", 'Trigger')) {
                    return New-TemplateDeploymentInner @deploymentInputObject -parameterFilePath $parameterFilePath
                }
            }
        } else {
            if ($PSCmdlet.ShouldProcess('Deployment without parameter file', 'Trigger')) {
                return New-TemplateDeploymentInner @deploymentInputObject
            }
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
