<#
.SYNOPSIS
Retrieve input parameter default values for a specified workflow.

.DESCRIPTION
Retrieve input parameter default values for a specified workflow. Return hashtable containing <parameterName,defaultValue> pairs.

.PARAMETER workflowPath
Mandatory. The path to the github workflow file.

.EXAMPLE
Get-GitHubWorkflowDefaultInput -workflowPath 'path/to/workflow' -verbose

Retrieve input parameter default values for the 'path/to/workflow' workflow.
#>
function Get-GitHubWorkflowDefaultInput {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $workflowPath
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        if (-not (Get-Module 'powershell-yaml' -ListAvailable)) {
            $null = Install-Module 'powershell-yaml' -Scope 'CurrentUser' -Force
        }
    }

    process {
        $workflowContent = Get-Content -Path $workflowPath -Raw
        $inputs = (ConvertFrom-Yaml -Yaml $workflowContent).on.workflow_dispatch.inputs

        $workflowParameters = @{}
        foreach ($inputName in $inputs.Keys) {
            $workflowParameters[$inputName] = $inputs[$inputName].default
        }

        Write-Verbose 'Get workflow default input complete'

        # Return hashtable
        return $workflowParameters
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
