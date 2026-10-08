$script:HciHostImageGalleryName = 'AVMHCIVMIMAGEGALLERY'
$script:HciHostImageDefinitionName = 'hci-host-image'

function Resolve-HciHostImageReferenceId {

    [CmdletBinding()]
    param ()

    $query = @"
resources
| where type =~ 'microsoft.compute/galleries/images/versions'
| where tolower(tostring(split(id, '/')[8])) == tolower('$script:HciHostImageGalleryName')
| where tolower(tostring(split(id, '/')[10])) == tolower('$script:HciHostImageDefinitionName')
| where coalesce(tobool(properties.publishingProfile.excludeFromLatest), false) == false
| order by todatetime(properties.publishingProfile.publishedDate) desc
| project id
| take 1
"@

    try {
        $imageVersion = @(Search-AzGraph -Query $query -UseTenantScope -First 1 -ErrorAction Stop) | Select-Object -First 1
    } catch {
        Write-Warning "Unable to resolve the Azure Stack HCI host image from Azure Resource Graph. The marketplace host fallback will be used. $($_.Exception.Message)"
        return ''
    }

    if (-not $imageVersion -or [string]::IsNullOrWhiteSpace([string] $imageVersion.id)) {
        return ''
    }

    return [string] $imageVersion.id
}
