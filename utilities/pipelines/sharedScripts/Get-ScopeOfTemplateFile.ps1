<#
.SYNOPSIS
Get the scope of the given template file

.DESCRIPTION
Get the scope of the given template file (supports ARM & Bicep)
Will return either
- resourcegroup
- subscription
- managementgroup
- tenant

.PARAMETER TemplateFilePath
Mandatory. The path of the template file

.PARAMETER TemplateFileContent
Mandatory instead of TemplateFilePath. A parsed ARM template, including a nested deployment template.

.EXAMPLE
Get-ScopeOfTemplateFile -TemplateFilePath 'C:/main.json'

Get the scope of the given main.json template.
#>
function Get-ScopeOfTemplateFile {

    [CmdletBinding(DefaultParameterSetName = 'File')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'File')]
        [Alias('Path')]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $true, ParameterSetName = 'Content')]
        [hashtable] $TemplateFileContent
    )

    if ($PSCmdlet.ParameterSetName -eq 'File' -and (Split-Path $templateFilePath -Extension) -eq '.bicep') {
        # Bicep
        $bicepContent = Get-Content $templateFilePath -Raw
        $bicepScopeMatch = [regex]::Match($bicepContent, '(?m)^\s*targetScope\s*=\s*''(\S+)''')
        if (-not $bicepScopeMatch.Success) {
            $deploymentScope = 'resourcegroup'
        } else {
            $deploymentScope = $bicepScopeMatch.Captures.Groups[1].Value
        }
    } else {
        # ARM
        $armSchema = $PSCmdlet.ParameterSetName -eq 'Content' ? $TemplateFileContent.'$schema' : (ConvertFrom-Json (Get-Content -Raw -Path $templateFilePath)).'$schema'
        switch -regex ($armSchema) {
            '\/deploymentTemplate.json#$' { $deploymentScope = 'resourcegroup' }
            '\/subscriptionDeploymentTemplate.json#$' { $deploymentScope = 'subscription' }
            '\/managementGroupDeploymentTemplate.json#$' { $deploymentScope = 'managementgroup' }
            '\/tenantDeploymentTemplate.json#$' { $deploymentScope = 'tenant' }
            Default { throw "[$armSchema] is a non-supported ARM template schema" }
        }
    }
    Write-Verbose "Determined deployment scope [$deploymentScope]"

    return $deploymentScope
}
