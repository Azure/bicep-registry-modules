<#
.SYNOPSIS
Validate whether the currently installed Bicep version is the latest available

.DESCRIPTION
Validate whether the currently installed Bicep version is the latest available
Produces a warning if not.

.EXAMPLE
Test-BicepVersion

May return: You're using the latest available Bicep CLI version [0.5.0].
#>
function Test-BicepVersion {

    # Get latest release from Azure/Bicep repository
    # ----------------------------------------------
    $latestReleaseUrl = 'https://api.github.com/repos/azure/bicep/releases/latest'
    try {
        $latestReleaseObject = Invoke-RestMethod -Uri $latestReleaseUrl -Method 'GET'
    } catch {
        Write-Warning "Skipping Bicep version check as url [$latestReleaseUrl] did not return a response."
    }
    if ($latestReleaseObject) {
        # Only run if connected to the internet / url returns a response
        $releaseTag = $latestReleaseObject.tag_name
        $latestReleaseVersion = [version]($releaseTag -replace 'v', '')
        $latestReleaseUrl = $latestReleaseObject.html_url

        # Get latest installed Bicep CLI version
        # --------------------------------------
        $latestInstalledVersionOutput = bicep --version

        if ($latestInstalledVersionOutput -match ' ([0-9]+\.[0-9]+\.[0-9]+) ') {
            $latestInstalledVersion = [version]$matches[1]
        }

        # Compare the versions
        # --------------------
        if ($latestInstalledVersion -ne $latestReleaseVersion) {
            Write-Warning """
You're not using the latest available Bicep CLI version [$latestReleaseVersion] but [$latestInstalledVersion].
You can find the latest release at: $latestReleaseUrl.

On Windows, you can use winget to update the Bicep CLI by running 'winget update Microsoft.Bicep' or chocolatey via 'choco upgrade bicep'.
For other OSs, please refer to the Bicep documentation (https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install).

Note: The 'Bicep CLI' version (bicep --version) is not the same as the 'Azure CLI Bicep extension' version (az bicep version).
"""
        } else {
            Write-Verbose "You're using the latest available Bicep CLI version [$latestInstalledVersion]."
        }
    }
}
