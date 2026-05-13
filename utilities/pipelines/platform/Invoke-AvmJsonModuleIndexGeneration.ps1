<#
.SYNOPSIS
Creates the moduleIndex.json file for the AVM modules that is used by Visual Studio Code and other IDEs to provide the intellisense list of modules from the Bicep public registry. Modules marked as deprecated with a DEPRECATED.md file will be excluded.

.PARAMETER storageAccountName
The name of the Azure Storage Account where the moduleIndex.json file is stored. Default is 'biceplivedatasaprod'.

.PARAMETER storageAccountContainer
The name of the Azure Storage Account Blob Container where the moduleIndex.json file is stored.  Default is 'bicep-cdn-live-data-container'.

.PARAMETER storageBlobName
The name of the Azure Storage Account Blob where the moduleIndex.json file is stored. Default is 'module-index'.

.PARAMETER moduleIndexJsonFilePath
The file path to save the moduleIndex.json file to. Default is 'moduleIndex.json'.

.PARAMETER prefixForLastModuleIndexJsonFile
The prefix to add to the last version of the moduleIndex.json file that is downloaded from the storage account. Default is 'last-'.

.PARAMETER prefixForCurrentGeneratedModuleIndexJsonFile
The prefix to add to the current generated moduleIndex.json file. Default is 'generated-'.

.PARAMETER doNotMergeWithLastModuleIndexJsonFileVersion
If specified, the last version of the moduleIndex.json file that is downloaded from the storage account will not be merged with the current generated moduleIndex.json file.

.DESCRIPTION
Creates the moduleIndex.json file for the AVM modules that is used by Visual Studio Code and other IDEs to provide the intellisense list of modules from the Bicep public registry.

Modules are excluded from the moduleIndex.json file if they are marked as deprecated with a DEPRECATED.md file in the module's root directory. This applies to both main modules and child modules.

Also has error handling to cope with a module not being published fully but will not prevent the script from completing each time.

The script uses a merging strategy with the previous version of moduleIndex.json to ensure that the file is always up to date with the latest modules but previous versions are not removed, this can be changed by specifying the $doNotMergeWithLastModuleIndexJsonFileVersion parameter.

.EXAMPLE
Invoke-AvmJsonModuleIndexGeneration -storageAccountName '<STORAGE ACCOUNT NAME>' -storageAccountContainer '<STORAGE ACCOUNT BLOB CONTAINER NAME>' -storageBlobName '<STORAGE ACCOUNT BLOB NAME>' -moduleIndexJsonFilePath 'moduleIndex.json' -prefixForLastModuleIndexJsonFile 'last-' -prefixForCurrentGeneratedModuleIndexJsonFile 'generated-'

This example will generate the moduleIndex.json file for the AVM modules and save it to the current directory and merge it with the last version of the moduleIndex.json file that was downloaded from the storage account.

.NOTES
The function requires Azure PowerShell Storage Module (Az.Storage) to be installed and the user to be logged in to Azure.
#>

function Connect-AzAccountWithGitHubOidc {
    <#
    .SYNOPSIS
    Mints a fresh GitHub Actions OIDC JWT and (re-)authenticates the current Az
    PowerShell context using the federated-credential flow.

    .DESCRIPTION
    Equivalent to what azure/login@v3 does internally (see
    Azure/login src/PowerShell/AzPSScriptBuilder.ts loginWithOIDC). Safe to call
    multiple times within the same job - each call mints a new short-lived JWT
    from the runner's OIDC endpoint and re-issues Connect-AzAccount with it.

    Requires:
      - The workflow grants 'permissions: id-token: write'.
      - azure/login@v3 has already run once (so AZURE_TENANT_ID / AZURE_CLIENT_ID
        / AZURE_SUBSCRIPTION_ID are available, unless explicitly passed in).

    .PARAMETER TenantId
    AAD tenant ID. Defaults to $env:AZURE_TENANT_ID (set by azure/login).

    .PARAMETER ClientId
    AAD application (client) ID with the configured federated credential.
    Defaults to $env:AZURE_CLIENT_ID (set by azure/login).

    .PARAMETER SubscriptionId
    Azure subscription ID to set as default. Defaults to $env:AZURE_SUBSCRIPTION_ID.

    .PARAMETER Audience
    Audience claim requested in the GitHub OIDC JWT.
    Defaults to 'api://AzureADTokenExchange', which is what AAD federated
    credentials expect by default and what azure/login uses.
    #>
    [CmdletBinding()]
    param(
        [string] $TenantId       = $env:AZURE_TENANT_ID,
        [string] $ClientId       = $env:AZURE_CLIENT_ID,
        [string] $SubscriptionId = $env:AZURE_SUBSCRIPTION_ID,
        [string] $Audience       = 'api://AzureADTokenExchange'
    )

    if (-not $env:ACTIONS_ID_TOKEN_REQUEST_URL -or -not $env:ACTIONS_ID_TOKEN_REQUEST_TOKEN) {
        throw "GitHub OIDC env vars not present. The workflow must grant 'permissions: id-token: write' and this function must run inside a GitHub Actions job."
    }
    if (-not $TenantId -or -not $ClientId) {
        throw 'TenantId and ClientId are required (either via parameters or AZURE_TENANT_ID / AZURE_CLIENT_ID env vars set by azure/login).'
    }

    $uri = '{0}&audience={1}' -f $env:ACTIONS_ID_TOKEN_REQUEST_URL, [uri]::EscapeDataString($Audience)

    $jwt      = $null
    $response = $null
    try {
        try {
            $response = Invoke-RestMethod -Uri $uri `
                                          -Headers @{ Authorization = "bearer $env:ACTIONS_ID_TOKEN_REQUEST_TOKEN" } `
                                          -ErrorAction Stop
        } catch {
            # Sanitize: never re-throw the original exception (it can include the request URL/headers).
            $statusCode = $null
            try { $statusCode = $_.Exception.Response.StatusCode } catch { $null = $_ }
            throw "Failed to obtain GitHub OIDC token (HTTP $statusCode)."
        }

        $jwt = $response.value
        if ([string]::IsNullOrWhiteSpace($jwt)) {
            throw 'GitHub OIDC endpoint returned an empty token.'
        }

        # Defense-in-depth: register a runner mask via the workflow command file
        # (NOT via stdout) so that if any future code path ever logs $jwt, the
        # runner redacts it. Mirrors what azure/login does via core.setSecret().
        if ($env:GITHUB_ENV) {
            try {
                Add-Content -Path $env:GITHUB_ENV -Value "::add-mask::$jwt" -Encoding utf8 -ErrorAction Stop
            } catch {
                Write-Verbose "Could not register runner mask for OIDC JWT: $($_.Exception.Message)" -Verbose
            }
        }

        $connectParams = @{
            ServicePrincipal   = $true
            ApplicationId      = $ClientId
            Tenant             = $TenantId
            FederatedToken     = $jwt
            InformationAction  = 'Ignore'
            WarningAction      = 'SilentlyContinue'
            ErrorAction        = 'Stop'
        }
        if ($SubscriptionId) { $connectParams['Subscription'] = $SubscriptionId }

        Connect-AzAccount @connectParams | Out-Null

        Write-Verbose "Re-authenticated to Azure via GitHub OIDC (audience=$Audience, client=$ClientId, tenant=$TenantId)." -Verbose
    } finally {
        # Best-effort scrub of plaintext token from memory. PowerShell strings
        # are immutable so we can't zero bytes, but releasing the reference
        # and forcing GC minimizes the exposure window.
        $jwt      = $null
        $response = $null
        [GC]::Collect()
        [GC]::WaitForPendingFinalizers()
    }
}

function Invoke-AzStorageOperationWithOidcRetry {
    <#
    .SYNOPSIS
    Runs a storage-related scriptblock and, if it fails with what looks like an
    OIDC / federated-credential / auth error, refreshes the GitHub OIDC login
    via Connect-AzAccountWithGitHubOidc and retries up to -MaxAttempts times
    with exponential backoff.

    .PARAMETER ScriptBlock
    The storage operation(s) to execute. Should use -ErrorAction Stop on Az
    cmdlets so non-terminating errors are caught here.

    .PARAMETER MaxAttempts
    Maximum number of attempts. Default 3.

    .PARAMETER InitialDelaySeconds
    Initial backoff in seconds; doubles on each retry. Default 2.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [scriptblock] $ScriptBlock,
        [int] $MaxAttempts         = 3,
        [int] $InitialDelaySeconds = 2,

        # OIDC re-login params - default to env vars set by azure/login.
        [string] $TenantId       = $env:AZURE_TENANT_ID,
        [string] $ClientId       = $env:AZURE_CLIENT_ID,
        [string] $SubscriptionId = $env:AZURE_SUBSCRIPTION_ID,
        [string] $Audience       = 'api://AzureADTokenExchange'
    )

    # Substrings indicating the failure was an authentication / OIDC issue
    # (i.e., re-logging in might fix it) rather than a real storage problem.
    $authErrorPatterns = @(
        'ClientAssertionCredential',
        'AADSTS70021',          # No matching federated identity record found
        'AADSTS700024',         # Client assertion is not within its valid time range
        'AADSTS700016',         # Application not found in the directory
        'AADSTS50013',          # Assertion is invalid
        'invalid_client',
        'expired',
        'authentication failed',
        'Could not get the storage context',
        'Run Connect-AzAccount'
    )

    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
        try {
            return & $ScriptBlock
        } catch {
            $msg = "$($_.Exception.Message) $($_.Exception.InnerException.Message)"
            $isAuthError = $false
            foreach ($pattern in $authErrorPatterns) {
                if ($msg -like "*$pattern*") { $isAuthError = $true; break }
            }

            if (-not $isAuthError -or $attempt -eq $MaxAttempts) {
                throw
            }

            $delay = [int]($InitialDelaySeconds * [math]::Pow(2, $attempt - 1))
            Write-Warning ('Storage operation failed with auth-shaped error (attempt {0}/{1}): {2}' -f `
                           $attempt, $MaxAttempts, $_.Exception.Message)
            Write-Warning ('Refreshing GitHub OIDC login and retrying in {0}s...' -f $delay)
            Start-Sleep -Seconds $delay

            try {
                Connect-AzAccountWithGitHubOidc -TenantId       $TenantId `
                                                -ClientId       $ClientId `
                                                -SubscriptionId $SubscriptionId `
                                                -Audience       $Audience
            } catch {
                Write-Warning "OIDC re-login itself failed on attempt $attempt`: $($_.Exception.Message)"
                # Loop will retry both the login and the operation on the next iteration.
            }
        }
    }
}

function Invoke-AvmJsonModuleIndexGeneration {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $storageAccountName = 'biceplivedatasaprod',

        [Parameter(Mandatory = $false)]
        [string] $storageAccountContainer = 'bicep-cdn-live-data-container',

        [Parameter(Mandatory = $false)]
        [string] $storageBlobName = 'module-index',

        [Parameter(Mandatory = $false)]
        [string] $moduleIndexJsonFilePath = 'moduleIndex.json',

        [Parameter(Mandatory = $false)]
        [string] $prefixForLastModuleIndexJsonFile = 'last-',

        [Parameter(Mandatory = $false)]
        [string] $prefixForCurrentGeneratedModuleIndexJsonFile = 'generated-',

        [Parameter(Mandatory = $false)]
        [switch] $doNotMergeWithLastModuleIndexJsonFileVersion
    )

    ## Generate the new moduleIndex.json file based off the modules in the repository

    $currentGeneratedModuleIndexJsonFilePath = $prefixForCurrentGeneratedModuleIndexJsonFile + $moduleIndexJsonFilePath

    Write-Verbose "Generating the current generated moduleIndex.json file and saving to: $currentGeneratedModuleIndexJsonFilePath ..." -Verbose

    $global:anyErrorsOccurred = $false
    $global:moduleIndexData = @()

    foreach ($avmModuleRoot in @('avm/res', 'avm/ptn', 'avm/utl')) {
        $avmModuleGroups = (Get-ChildItem -Path $avmModuleRoot -Directory).Name

        foreach ($moduleGroup in $avmModuleGroups) {
            $moduleGroupPath = "$avmModuleRoot/$moduleGroup"
            $moduleNames = (Get-ChildItem -Path $moduleGroupPath -Directory).Name

            foreach ($moduleName in $moduleNames) {
                $modulePath = "$moduleGroupPath/$moduleName"

                # Check if the module is deprecated by looking for a DEPRECATED.md file
                if (Test-Path -Path "$modulePath/DEPRECATED.md") {
                    Write-Verbose "Module '$modulePath' is marked as DEPRECATED. Skipping..." -Verbose
                    continue
                }

                # Check if this is a multi-scope module that should not be published directly
                $isMultiScopeModule = Test-IsMultiScopeModule -modulePath $modulePath
                if ($isMultiScopeModule) {
                    Write-Verbose "Module '$modulePath' is a multi-scope module. Skipping main module and processing scope-specific modules..." -Verbose

                    # Process scope-specific subdirectories as standalone modules
                    $scopeDirectories = (Get-ChildItem -Path $modulePath -Directory -Exclude 'tests').Name
                    foreach ($scopeDirectory in $scopeDirectories) {
                        $scopeModulePath = "$modulePath/$scopeDirectory"

                        # Check if scope module is deprecated
                        if (Test-Path -Path "$scopeModulePath/DEPRECATED.md") {
                            Write-Verbose "  Scope module '$scopeModulePath' is marked as DEPRECATED. Skipping..." -Verbose
                            continue
                        }

                        # Check if scope module has required files
                        $scopeModuleHasRequiredFiles = (Test-Path -Path "$scopeModulePath/main.bicep") -and (Test-Path -Path "$scopeModulePath/main.json") -and (Test-Path -Path "$scopeModulePath/README.md") -and (Test-Path -Path "$scopeModulePath/version.json")
                        if (-not $scopeModuleHasRequiredFiles) {
                            Write-Verbose "  Scope module '$scopeModulePath' does not have required files. Skipping..." -Verbose
                            continue
                        }

                        Write-Verbose "  Processing scope module '$scopeModulePath'..." -Verbose
                        $scopeMainJsonPath = "$scopeModulePath/main.json"
                        $scopeTagListUrl = "https://mcr.microsoft.com/v2/bicep/$scopeModulePath/tags/list"

                        Add-ModuleToAvmJsonModuleIndex -modulePath $scopeModulePath -mainJsonPath $scopeMainJsonPath -tagListUrl $scopeTagListUrl
                    }
                    continue
                }

                # Only proceed if the module has necessary files
                if (-not (Test-Path -Path "$modulePath/main.json")) {
                    Write-Verbose "Module '$modulePath' does not have main.json. Skipping..." -Verbose
                    continue
                }

                $mainJsonPath = "$modulePath/main.json"
                $tagListUrl = "https://mcr.microsoft.com/v2/bicep/$modulePath/tags/list"

                Add-ModuleToAvmJsonModuleIndex -modulePath $modulePath -mainJsonPath $mainJsonPath -tagListUrl $tagListUrl

                ## Find child modules that contain a main.bicep, main.json, README.md and version.json file
                ## Skip child module processing for multi-scope modules as they are handled above
                if (-not $isMultiScopeModule) {
                    Write-Verbose '  Checking for child modules (including nested ones)...' -Verbose

                    # Use the new recursive function to find all valid child modules at any depth
                    $verifiedChildModules = Find-ChildModulesRecursively -modulePath $modulePath

                    if ($verifiedChildModules.Count -ne 0) {
                        Write-Verbose "  Found child modules: $($verifiedChildModules -join ', ')" -Verbose

                        foreach ($childModulePath in $verifiedChildModules) {
                            # Double-check if the child module is deprecated (should already be filtered, but just to be safe)
                            if (Test-Path -Path "$childModulePath/DEPRECATED.md") {
                                Write-Verbose "  Child module '$childModulePath' is marked as DEPRECATED. Skipping..." -Verbose
                                continue
                            }

                            # Double-check that the required files exist (should already be verified, but just to be safe)
                            if (-not (Test-Path -Path "$childModulePath/main.json")) {
                                Write-Verbose "  Child module '$childModulePath' does not have main.json. Skipping..." -Verbose
                                continue
                            }

                            $childModuleMainJsonPath = "$childModulePath/main.json"
                            $childModuleTagListUrl = "https://mcr.microsoft.com/v2/bicep/$childModulePath/tags/list"

                            Add-ModuleToAvmJsonModuleIndex -modulePath $childModulePath -mainJsonPath $childModuleMainJsonPath -tagListUrl $childModuleTagListUrl
                        }
                    } else {
                        Write-Verbose '  No child modules found for this module.' -Verbose
                    }
                }

            }

            $numberOfModuleGroupsProcessed++
        }
    }

    Write-Verbose "Processed $numberOfModuleGroupsProcessed modules groups." -Verbose
    Write-Verbose "Processed $($global:moduleIndexData.Count) total modules." -Verbose

    Write-Verbose "Convert moduleIndexData variable to JSON and save as 'generated-moduleIndex.json'" -Verbose
    $global:moduleIndexData | ConvertTo-Json -Depth 10 | Out-File -FilePath $currentGeneratedModuleIndexJsonFilePath

    ## Download the current published moduleIndex.json from the storage account if the $doNotMergeWithLastModuleIndexJsonFileVersion is set to $false
    if (-not $doNotMergeWithLastModuleIndexJsonFileVersion) {
        try {
            $lastModuleIndexJsonFilePath = $prefixForLastModuleIndexJsonFile + $moduleIndexJsonFilePath

            Write-Verbose "Attempting to get last version of the moduleIndex.json from the Storage Account: $storageAccountName, Container: $storageAccountContainer, Blob: $storageBlobName and save to file: $lastModuleIndexJsonFilePath ..." -Verbose

            # The GitHub OIDC JWT used by ClientAssertionCredential is short-lived
            # (~10-15 min). The module enumeration loop above can run longer than
            # that, causing -UseConnectedAccount to fail with
            # 'ClientAssertionCredential authentication failed'. The retry helper
            # mints a fresh JWT and re-runs Connect-AzAccount on auth failures.
            Invoke-AzStorageOperationWithOidcRetry -ScriptBlock {
                $storageContext = New-AzStorageContext -StorageAccountName $storageAccountName -UseConnectedAccount -ErrorAction Stop
                Get-AzStorageBlobContent -Blob        $storageBlobName `
                                         -Container   $storageAccountContainer `
                                         -Context     $storageContext `
                                         -Destination $lastModuleIndexJsonFilePath `
                                         -Force `
                                         -ErrorAction Stop | Out-Null
            }
        } catch {
            Write-Error "Unable to retrieve moduleIndex.json file from the Storage Account: $storageAccountName, Container: $storageAccountContainer, Blob: $storageBlobName. Error: $($_.Exception.Message)" -ErrorAction 'Stop'
        }

        ## Check if the last version of the moduleIndex.json (last-moduleIndex.json) file exists and is not empty

        if (Test-Path $lastModuleIndexJsonFilePath) {
            $lastModuleIndexJsonFileContent = Get-Content $lastModuleIndexJsonFilePath
            if ($null -eq $lastModuleIndexJsonFileContent) {
                Write-Error "The last version of the moduleIndex.json file (last-moduleIndex.json) exists but is empty. File: $lastModuleIndexJsonFilePath" -ErrorAction 'Stop'
            }
            Write-Verbose 'The last version of the moduleIndex.json file (last-moduleIndex.json) exists and is not empty. Proceeding...' -Verbose
        }

        ## Merge the new moduleIndex.json file with the previous version if the $doNotMergeWithLastModuleIndexJsonFileVersion is not specified
        Write-Verbose "Merging 'generated-moduleIndex.json' (new) file with 'last-moduleIndex.json' (previous) file..." -Verbose

        $lastModuleIndexJsonFileContent = Get-Content $lastModuleIndexJsonFilePath
        $currentGeneratedModuleIndexJsonFileContent = Get-Content $currentGeneratedModuleIndexJsonFilePath

        $lastModuleIndexData = $lastModuleIndexJsonFileContent | ConvertFrom-Json -Depth 10
        $currentGeneratedModuleIndexData = $currentGeneratedModuleIndexJsonFileContent | ConvertFrom-Json -Depth 10

        $initialMergeOfJsonFilesData = @{}

        foreach ($module in $currentGeneratedModuleIndexData) {
            $initialMergeOfJsonFilesData[$module.moduleName] = $module
        }

        # Add modules from lastModuleIndexData to the initialMergeOfJsonFilesData hashtable, merging tags and properties if they exist in both files
        foreach ($module in $lastModuleIndexData) {
            if (-not $initialMergeOfJsonFilesData.ContainsKey($module.moduleName)) {
                $initialMergeOfJsonFilesData[$module.moduleName] = $module
            } else {
                # If the module exists, merge the tags and properties
                $mergedModule = $initialMergeOfJsonFilesData[$module.moduleName]
                $mergedModule.tags = @(($mergedModule.tags + $module.tags) | Sort-Object -Culture 'en-US' -Unique)

                # Merge properties
                foreach ($property in $module.properties.PSObject.Properties) {
                    if (-not $mergedModule.properties.PSObject.Properties.Name.Contains($property.Name)) {
                        $mergedModule.properties | Add-Member -NotePropertyName $property.Name -NotePropertyValue $property.Value
                    }
                }
            }
        }

        # Convert the mergedModuleIndexData hashtable to an array of values (i.e., the modules)
        $mergedModuleIndexData = $initialMergeOfJsonFilesData.Values

        # Sort the modules by their names
        $sortedMergedModuleIndexData = $mergedModuleIndexData | Sort-Object -Culture 'en-US' -Property 'moduleName'

        Write-Verbose "Convert mergedModuleIndexData variable to JSON and save as 'moduleIndex.json'" -Verbose
        $sortedMergedModuleIndexData | ConvertTo-Json -Depth 10 | Out-File -FilePath $moduleIndexJsonFilePath
    }
    if ($doNotMergeWithLastModuleIndexJsonFileVersion -eq $true) {
        Write-Verbose "Convert currentGeneratedModuleIndexData variable to JSON and save as 'moduleIndex.json to overwrite it as `doNotMergeWithLastModuleIndexJsonFileVersion` was specified'" -Verbose
        $global:moduleIndexData | ConvertTo-Json -Depth 10 | Out-File -FilePath $moduleIndexJsonFilePath -Force
    }

    return ($global:anyErrorsOccurred ? $false : $true)

}

function Test-IsMultiScopeModule {
    <#
    .SYNOPSIS
    Tests if a module is a multi-scope module that should not be published directly.

    .DESCRIPTION
    Uses the same reliable logic as module.tests.ps1 to detect multi-scope modules by checking
    for child directories that match the naming pattern for scope-specific modules (rg-scope, sub-scope, mg-scope).

    .PARAMETER modulePath
    The path to the module.

    .OUTPUTS
    Returns $true if the module is a multi-scope module, $false otherwise.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string] $modulePath
    )

    # Use the same logic as module.tests.ps1: check for child directories matching scope patterns
    # This is more reliable than parsing text content and matches the existing codebase approach
    try {
        $scopeDirectories = Get-ChildItem -Directory -Path $modulePath -ErrorAction SilentlyContinue | Where-Object { $_.FullName -match '[\/|\\](rg|sub|mg)\-scope$' }
        $isMultiScopeParentModule = $scopeDirectories.Count -gt 0

        if ($isMultiScopeParentModule) {
            Write-Verbose "  Multi-scope module detected: '$modulePath' (found $($scopeDirectories.Count) scope modules: $($scopeDirectories.Name -join ', '))" -Verbose
        }

        return $isMultiScopeParentModule
    } catch {
        Write-Verbose "  Warning: Could not analyze directory structure for module '$modulePath': $($_.Exception.Message)" -Verbose
        return $false
    }
}

function Find-ChildModulesRecursively {
    <#
    .SYNOPSIS
    Recursively finds all valid child modules at any depth level.

    .DESCRIPTION
    Searches through a module's directory structure to find all child modules
    that have the required files (main.bicep, main.json, README.md, version.json)
    and are not marked as deprecated.

    .PARAMETER modulePath
    The path to the parent module to search within.

    .PARAMETER processedPaths
    HashSet to track already processed paths to avoid duplicates.

    .OUTPUTS
    Returns an array of child module paths that meet the requirements.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string] $modulePath,

        [Parameter(Mandatory = $false)]
        [System.Collections.Generic.HashSet[string]] $processedPaths = [System.Collections.Generic.HashSet[string]]::new()
    )

    $validChildModules = @()

    # Get all subdirectories, excluding 'tests' and any already processed paths
    $possibleChildDirectories = Get-ChildItem -Path $modulePath -Directory -Exclude 'tests' -ErrorAction SilentlyContinue

    foreach ($childDir in $possibleChildDirectories) {
        $childPath = $childDir.FullName
        $relativePath = $childPath -replace [regex]::Escape((Get-Location).Path + [System.IO.Path]::DirectorySeparatorChar), ''
        $relativePath = $relativePath -replace '\\', '/'  # Normalize path separators

        # Skip if we've already processed this path
        if ($processedPaths.Contains($relativePath)) {
            continue
        }

        # Add to processed paths
        $processedPaths.Add($relativePath) | Out-Null

        # Check if this directory is deprecated
        if (Test-Path -Path "$childPath/DEPRECATED.md") {
            Write-Verbose "    Child module '$relativePath' is marked as DEPRECATED. Skipping..." -Verbose
            continue
        }

        # Check if this directory has the required files for a publishable module
        $hasRequiredFiles = (Test-Path -Path "$childPath/main.bicep") -and
                           (Test-Path -Path "$childPath/main.json") -and
                           (Test-Path -Path "$childPath/README.md") -and
                           (Test-Path -Path "$childPath/version.json")

        if ($hasRequiredFiles) {
            Write-Verbose "    Found valid child module: $relativePath" -Verbose
            $validChildModules += $relativePath
        }

        # Recursively search this directory for more child modules
        $nestedChildren = Find-ChildModulesRecursively -modulePath $childPath -processedPaths $processedPaths
        $validChildModules += $nestedChildren
    }

    return $validChildModules
}

function Add-ModuleToAvmJsonModuleIndex {
    <#
    .SYNOPSIS
    Adds a module to the module index data.

    .DESCRIPTION
    Processes a module to add to the AVM JSON module index. Retrieves the module's
    tags and description and adds it to the module index data.

    Note: The calling code already checks for DEPRECATED.md and ensures that main.json exists
    before calling this function.

    .PARAMETER modulePath
    The path to the module.

    .PARAMETER mainJsonPath
    The path to the module's main.json file. Default is "$modulePath/main.json".

    .PARAMETER tagListUrl
    The URL to retrieve the module's tags. Default is "https://mcr.microsoft.com/v2/bicep/$modulePath/tags/list".

    .OUTPUTS
    Returns $true if no errors occurred, $false otherwise.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string] $modulePath,

        [Parameter(Mandatory = $false)]
        [string] $mainJsonPath = "$modulePath/main.json",

        [Parameter(Mandatory = $false)]
        [string] $tagListUrl = "https://mcr.microsoft.com/v2/bicep/$modulePath/tags/list"
    )

    # Note: We've already checked for DEPRECATED.md in the main script
    # and verified that main.json exists, so we don't need to check again here

    try {
        Write-Verbose "Processing AVM Module '$modulePath'..." -Verbose
        Write-Verbose "  Getting available tags at '$tagListUrl'..." -Verbose

        try {
            $tagListResponse = Invoke-RestMethod -Uri $tagListUrl
        } catch {
            $global:anyErrorsOccurred = $true
            Write-Error "Error occurred while accessing URL: $tagListUrl"
            Write-Error "Error message: $($_.Exception.Message)"
            continue
        }
        $tags = $tagListResponse.tags | Sort-Object -Culture 'en-US'

        # Sort tags by order of semantic versioning with the latest version last
        $tags = $tags | Sort-Object -Property { [semver] $_ }

        $properties = [ordered]@{}
        foreach ($tag in $tags) {
            $gitTag = "$modulePath/$tag"
            $documentationUri = "https://github.com/Azure/bicep-registry-modules/tree/$gitTag/$modulePath/README.md"

            try {
                $moduleMainJsonUri = "https://raw.githubusercontent.com/Azure/bicep-registry-modules/$gitTag/$mainJsonPath"
                Write-Verbose "    Getting available description for tag $tag via '$moduleMainJsonUri'..." -Verbose
                $moduleMainJsonUriResponse = Invoke-RestMethod -Uri $moduleMainJsonUri
                $description = $moduleMainJsonUriResponse.metadata.description
            } catch {
                $global:anyErrorsOccurred = $true
                Write-Error "Error occurred while accessing description for tag $tag via '$moduleMainJsonUri'"
                Write-Error "Error message: $($_.Exception.Message)"
                continue
            }

            $properties[$tag] = [ordered]@{
                description      = $description
                documentationUri = $documentationUri
            }
        }

        $global:moduleIndexData += [ordered]@{
            moduleName = $modulePath
            tags       = @($tags)
            properties = $properties
        }
    } catch {
        $global:anyErrorsOccurred = $true
        Write-Error "Error message: $($_.Exception.Message)"
    }

    return ($global:anyErrorsOccurred ? $false : $true)
}
