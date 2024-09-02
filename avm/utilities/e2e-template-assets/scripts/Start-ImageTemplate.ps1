<#
.SYNOPSIS
Create image artifacts from a given image template

.DESCRIPTION
Create image artifacts from a given image template

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
    $resourceActionInputObject = @{
        ImageTemplateName = $imageTemplateName
        ResourceGroupName = $imageTemplateResourceGroup
    }
    if ($NoWait) {
        $resourceActionInputObject['NoWait'] = $true
    }
    if ($PSCmdlet.ShouldProcess('Image template [{0}]' -f $imageTemplateName, 'Start')) {
        $null = Start-AzImageBuilderTemplate @resourceActionInputObject
        Write-Verbose ('Created/initialized creation of image artifacts from image template [{0}] in resource group [{1}]' -f $imageTemplateName, $imageTemplateResourceGroup) -Verbose
    }
}

end {
    Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
}
