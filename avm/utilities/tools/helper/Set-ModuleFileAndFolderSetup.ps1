<#
.SYNOPSIS
Idempotently set an initial file and folder structure for an intended module path

.DESCRIPTION
Idempotently set an initial file and folder structure for an intended module path. Will setup the path if it does not exist yet.
Most files will contain an initial set of content.
Note: The ReadMe & main.json file(s) will not be generated by this script.

.PARAMETER FullModuleFolderPath
Mandatory. The full module path to create.

.PARAMETER CurrentLevelFolderPath
Optional. The level the current invocation is at. Used for recursion. Do not provide.

.EXAMPLE
Set-ModuleFileAndFolderSetup -FullModuleFolderPath '<repoPath>\avm\res\storage\storage-account\blob-service\container'

Results into:
- Added file [<repoPath>\avm\res\storage\storage-account\main.bicep]
- Added file [<repoPath>\avm\res\storage\storage-account\version.json]
- Added file [<repoPath>\avm\res\storage\storage-account\tests\e2e\default\main.test.bicep]
- Added file [<repoPath>\avm\res\storage\storage-account\tests\e2e\waf-aligned\main.test.bicep]
- Added file [<repoPath>\avm\res\storage\storage-account\blob-service\main.bicep]
- Added file [<repoPath>\avm\res\storage\storage-account\blob-service\container\main.bicep]

.EXAMPLE
Set-ModuleFileAndFolderSetup -FullModuleFolderPath '<repoPath>\avm\res\storage\storage-account'

Results into:
- Added file [<repoPath>\avm\res\storage\storage-account\main.bicep]
- Added file [<repoPath>\avm\res\storage\storage-account\version.json]
- Added file [<repoPath>\avm\res\storage\storage-account\tests\e2e\default\main.test.bicep]
- Added file [<repoPath>\avm\res\storage\storage-account\tests\e2e\waf-aligned\main.test.bicep]

#>
function Set-ModuleFileAndFolderSetup {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FullModuleFolderPath,

        [Parameter(Mandatory = $false)]
        [string] $CurrentLevelFolderPath
    )


    if ([String]::IsNullOrEmpty($CurrentLevelFolderPath)) {
        # First invocation. Handling provider namespace

        $resourceTypeIdentifier = ($FullModuleFolderPath -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] # avm/res/<provider>/<resourceType>
        $providerNamespace, $resourceType, $childResourceType = $resourceTypeIdentifier -split '[\/|\\]', 3

        $avmModuleRoot = ($FullModuleFolderPath -split $providerNamespace)[0]

        $providerNamespaceFolderPath = Join-Path $avmModuleRoot $providerNamespace
        if (-not (Test-Path $providerNamespaceFolderPath)) {
            if ($PSCmdlet.ShouldProcess("Folder [$providerNamespaceFolderPath]", "Add")) {
                $null = New-Item -Path $providerNamespaceFolderPath -ItemType 'Directory'
            }
            Write-Verbose "Added folder [$providerNamespaceFolderPath]" -Verbose
        }

        $resourceTypeFolderPath = Join-Path $avmModuleRoot $providerNamespace $resourceType
        $currentLevelFolderPath = $resourceTypeFolderPath
    }

    # Collect data
    $resourceTypeIdentifier = ($CurrentLevelFolderPath -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] # avm/res/<provider>/<resourceType>
    $isTopLevel = ($resourceTypeIdentifier -split '[\/|\\]').Count -eq 2

    # Mandatory file & folders
    # =======================
    if (-not (Test-Path $currentLevelFolderPath)) {
        if ($PSCmdlet.ShouldProcess("Folder [$currentLevelFolderPath]", "Add")) {
            $null = New-Item -Path $currentLevelFolderPath -ItemType 'Directory'
        }
        Write-Verbose "Added folder [$currentLevelFolderPath]" -Verbose
    }

    $bicepFilePath = Join-Path $CurrentLevelFolderPath 'main.bicep'
    if (-not (Test-Path $bicepFilePath)) {
        if ($PSCmdlet.ShouldProcess("File [$bicepFilePath]", "Add")) {
            $null = New-Item -Path $bicepFilePath -ItemType 'File'
        }

        $defaultTemplateSourceFilePath = Join-Path $PSScriptRoot 'src' ($isTopLevel ? 'src.main.bicep' : 'src.child.main.bicep')
        if (Test-Path $defaultTemplateSourceFilePath) {
            $defaultTemplateSourceFileContent = Get-Content -Path $defaultTemplateSourceFilePath
            if ($PSCmdlet.ShouldProcess("content for file [$bicepFilePath]", "Set")) {
                $null = Set-Content -Path $bicepFilePath -Value $defaultTemplateSourceFileContent
            }
        }
        Write-Verbose "Added file [$bicepFilePath]" -Verbose
    }

    # README can be generated by parent script
    # main.json can be generated by parent script

    # Top-level-only files & folders
    # ==============================
    if ($isTopLevel) {
        $versionFilePath = Join-Path $CurrentLevelFolderPath 'version.json'
        if (-not (Test-Path $versionFilePath)) {
            if ($PSCmdlet.ShouldProcess("File [$versionFilePath]", "Add")) {
                $null = New-Item -Path $versionFilePath -ItemType 'File'
            }

            $versionSourceFilePath = Join-Path $PSScriptRoot 'src' 'src.version.json'
            if (Test-Path $versionSourceFilePath) {
                $versionSourceFileContent = Get-Content -Path $versionSourceFilePath
                if ($PSCmdlet.ShouldProcess("content for file [$versionFilePath]", "Set")) {
                    $null = Set-Content -Path $versionFilePath -Value $versionSourceFileContent
                }
            }
            Write-Verbose "Added file [$versionFilePath]" -Verbose
        }

        $testFolderPath = Join-Path $CurrentLevelFolderPath 'tests'
        if (-not (Test-Path $testFolderPath)) {
            if ($PSCmdlet.ShouldProcess("Folder [$testFolderPath]", "Add")) {
                $null = New-Item -Path $testFolderPath -ItemType 'Directory'
            }
            Write-Verbose "Added folder [$testFolderPath]" -Verbose
        }

        $e2eTestFolderPath = Join-Path $testFolderPath 'e2e'
        if (-not (Test-Path $e2eTestFolderPath)) {
            if ($PSCmdlet.ShouldProcess("Folder [$e2eTestFolderPath]", "Add")) {
                $null = New-Item -Path $e2eTestFolderPath -ItemType 'Directory'
            }
            Write-Verbose "Added folder [$e2eTestFolderPath]" -Verbose
        }

        $defaultTestFolderPath = Join-Path $e2eTestFolderPath 'default'
        if (-not (Test-Path $defaultTestFolderPath)) {
            if ($PSCmdlet.ShouldProcess("Folder [$defaultTestFolderPath]", "Add")) {
                $null = New-Item -Path $defaultTestFolderPath -ItemType 'Directory'
            }
            Write-Verbose "Added folder [$defaultTestFolderPath]" -Verbose
        }

        $defaultTestFilePath = Join-Path $defaultTestFolderPath 'main.test.bicep'
        if (-not (Test-Path $defaultTestFilePath)) {
            if ($PSCmdlet.ShouldProcess("file [$defaultTestFilePath]", "Add")) {
                $null = New-Item -Path $defaultTestFilePath -ItemType 'File'
            }
            $defaultTestTemplateSourceFilePath = Join-Path $PSScriptRoot 'src' 'src.main.test.bicep'
            if (Test-Path $defaultTestTemplateSourceFilePath) {
                $defaultTestTemplateSourceFileContent = Get-Content -Path $defaultTestTemplateSourceFilePath

                $suggestedServiceShort = '{0}def' -f (($resourceTypeIdentifier -split '[\/|\\|-]' | ForEach-Object { $_[0] }) -join '') # e.g., npemin
                $defaultTestTemplateSourceFileContent = $defaultTestTemplateSourceFileContent -replace '<serviceShort>', $suggestedServiceShort

                $suggestedResourceGroupName = $resourceTypeIdentifier -replace '[\/|\\]', '.' -replace '-' # e.g., network.privateendpoints
                $defaultTestTemplateSourceFileContent = $defaultTestTemplateSourceFileContent -replace '<The test resource group name>', $suggestedResourceGroupName

                if ($PSCmdlet.ShouldProcess("content for file [$defaultTestFilePath]", "Set")) {

                    $null = Set-Content -Path $defaultTestFilePath -Value $defaultTestTemplateSourceFileContent
                }
            }

            Write-Verbose "Added file [$defaultTestFilePath]" -Verbose
        }

        $wafTestFolderPath = Join-Path $e2eTestFolderPath 'waf-aligned'
        if (-not (Test-Path $wafTestFolderPath)) {
            if ($PSCmdlet.ShouldProcess("Folder [$wafTestFolderPath]", "Add")) {
                $null = New-Item -Path $wafTestFolderPath -ItemType 'Directory'
            }
            Write-Verbose "Added folder [$wafTestFolderPath]" -Verbose
        }

        $wafTestFilePath = Join-Path $wafTestFolderPath 'main.test.bicep'
        if (-not (Test-Path $wafTestFilePath)) {
            if ($PSCmdlet.ShouldProcess("file [$wafTestFilePath]", "Add")) {
                $null = New-Item -Path $wafTestFilePath -ItemType 'File'
            }

            $wafTestTemplateSourceFilePath = Join-Path $PSScriptRoot 'src' 'src.main.test.bicep'
            if (Test-Path $wafTestTemplateSourceFilePath) {
                $wafTestTemplateSourceFileContent = Get-Content -Path $wafTestTemplateSourceFilePath

                $suggestedServiceShort = '{0}waf' -f (($resourceTypeIdentifier -split '[\/|\\|-]' | ForEach-Object { $_[0] }) -join '') # e.g., npemin
                $wafTestTemplateSourceFileContent = $wafTestTemplateSourceFileContent -replace '<serviceShort>', $suggestedServiceShort

                $suggestedResourceGroupName = $resourceTypeIdentifier -replace '[\/|\\]', '.' -replace '-' # e.g., network.privateendpoints
                $wafTestTemplateSourceFileContent = $wafTestTemplateSourceFileContent -replace '<The test resource group name>', $suggestedResourceGroupName

                if ($PSCmdlet.ShouldProcess("content for file [$wafTestFilePath]", "Set")) {
                    $null = Set-Content -Path $wafTestFilePath -Value $wafTestTemplateSourceFileContent
                }
            }
            Write-Verbose "Added file [$wafTestFilePath]" -Verbose
        }
    }

    # Check if there are nested modules to handle
    if ($CurrentLevelFolderPath -ne $FullModuleFolderPath) {
        # More children to handle
        $nextChild = ($FullModuleFolderPath -replace ('{0}[\/|\\]*' -f [Regex]::Escape($CurrentLevelFolderPath)) -split '[\/|\\]')[0]
        Set-ModuleFileAndFolderSetup -FullModuleFolderPath $FullModuleFolderPath -CurrentLevelFolderPath (Join-Path $CurrentLevelFolderPath $nextChild)
    }
}
