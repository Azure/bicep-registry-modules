<#
.SYNOPSIS
Create image artifacts from a given image template

.DESCRIPTION
Create image artifacts and wait for the submitted build to succeed. The wait uses the template's build timeout, plus five minutes for its final status.
Post-submission status reads can recover from a transport connection reset at most twice within the same deadline, without resubmitting the build.

.PARAMETER ImageTemplateName
Mandatory. The name of the image template

.PARAMETER ImageTemplateResourceGroup
Mandatory. The resource group name of the image template

.PARAMETER NoWait
Optional. Run the command asynchronously

.EXAMPLE
./Start-ImageTemplate -ImageTemplateName 'vhd-img-template-001-2022-07-29-15-54-01' -ImageTemplateResourceGroup 'validation-rg'

Create image artifacts from image template 'vhd-img-template-001-2022-07-29-15-54-01' in resource group 'validation-rg' and wait for their completion

.EXAMPLE
./Start-ImageTemplate -ImageTemplateName 'vhd-img-template-001-2022-07-29-15-54-01' -ImageTemplateResourceGroup 'validation-rg' -NoWait

Start the creation of artifacts from image template 'vhd-img-template-001-2022-07-29-15-54-01' in resource group 'validation-rg' and do not wait for their completion
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $true)]
    [string] $ImageTemplateName,

    [Parameter(Mandatory = $true)]
    [string] $ImageTemplateResourceGroup,

    [Parameter(Mandatory = $false)]
    [switch] $NoWait
)

begin {
    Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

    # Install required modules
    $currentVerbosePreference = $VerbosePreference
    $VerbosePreference = 'SilentlyContinue'
    $requiredModules = @(
        @{ Name = 'Az.ImageBuilder'; Version = '0.4.0' }
    )
    foreach ($module in $requiredModules) {
        $installationInput = @{
            Name       = $module.Name
            Repository = 'PSGallery'
            Scope      = 'CurrentUser'
            Force      = $true
        }
        if ($Module.Version) {
            $installationInput['RequiredVersion'] = $module.Version
        }
        Install-Module @installationInput

        if ($installed = Get-Module -Name $module.Name -ListAvailable) {
            Write-Verbose ('Installed module [{0}] with version [{1}]' -f $installed.Name, $installed.Version) -Verbose
        }
    }
    $VerbosePreference = $currentVerbosePreference
}

process {
    # Create image artifacts from existing image template
    $templateInputObject = @{
        ImageTemplateName = $imageTemplateName
        ResourceGroupName = $imageTemplateResourceGroup
        ErrorAction       = 'Stop'
    }
    $resourceActionInputObject = $templateInputObject.Clone()
    $resourceActionInputObject['NoWait'] = $true

    if ($PSCmdlet.ShouldProcess('Image template [{0}]' -f $imageTemplateName, 'Start')) {
        if (-not $NoWait) {
            $imageTemplates = @(Get-AzImageBuilderTemplate @templateInputObject)
            if ($imageTemplates.Count -ne 1) {
                throw ('Expected exactly one image template [{0}] in resource group [{1}].' -f $imageTemplateName, $imageTemplateResourceGroup)
            }
            $imageTemplate = $imageTemplates[0]
            $previousRunStartTime = if ($imageTemplate.LastRunStatusStartTime) { [datetime] $imageTemplate.LastRunStatusStartTime } else { [datetime]::MinValue }
            $buildTimeoutInMinutes = [int] $imageTemplate.BuildTimeoutInMinute
            if ($buildTimeoutInMinutes -lt 0) {
                throw ('Image template [{0}] has an invalid build timeout [{1}].' -f $imageTemplateName, $buildTimeoutInMinutes)
            }
            if ($buildTimeoutInMinutes -eq 0) {
                $buildTimeoutInMinutes = 240
            }
            $waitTimeoutInMinutes = $buildTimeoutInMinutes + 5
            $deadline = (Get-Date).ToUniversalTime().AddMinutes($waitTimeoutInMinutes)
        }

        $null = Start-AzImageBuilderTemplate @resourceActionInputObject
        if ($NoWait) {
            Write-Verbose ('Started creation of image artifacts from image template [{0}] in resource group [{1}]' -f $imageTemplateName, $imageTemplateResourceGroup) -Verbose
        } else {
            $runSucceeded = $false
            $lastReportedState = $null
            $submittedRunStartTime = $null
            $statusReadRecoveryCount = 0
            $maxStatusReadRecoveries = 2
            while ((Get-Date).ToUniversalTime() -lt $deadline) {
                try {
                    $imageTemplates = @(Get-AzImageBuilderTemplate @templateInputObject)
                } catch {
                    $statusReadException = $_.Exception
                    while ($statusReadException.GetType() -in @(
                            [System.Management.Automation.RuntimeException],
                            [System.Management.Automation.MethodInvocationException]
                        ) -and $null -ne $statusReadException.InnerException) {
                        $statusReadException = $statusReadException.InnerException
                    }
                    if ($statusReadException -isnot [System.Net.Http.HttpRequestException] -or
                        $null -ne $statusReadException.StatusCode -or
                        $statusReadException.InnerException -isnot [System.IO.IOException] -or
                        $statusReadException.InnerException.InnerException -isnot [System.Net.Sockets.SocketException] -or
                        $statusReadException.InnerException.InnerException.SocketErrorCode -ne [System.Net.Sockets.SocketError]::ConnectionReset -or
                        $null -ne $statusReadException.InnerException.InnerException.InnerException -or
                        $statusReadRecoveryCount -ge $maxStatusReadRecoveries) {
                        throw
                    }
                    $remainingSeconds = ($deadline - (Get-Date).ToUniversalTime()).TotalSeconds
                    if ($remainingSeconds -le 0) {
                        throw
                    }
                    $statusReadRecoveryCount++
                    Write-Warning ('Connection reset while reading status for submitted image build [{0}]. Retrying the status read (recovery {1} of {2}); the build will not be resubmitted.' -f $imageTemplateName, $statusReadRecoveryCount, $maxStatusReadRecoveries)
                    Start-Sleep -Seconds ([Math]::Min(15.0, $remainingSeconds))
                    continue
                }
                if ((Get-Date).ToUniversalTime() -ge $deadline) {
                    break
                }
                if ($imageTemplates.Count -ne 1) {
                    throw ('Expected exactly one image template [{0}] in resource group [{1}].' -f $imageTemplateName, $imageTemplateResourceGroup)
                }
                $imageTemplate = $imageTemplates[0]
                $runStartTime = if ($imageTemplate.LastRunStatusStartTime) { [datetime] $imageTemplate.LastRunStatusStartTime } else { [datetime]::MinValue }
                $runState = [string] $imageTemplate.LastRunStatusRunState
                if ($runStartTime -gt $previousRunStartTime) {
                    if ($null -eq $submittedRunStartTime) {
                        $submittedRunStartTime = $runStartTime
                    } elseif ($runStartTime -gt $submittedRunStartTime) {
                        throw ('Image build [{0}] changed while waiting for the submitted run to complete.' -f $imageTemplateName)
                    }
                }
                if ($runStartTime -eq $submittedRunStartTime) {
                    if ($runState -eq 'Succeeded') {
                        $runSucceeded = $true
                        break
                    }
                    if ($runState -in @('Failed', 'Canceled', 'PartiallySucceeded')) {
                        throw ('Image build [{0}] ended in state [{1}], substate [{2}]: {3}' -f $imageTemplateName, $runState, $imageTemplate.LastRunStatusRunSubState, $imageTemplate.LastRunStatusMessage)
                    }
                    if ($runState -notin @('Running', 'Canceling', '')) {
                        throw ('Unexpected image build state [{0}] for template [{1}]: {2}' -f $runState, $imageTemplateName, $imageTemplate.LastRunStatusMessage)
                    }
                }
                if ($runState -ne $lastReportedState) {
                    Write-Verbose ('Waiting for the submitted image build [{0}]. Last reported state [{1}], substate [{2}].' -f $imageTemplateName, $runState, $imageTemplate.LastRunStatusRunSubState) -Verbose
                    $lastReportedState = $runState
                }
                $remainingSeconds = ($deadline - (Get-Date).ToUniversalTime()).TotalSeconds
                if ($remainingSeconds -gt 0) {
                    Start-Sleep -Seconds ([Math]::Min(15.0, $remainingSeconds))
                }
            }
            if (-not $runSucceeded) {
                throw ('Timed out after {0} minutes waiting for the submitted image build [{1}]. Last run state [{2}], substate [{3}]: {4}' -f $waitTimeoutInMinutes, $imageTemplateName, $imageTemplate.LastRunStatusRunState, $imageTemplate.LastRunStatusRunSubState, $imageTemplate.LastRunStatusMessage)
            }
            Write-Verbose ('Created image artifacts from image template [{0}] in resource group [{1}]' -f $imageTemplateName, $imageTemplateResourceGroup) -Verbose
        }
    }
}

end {
    Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
}
