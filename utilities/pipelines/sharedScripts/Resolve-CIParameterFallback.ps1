$script:CIParameterFallbackConfiguration = @{
    hciHostImageReferenceId = @{
        SubscriptionVariableName = 'VALIDATE_PERSISTENT_SUBSCRIPTION_ID'
        ResourceGroupName         = 'rg-avm-persistent-hci-image'
        GalleryName               = 'galavmpersistenthci'
        ImageDefinitionName       = 'hci-host-image'
        ApiVersion                = '2024-03-03'
    }
}

function Resolve-CIParameterFallback {

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'ARM secureString parameters require SecureString values.')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary] $TemplateParameters,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary] $ResolvedParameters,

        [Parameter()]
        [string] $GitHubVariables = '{}'
    )

    try {
        $variables = ConvertFrom-Json -InputObject $GitHubVariables -AsHashtable -ErrorAction Stop
    } catch {
        Write-Warning 'Unable to parse GitHub variables while resolving CI parameter fallbacks.'
        return @{}
    }

    if ($variables -isnot [System.Collections.IDictionary]) {
        Write-Warning 'GitHub variables must be a JSON object when resolving CI parameter fallbacks.'
        return @{}
    }

    $parameters = @{}
    foreach ($parameterName in $script:CIParameterFallbackConfiguration.psbase.Keys) {
        if (-not $TemplateParameters.Contains($parameterName) -or $ResolvedParameters.Contains($parameterName)) {
            continue
        }

        $configuration = $script:CIParameterFallbackConfiguration[$parameterName]
        $subscriptionId = [string] $variables[$configuration.SubscriptionVariableName]
        if ([string]::IsNullOrWhiteSpace($subscriptionId)) {
            Write-Warning "Unable to resolve CI parameter [$parameterName] because variable [$($configuration.SubscriptionVariableName)] is unavailable."
            continue
        }

        $path = "/subscriptions/$subscriptionId/resourceGroups/$($configuration.ResourceGroupName)/providers/Microsoft.Compute/galleries/$($configuration.GalleryName)/images/$($configuration.ImageDefinitionName)/versions?api-version=$($configuration.ApiVersion)"

        try {
            $response = Invoke-AzRestMethod -Method GET -Path $path -ErrorAction Stop
            if ([int] $response.StatusCode -ne 200) {
                Write-Warning "Unable to resolve CI parameter [$parameterName]. The image version request returned HTTP [$($response.StatusCode)]."
                continue
            }

            $content = ConvertFrom-Json -InputObject $response.Content -AsHashtable -ErrorAction Stop
            $imageVersions = foreach ($imageVersion in @($content.value)) {
                if (
                    $imageVersion.properties.provisioningState -ne 'Succeeded' -or
                    $imageVersion.properties.publishingProfile.excludeFromLatest -eq $true
                ) {
                    continue
                }

                $publishedDate = [datetimeoffset]::MinValue
                if (
                    [string]::IsNullOrWhiteSpace([string] $imageVersion.id) -or
                    -not [datetimeoffset]::TryParse(
                        [string] $imageVersion.properties.publishingProfile.publishedDate,
                        [ref] $publishedDate
                    )
                ) {
                    continue
                }

                [pscustomobject] @{
                    Id            = [string] $imageVersion.id
                    PublishedDate = $publishedDate
                }
            }

            $imageReferenceId = ($imageVersions | Sort-Object -Property PublishedDate -Descending | Select-Object -First 1).Id
            if ([string]::IsNullOrWhiteSpace($imageReferenceId)) {
                Write-Warning "Unable to resolve CI parameter [$parameterName] because no usable image versions were found."
                continue
            }

            if ($TemplateParameters[$parameterName].type -eq 'secureString') {
                $parameters[$parameterName] = ConvertTo-SecureString -String $imageReferenceId -AsPlainText -Force
            } else {
                $parameters[$parameterName] = $imageReferenceId
            }
        } catch {
            Write-Warning "Unable to resolve CI parameter [$parameterName]. The marketplace host fallback will be used. $($_.Exception.Message)"
        }
    }

    return $parameters
}
