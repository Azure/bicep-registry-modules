function Save-PSRulePackageSet {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [object[]] $Package,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Source,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Destination
    )

    $destinationPath = [IO.Path]::GetFullPath($Destination)
    if (Test-Path -LiteralPath $destinationPath) {
        throw "Package destination [$destinationPath] already exists."
    }
    foreach ($item in $Package) {
        if ($item.Name -notmatch '^[a-zA-Z0-9][a-zA-Z0-9_.-]*$' -or
            $item.Version -notmatch '^\d+\.\d+\.\d+(\.\d+)?(-[a-zA-Z0-9.-]+)?$') {
            throw 'Each requested package must have a valid name and an exact version.'
        }
    }

    $parentPath = Split-Path -Path $destinationPath -Parent
    $null = New-Item -Path $parentPath -ItemType Directory -Force -ErrorAction Stop
    for ($attempt = 1; $attempt -le 2; $attempt++) {
        $attemptPath = Join-Path $parentPath ('psrule-download-' + [guid]::NewGuid().ToString('N'))
        $null = New-Item -Path $attemptPath -ItemType Directory -ErrorAction Stop
        $invalidArchive = $false
        try {
            foreach ($item in $Package) {
                $saveParameters = @{
                    Name = $item.Name
                    RequiredVersion = $item.Version
                    Source = $Source
                    ProviderName = 'NuGet'
                    Path = $attemptPath
                    Force = $true
                    ErrorAction = 'Stop'
                }
                if ($item.AllowPrerelease) {
                    $saveParameters.AllowPrereleaseVersions = $true
                }
                $null = Save-Package @saveParameters
            }

            $identities = @{}
            $archives = @(Get-ChildItem -LiteralPath $attemptPath -File -Filter '*.nupkg' -ErrorAction Stop)
            if (-not $archives.Count) { throw 'The package download produced no archives.' }
            foreach ($file in $archives) {
                $zip = $null
                try {
                    try {
                        $zip = [IO.Compression.ZipFile]::OpenRead($file.FullName)
                        foreach ($entry in $zip.Entries) {
                            $stream = $entry.Open()
                            try { $stream.CopyTo([IO.Stream]::Null) } finally { $stream.Dispose() }
                        }
                    } catch {
                        if ($_.Exception.GetBaseException() -is [IO.InvalidDataException]) {
                            $invalidArchive = $true
                            $errorRecord = [Management.Automation.ErrorRecord]::new(
                                $_.Exception.GetBaseException(),
                                'PSRulePackageArchiveInvalid',
                                [Management.Automation.ErrorCategory]::InvalidData,
                                $file.FullName
                            )
                            throw $errorRecord
                        }
                        throw
                    }

                    $manifests = @($zip.Entries | Where-Object { $_.FullName -match '^[^/\\]+\.nuspec$' })
                    if ($manifests.Count -ne 1) { throw "Package [$($file.Name)] must contain exactly one root NuGet manifest." }
                    $settings = [Xml.XmlReaderSettings]::new()
                    $settings.DtdProcessing = [Xml.DtdProcessing]::Prohibit
                    $settings.XmlResolver = $null
                    $stream = $manifests[0].Open()
                    $reader = [Xml.XmlReader]::Create($stream, $settings)
                    try {
                        $manifest = [Xml.XmlDocument]::new()
                        $manifest.XmlResolver = $null
                        $manifest.Load($reader)
                    } finally {
                        $reader.Dispose()
                        $stream.Dispose()
                    }
                    $id = [string]$manifest.package.metadata.id
                    $version = [string]$manifest.package.metadata.version
                    $identity = "$id/$version"
                    if (-not $id -or -not $version -or $identities.ContainsKey($identity)) {
                        throw "Package [$($file.Name)] has a missing or duplicate identity."
                    }
                    $identities[$identity] = $true
                } finally {
                    if ($zip) { $zip.Dispose() }
                }
            }
            foreach ($item in $Package) {
                if (-not $identities.ContainsKey("$($item.Name)/$($item.Version)")) {
                    throw "The exact requested package [$($item.Name)/$($item.Version)] was not downloaded."
                }
            }
            [IO.Directory]::Move($attemptPath, $destinationPath)
            return $destinationPath
        } catch {
            if ($attempt -eq 2 -or -not $invalidArchive) {
                throw
            }
            Write-Warning 'A downloaded PSRule package archive is invalid. Downloading the same selected versions once into a fresh staging directory.'
        } finally {
            if (Test-Path -LiteralPath $attemptPath) {
                Remove-Item -LiteralPath $attemptPath -Recurse -Force -ErrorAction Stop
            }
        }
    }
}
