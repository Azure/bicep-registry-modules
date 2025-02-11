<#
.SYNOPSIS
Run a template validation using a given parameter file

.DESCRIPTION
Run a template validation using a given parameter file
Works on a resource group, subscription, managementgroup and tenant level

.PARAMETER ParametersBasePath
Mandatory. The path to the root of the parameters folder to test with

.PARAMETER TemplateFilePath
Mandatory. Path to the template file from root.

.PARAMETER ParameterFilePath
Optional. Path to the parameter file from root.

.PARAMETER DeploymentMetadataLocation
Mandatory. The location to store the deployment metadata.

.PARAMETER ResourceGroupName
Optional. Name of the resource group to deploy into. Mandatory if deploying into a resource group (resource group level)

.PARAMETER SubscriptionId
Optional. ID of the subscription to deploy into. Mandatory if deploying into a subscription (subscription level) using a Management groups service connection

.PARAMETER ManagementGroupId
Optional. Name of the management group to deploy into. Mandatory if deploying into a management group (management group level)

.PARAMETER AdditionalParameters
Optional. Additional parameters you can provide with the deployment. E.g. @{ resourceGroupName = 'myResourceGroup' }

.PARAMETER RepoRoot
Optional. Path to the root of the repository.

.EXAMPLE
Test-TemplateDeployment -TemplateFilePath 'C:/key-vault/vault/main.bicep' -ParameterFilePath 'C:/key-vault/vault/.test/parameters.json' -DeploymentMetadataLocation 'WestEurope' -ResourceGroupName 'aLegendaryRg'

Test the main.bicep of the KeyVault module with the parameter file 'parameters.json' using the resource group 'aLegendaryRg' in location 'WestEurope'

.EXAMPLE
Test-TemplateDeployment -TemplateFilePath 'C:/key-vault/vault/main.bicep' -DeploymentMetadataLocation 'WestEurope' -ResourceGroupName 'aLegendaryRg'

Test the main.bicep of the KeyVault module using the resource group 'aLegendaryRg' in location 'WestEurope'

.EXAMPLE
Test-TemplateDeployment -TemplateFilePath 'C:/resources/resource-group/main.json' -ParameterFilePath 'C:/resources/resource-group/.test/parameters.json' -DeploymentMetadataLocation 'WestEurope'

Test the main.json of the ResourceGroup module with the parameter file 'parameters.json' in location 'WestEurope'
#>
function Test-TemplateDeployment {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $true)]
        [string] $DeploymentMetadataLocation,

        [Parameter(Mandatory = $false)]
        [string] $ParameterFilePath,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [string] $SubscriptionId,

        [Parameter(Mandatory = $false)]
        [string] $ManagementGroupId,

        [Parameter(Mandatory = $false)]
        [Hashtable] $AdditionalParameters,

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.parent.FullName
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper
        . (Join-Path $RepoRoot 'utilities' 'pipelines' 'sharedScripts' 'Get-ScopeOfTemplateFile.ps1')
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
            OutVariable  = 'ValidationErrors'
        }
        if (-not [String]::IsNullOrEmpty($ParameterFilePath)) {
            $DeploymentInputs['TemplateParameterFile'] = $ParameterFilePath
        }
        $ValidationErrors = $null

        # Additional parameter object provided yes/no
        if ($AdditionalParameters) {
            $DeploymentInputs += $AdditionalParameters
        }

        $deploymentScope = Get-ScopeOfTemplateFile -TemplateFilePath $TemplateFilePath -Verbose

        # Generate a valid deployment name. Must match ^[-\w\._\(\)]+$
        do {
            $deploymentName = ('{0}-{1}' -f $deploymentNamePrefix, (Get-Date -Format 'yyyyMMddTHHMMssffffZ'))[0..63] -join ''
        } while ($deploymentName -notmatch '^[-\w\._\(\)]+$')

        if ($deploymentScope -ne 'resourceGroup') {
            Write-Verbose "Testing with deployment name [$deploymentName]" -Verbose
            $DeploymentInputs['DeploymentName'] = $deploymentName
        }

        #################
        ## INVOKE TEST ##
        #################
        switch ($deploymentScope) {
            'resourceGroup' {
                if (-not [String]::IsNullOrEmpty($SubscriptionId)) {
                    Write-Verbose ('Setting context to subscription [{0}]' -f $SubscriptionId)
                    $null = Set-AzContext -Subscription $SubscriptionId
                }
                if (-not (Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction 'SilentlyContinue')) {
                    $resourceGroupLocation = $AdditionalParameters.resourceLocation ?? $DeploymentMetadataLocation
                    if ($PSCmdlet.ShouldProcess("Resource group [$ResourceGroupName] in location [$resourceGroupLocation]", 'Create')) {
                        $null = New-AzResourceGroup -Name $ResourceGroupName -Location $resourceGroupLocation
                    }
                }
                if ($PSCmdlet.ShouldProcess('Resource group level deployment', 'Test')) {
                    $res = Test-AzResourceGroupDeployment @DeploymentInputs -ResourceGroupName $ResourceGroupName
                }
                break
            }
            'subscription' {
                if (-not [String]::IsNullOrEmpty($SubscriptionId)) {
                    Write-Verbose ('Setting context to subscription [{0}]' -f $SubscriptionId)
                    $null = Set-AzContext -Subscription $SubscriptionId
                }
                if ($PSCmdlet.ShouldProcess('Subscription level deployment', 'Test')) {
                    $res = Test-AzSubscriptionDeployment @DeploymentInputs -Location $DeploymentMetadataLocation
                }
                break
            }
            'managementGroup' {
                if ($PSCmdlet.ShouldProcess('Management group level deployment', 'Test')) {
                    $res = Test-AzManagementGroupDeployment @DeploymentInputs -Location $DeploymentMetadataLocation -ManagementGroupId $ManagementGroupId
                }
                break
            }
            'tenant' {
                Write-Verbose 'Handling tenant level validation'
                if ($PSCmdlet.ShouldProcess('Tenant level deployment', 'Test')) {
                    $res = Test-AzTenantDeployment @DeploymentInputs -Location $DeploymentMetadataLocation
                }
                break
            }
            default {
                throw "[$deploymentScope] is a non-supported template scope"
            }
        }
        if ($ValidationErrors) {
            if ($res.Details) { Write-Warning ($res.Details | ConvertTo-Json -Depth 10 | Out-String) }
            if ($res.Message) { Write-Warning $res.Message }
            Write-Error 'Template is not valid.'
        } else {
            Write-Verbose 'Template is valid' -Verbose
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
