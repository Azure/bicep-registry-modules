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
            $deployments = Get-AzResourceGroupDeploymentOperation -DeploymentName $deploymentName -ResourceGroupName $ResourceGroupName
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

.PARAMETER TemplateFilePath
Mandatory. The path to the deployment file

.PARAMETER ParameterFilePath
Optional. Path to the parameter file from root. Can be a single file, multiple files, or directory that contains (.json) files.

.PARAMETER DeploymentMetadataLocation
Mandatory. The location to store the deployment metadata.

.PARAMETER ResourceGroupName
Optional. Name of the resource group to deploy into. Mandatory if deploying into a resource group (resource group level)

.PARAMETER SubscriptionId
Optional. ID of the subscription to deploy into. Mandatory if deploying into a subscription (subscription level) using a Management groups service connection

.PARAMETER ManagementGroupId
Optional. Name of the management group to deploy into. Mandatory if deploying into a management group (management group level)

.PARAMETER AdditionalTags
Optional. Provde a Key Value Pair (Object) that will be appended to the Parameter file tags. Example: @{myKey = 'myValue',myKey2 = 'myValue2'}.

.PARAMETER AdditionalParameters
Optional. Additional parameters you can provide with the deployment. E.g. @{ resourceGroupName = 'myResourceGroup' }

.PARAMETER RetryLimit
Optional. Maximum retry limit if the deployment fails. Default is 3.

.PARAMETER DoNotThrow
Optional. Do not throw an exception if it failed. Still returns the error message though

.PARAMETER RepoRoot
Mandatory. Path to the root of the repository.

.EXAMPLE
New-TemplateDeploymentInner -TemplateFilePath 'C:/key-vault/vault/main.json' -ParameterFilePath 'C:/key-vault/vault/.test/parameters.json' -DeploymentMetadataLocation 'WestEurope' -ResourceGroupName 'aLegendaryRg'

Deploy the main.json of the KeyVault module with the parameter file 'parameters.json' using the resource group 'aLegendaryRg' in location 'WestEurope'

.EXAMPLE
New-TemplateDeploymentInner -TemplateFilePath 'C:/key-vault/vault/main.bicep' -DeploymentMetadataLocation 'WestEurope' -ResourceGroupName 'aLegendaryRg'

Deploy the main.bicep of the KeyVault module using the resource group 'aLegendaryRg' in location 'WestEurope'

.EXAMPLE
New-TemplateDeploymentInner -TemplateFilePath 'C:/resources/resource-group/main.json' -DeploymentMetadataLocation 'WestEurope'

Deploy the main.json of the ResourceGroup module without a parameter file in location 'WestEurope'
#>
function New-TemplateDeploymentInner {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [string] $ParameterFilePath,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName = '',

        [Parameter(Mandatory = $true)]
        [string] $DeploymentMetadataLocation,

        [Parameter(Mandatory = $false)]
        [string] $SubscriptionId,

        [Parameter(Mandatory = $false)]
        [string] $ManagementGroupId,

        [Parameter(Mandatory = $false)]
        [PSCustomObject] $AdditionalTags,

        [Parameter(Mandatory = $false)]
        [Hashtable] $AdditionalParameters,

        [Parameter(Mandatory = $false)]
        [switch] $DoNotThrow,

        [Parameter(Mandatory = $false)]
        [int] $RetryLimit = 3,

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {
        $deploymentNamePrefix = Split-Path -Path (Split-Path $TemplateFilePath -Parent) -LeafBase
        if ([String]::IsNullOrEmpty($deploymentNamePrefix)) {
            $deploymentNamePrefix = 'templateDeployment-{0}' -f (Split-Path $TemplateFilePath -LeafBase)
        }

        # Convert, e.g., [C:\myFork\avm\res\kubernetes-configuration\flux-configuration\tests\e2e\defaults\main.test.bicep] to [a-r-kc-fc-defaults]
        $shortPathElems = ((Split-Path $TemplateFilePath) -replace ('{0}[\\|\/]' -f [regex]::Escape($repoRoot))) -split '[\\|\/]' | Where-Object { $_ -notin @('tests', 'e2e') }
        # Shorten all elements but the last
        $reducedElem = $shortPathElems[0 .. ($shortPathElems.Count - 2)] | ForEach-Object {
            $shortPathElem = $_
            if ($shortPathElem -match '-') {
                ($shortPathElem -split '-' | ForEach-Object { $_[0] }) -join ''
            } else {
                $shortPathElem[0]
            }
        }
        # Add the last back and join the elements together
        $deploymentNamePrefix = ($reducedElem + @($shortPathElems[-1])) -join '-'

        $DeploymentInputs = @{
            TemplateFile = $TemplateFilePath
            Verbose      = $true
            ErrorAction  = 'Stop'
        }

        # Parameter file provided yes/no
        if (-not [String]::IsNullOrEmpty($ParameterFilePath)) {
            $DeploymentInputs['TemplateParameterFile'] = $ParameterFilePath
        }

        # Additional parameter object provided yes/no
        if ($AdditionalParameters) {
            $DeploymentInputs += $AdditionalParameters
        }

        # Additional tags provides yes/no
        # Append tags to parameters if resource supports them (all tags must be in one object)
        if ($AdditionalTags) {

            # Parameter tags
            if (-not [String]::IsNullOrEmpty($ParameterFilePath)) {
                $parameterFileTags = (ConvertFrom-Json (Get-Content -Raw -Path $ParameterFilePath) -AsHashtable).parameters.tags.value
            }
            if (-not $parameterFileTags) { $parameterFileTags = @{} }

            # Pipeline tags
            if ($AdditionalTags) { $parameterFileTags += $AdditionalTags } # If additionalTags object is provided, append tag to the resource

            # Overwrites parameter file tags parameter
            Write-Verbose ("additionalTags: $(($AdditionalTags) ? ($AdditionalTags | ConvertTo-Json) : '[]')")
            $DeploymentInputs += @{Tags = $parameterFileTags }
        }

        #######################
        ## INVOKE DEPLOYMENT ##
        #######################
        $deploymentScope = Get-ScopeOfTemplateFile -TemplateFilePath $TemplateFilePath
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
                        if (-not [String]::IsNullOrEmpty($SubscriptionId)) {
                            Write-Verbose ('Setting context to subscription [{0}]' -f $SubscriptionId)
                            $null = Set-AzContext -Subscription $SubscriptionId
                        }
                        if (-not (Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction 'SilentlyContinue')) {
                            $resourceGroupLocation = $AdditionalParameters.resourceLocation ?? $DeploymentMetadataLocation
                            if ($PSCmdlet.ShouldProcess("Resource group [$ResourceGroupName] in (metadata) location [$resourceGroupLocation]", 'Create')) {
                                $null = New-AzResourceGroup -Name $ResourceGroupName -Location $resourceGroupLocation
                            }
                        }
                        if ($PSCmdlet.ShouldProcess('Resource group level deployment', 'Create')) {
                            $res = New-AzResourceGroupDeployment @DeploymentInputs -ResourceGroupName $ResourceGroupName
                        }
                        break
                    }
                    'subscription' {
                        if (-not [String]::IsNullOrEmpty($SubscriptionId)) {
                            Write-Verbose ('Setting context to subscription [{0}]' -f $SubscriptionId)
                            $null = Set-AzContext -Subscription $SubscriptionId
                        }
                        if ($PSCmdlet.ShouldProcess('Subscription level deployment', 'Create')) {
                            $res = New-AzSubscriptionDeployment @DeploymentInputs -Location $DeploymentMetadataLocation
                        }
                        break
                    }
                    'managementgroup' {
                        if ($PSCmdlet.ShouldProcess('Management group level deployment', 'Create')) {
                            $res = New-AzManagementGroupDeployment @DeploymentInputs -Location $DeploymentMetadataLocation -ManagementGroupId $ManagementGroupId
                        }
                        break
                    }
                    'tenant' {
                        if ($PSCmdlet.ShouldProcess('Tenant level deployment', 'Create')) {
                            $res = New-AzTenantDeployment @DeploymentInputs -Location $DeploymentMetadataLocation
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
                        ResourceGroupName = $ResourceGroupName
                    }
                    $exceptionMessage = Get-ErrorMessageForScope @errorInputObject

                    throw "Deployed failed with provisioning state [Failed]. Error Message: [$exceptionMessage]. Please review the Azure logs of deployment [$deploymentName] in scope [$deploymentScope] for further details."
                }
                $Stoploop = $true
            } catch {
                if ($retryCount -ge $RetryLimit) {
                    if ($DoNotThrow) {

                        # In case a deployment failes but not throws an exception (i.e. the exception message is empty) we try to fetch it via the deployment name
                        if ([String]::IsNullOrEmpty($PSitem.Exception.Message)) {
                            $errorInputObject = @{
                                DeploymentScope   = $deploymentScope
                                DeploymentName    = $deploymentName
                                ResourceGroupName = $ResourceGroupName
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
                    Write-Verbose "Resource deployment Failed.. ($retryCount/$RetryLimit) Retrying in 5 Seconds.. `n"
                    Write-Verbose ($PSitem.Exception.Message | Out-String) -Verbose
                    Start-Sleep -Seconds 5
                    $retryCount++
                }
            }
        }
        until ($Stoploop -eq $true -or $retryCount -gt $RetryLimit)

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

.PARAMETER TemplateFilePath
Mandatory. The path to the deployment file

.PARAMETER ParameterFilePath
Optional. Path to the parameter file from root. Can be a single file, multiple files, or directory that contains (.json) files.

.PARAMETER DeploymentMetadataLocation
Mandatory. The location to store the deployment metadata.

.PARAMETER ResourceGroupName
Optional. Name of the resource group to deploy into. Mandatory if deploying into a resource group (resource group level)

.PARAMETER SubscriptionId
Optional. ID of the subscription to deploy into. Mandatory if deploying into a subscription (subscription level) using a Management groups service connection

.PARAMETER ManagementGroupId
Optional. Name of the management group to deploy into. Mandatory if deploying into a management group (management group level)

.PARAMETER AdditionalTags
Optional. Provide a Key Value Pair (Object) that will be appended to the Parameter file tags. Example: @{myKey = 'myValue', myKey2 = 'myValue2'}.

.PARAMETER AdditionalParameters
Optional. Additional parameters you can provide with the deployment. E.g. @{ resourceGroupName = 'myResourceGroup' }

.PARAMETER RetryLimit
Optional. Maximum retry limit if the deployment fails. Default is 3.

.PARAMETER DoNotThrow
Optional. Do not throw an exception if it failed. Still returns the error message though

.PARAMETER RepoRoot
Optional. Path to the root of the repository.

.EXAMPLE
New-TemplateDeployment -TemplateFilePath 'C:/key-vault/vault/main.bicep' -ParameterFilePath 'C:/key-vault/vault/.test/parameters.json' -DeploymentMetadataLocation 'WestEurope' -ResourceGroupName 'aLegendaryRg'

Deploy the main.bicep of the 'key-vault/vault' module with the parameter file 'parameters.json' using the resource group 'aLegendaryRg' in location 'WestEurope'

.EXAMPLE
New-TemplateDeployment -TemplateFilePath 'C:/resources/resource-group/main.bicep' -DeploymentMetadataLocation 'WestEurope'

Deploy the main.bicep of the 'resources/resource-group' module in location 'WestEurope' without a parameter file

.EXAMPLE
New-TemplateDeployment -TemplateFilePath 'C:/resources/resource-group/main.json' -ParameterFilePath 'C:/resources/resource-group/.test/parameters.json' -DeploymentMetadataLocation 'WestEurope'

Deploy the main.json of the 'resources/resource-group' module with the parameter file 'parameters.json' in location 'WestEurope'
#>
function New-TemplateDeployment {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $true)]
        [string] $DeploymentMetadataLocation,

        [Parameter(Mandatory = $false)]
        [string[]] $ParameterFilePath,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName = '',

        [Parameter(Mandatory = $false)]
        [string] $SubscriptionId,

        [Parameter(Mandatory = $false)]
        [string] $ManagementGroupId,

        [Parameter(Mandatory = $false)]
        [Hashtable] $AdditionalParameters,

        [Parameter(Mandatory = $false)]
        [PSCustomObject] $AdditionalTags,

        [Parameter(Mandatory = $false)]
        [switch] $DoNotThrow,

        [Parameter(Mandatory = $false)]
        [int] $RetryLimit = 3,

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.parent.FullName
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper functions
        . (Join-Path $repoRoot 'utilities' 'pipelines' 'sharedScripts' 'Get-ScopeOfTemplateFile.ps1')
    }

    process {
        ## Assess Provided Parameter Path
        if ((-not [String]::IsNullOrEmpty($ParameterFilePath)) -and (Test-Path -Path $ParameterFilePath -PathType 'Container') -and $ParameterFilePath.Length -eq 1) {
            ## Transform Path to Files
            $ParameterFilePath = Get-ChildItem $ParameterFilePath -Recurse -Filter *.json | Select-Object -ExpandProperty FullName
            Write-Verbose "Detected Parameter File(s)/Directory - Count: `n $($ParameterFilePath.Count)"
        }

        ## Iterate through each file
        $deploymentInputObject = @{
            TemplateFilePath           = $TemplateFilePath
            AdditionalTags             = $AdditionalTags
            AdditionalParameters       = $AdditionalParameters
            DeploymentMetadataLocation = $DeploymentMetadataLocation
            ResourceGroupName          = $ResourceGroupName
            SubscriptionId             = $SubscriptionId
            ManagementGroupId          = $ManagementGroupId
            DoNotThrow                 = $DoNotThrow
            RetryLimit                 = $RetryLimit
            RepoRoot                   = $RepoRoot
        }
        if ($ParameterFilePath) {
            if ($ParameterFilePath -is [array]) {
                $deploymentResult = [System.Collections.ArrayList]@()
                foreach ($path in $ParameterFilePath) {
                    if ($PSCmdlet.ShouldProcess("Deployment for parameter file [$ParameterFilePath]", 'Trigger')) {
                        $deploymentResult += New-TemplateDeploymentInner @deploymentInputObject -ParameterFilePath $path
                    }
                }
                return $deploymentResult
            } else {
                if ($PSCmdlet.ShouldProcess("Deployment for single parameter file [$ParameterFilePath]", 'Trigger')) {
                    return New-TemplateDeploymentInner @deploymentInputObject -ParameterFilePath $ParameterFilePath
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
